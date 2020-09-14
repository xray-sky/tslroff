# escapes.rb
# ---------------
#    Troff.escapes source
# ---------------
#
# TODO: not happy about the proliferation of basically identical methods
#

module Troff

  private

  def unescape(str, copymode: nil)
    if @state[:escape_char]	# REVIEW how does this interact with copymode?
      copymode ? __unesc_cm(str) : __unesc(str)
    else
      @current_block << str
    end
  end

  def __unesc_star(str)	# want this in .if for testing string equality; this is the only escape that would need processing
    return str unless @state[:escape_char]	# REVIEW how does this interact with copymode?
    copy = String.new # TODO deal with escaped escape characters? e.g. \\n should not translate
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      copy << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              when '*' then esc_star(parts[2])
              else copy << esc ; parts[2]
              end
      else
        str = parts[2]
      end

    end until str.empty?
    copy
  end # TODO: this is the same as _nr and I think _w even. consolidate them.

  def __unesc_nr(str)
    return str unless @state[:escape_char]	# REVIEW how does this interact with copymode?
    copy = String.new # TODO deal with escaped escape characters? e.g. \\n should not translate
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      copy << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              when 'n' then esc_n(parts[2])
              else copy << esc ; parts[2]
              end
      else
        str = parts[2]
      end

    end until str.empty?
    copy
  end

  def __unesc_w(str)
    esc = @state[:escape_char]
    # TODO this is trying to parse \\w (which shouldn't, as it's a _printing_ escape) - zwgc(1) [AOS 4.3]
    return str unless esc	# REVIEW how does this interact with copymode?
    copy = String.new
    # why am I doing this separately? translation is already happening safely in esc_w
    # doing it here interferes with hiding " from argument parsing -- adb(1) [AOS 4.3]
    #@state[:translate].any? and str.gsub!(/[#{Regexp.quote(@state[:translate].keys.join)}]/) { |c| @state[:translate][c] }
    begin
      parts = str.partition(esc)
      copy << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              when 'w' then esc_w(parts[2])
              else copy << esc ; parts[2]
              end
      else
        str = parts[2]
      end

    end until str.empty?
    copy
  end

# TODO: §7.2 Copy mode input interpretation
#            During the definition and extension of strings and macros, the input is
#            read in copy mode. The input is copied without interpretation except that
#            * the contents of number registers, indicated by '\n', are substituted.
#            * Strings, indicated by '\*x' and '\*(xx', are read into the text.
#            * Arguments indicated by '\$' are replaced by the appropriate values at
#              the current macro level.
#            * Concealed new-lines indicated by '\(new-line)' are eliminated.
#            * Comments indicated by '\"' are eliminated.
#            * '\t' and '\a' are interpreted as ASCII horizontal tab and SOH respectively.
#            * \\ is interpreted as \.
#            * \. is interpreted as ".".
#            These interpretations can be suppressed by prepending a \. For example,
#            since \\ maps into a \, '\\n' will copy as '\n' which will be interpreted
#            as a number register indicator when the macro or string is reread.
#

  def __unesc_cm(str)
    copy = String.new
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      copy << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              # TODO: \$, \t, \a, \", concealed new-line
              when esc then parts[2]  # REVIEW: is this actually right??
              when '.' then parts[2]
              when /[*n]/
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                if respond_to?(esc_method)
                  send(esc_method, parts[2])
                else
                  warn "unescaped char in copy mode #{parts[2][0]} (#{parts[2][1..-1]})"
                  parts[2]
                end
              else copy << esc ; parts[2]
              end
      else
        str = parts[2]
      end

    end until str.empty?
    copy
  end

  def __unesc(str)
    # REVIEW are we meant to do a copy-mode pass first, then do everything else? is this how
    #        to keep .ds with stuff like \h from vanishing prematurely?? (instead of unescaping
    #        the output of \* directly in esc_star, which causes it to be parsed during assignment in .ds?)

    # TODO: lines with escape chars prior to tabs result in that text living outside the tab span!
    #        csh(1) [GL2-W2.5]
    # - to this end, fix up the text block if we just broke. we oughtn't need to deal with
    #   a mid-unesc break.
    #
    # there's a special case if we just had a break. we don't want to set the tab width on that.
    # REVIEW is there a more orderly way of handling this?
    if broke?
      @current_block << String.new
      @current_tabstop = @current_block.text.last
      @current_tabstop[:tab_stop] = 0
    end

    esc  = @state[:escape_char]
    resc = Regexp.quote esc

    # start by breaking up fields, then re-entering for each field part, if fields are enabled
    # don't match a field character preceeded by a single escape.
    # TODO: this is processing fields in too many places - in macro args, etc.
    if @state[:field_delimiter] and str.include?(@state[:field_delimiter])
      warn "processing fields - #{str.inspect}"
      fields = str.split(%r{(?<!(?<!#{resc})#{resc})#{Regexp.quote @state[:field_delimiter]}})
      # if the last character is a delimiter, then the last index is a field (otherwise, ordinary text)
      str = str.end_with?(@state[:field_delimiter]) ? '' : fields.pop
      # the first part is outside the field. if delim is the first character, the string will be empty
      __unesc(fields.shift)
      stop = @state[:tabs].index(next_tab)
      fields.each_with_index do |field, index|
		# this mostly mirrors tab processing
        warn "don't know how to do field padding except at right! #{@field.inspect}" unless !field.nil? or field.end_with?(@state[:field_pad_char]) # empty fields won't have padding
		__unesc(field.sub(/#{Regexp.escape(@state[:field_pad_char])}$/, '')) # TODO try with .tr instead?
		fpos = @state[:tabs][stop + index]
        if fpos.nil?
          # prevent exception on running out of tabs
          warn "out of fields with tabs=#{@state[:tabs].inspect}! (field: #{field.inspect})"
          @current_block << ' '	# REVIEW any space at all is possibly not correct; nroff just runstexttogether when there are no more tabs
        else
          @current_tabstop.instance_variable_set(:@tab_width, "#{to_em((fpos - @current_tabstop[:tab_stop]).to_s)}em")
          @current_block << '&roffctl_endspan;'
          apply {
            @current_block.text.last[:tab_stop] = stop
          }
          @current_tabstop = @current_block.text.last
        end
      end
    end

    begin

      # REVIEW this is wet
      str.gsub!(@state[:hyphenation_character], '&shy;') if @state[:hyphenation_character] != "\\%"

      # do tabs too, while we're at it, so the input line is only dissected once
      parts = str.partition(/#{resc}|\t+/)
      @current_block << translate(parts[0].sub(/&roffctl_esc;/, esc)) unless parts[0].empty? # str might begin with esc
      if parts[1] == esc
        str = case parts[2][0]
              when esc
                @current_block << esc
                parts[2].sub(/^#{resc}/, '')
              when '_' then parts[2]                             # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/,  '&minus;')       # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /,  '&nbsp;')        # "unpaddable space-sized character"
              when '0' then parts[2].sub(/^0/,  '&ensp;')        # "digit-width space" - possibly "en space"?
              when '%' then parts[2].sub(/^%/,  '&shy;')         # discretionary hyphen - TODO this is overrideable, even as something that isn't an escape.
              when '&' then parts[2].sub(/^\&/, '&zwj;')         # "non-printing, zero-width character" - possibly "zero-width joiner"
              #when '&' then parts[2].sub(/^\&/, '')              # "non-printing, zero-width character" - more useful as '' except we need &zwj; for numeric align in tbl
              when "'" then parts[2].sub(/^\'/, '&acute;')       # "typographically equivalent to \(aa" §23.
              when '`' then parts[2].sub(/^\`/, '&#96;')         # "typographically equivalent to \(ga" §23.
              when '|' then parts[2].sub(/^\|/, '&roffctl_nrs;') # 1/6 em      narrow space char
              when '^' then parts[2].sub(/^\^/, '&roffctl_hns;') # 1/12em half-narrow space char
              when 'c' then parts[2].sub(/^c/,  '&roffctl_continuation;') # continuation (shouldn't have been space-adjusted)
              else
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                if respond_to?(esc_method)
                  send(esc_method, parts[2])
                else
                  warn "pointlessly escaped char #{parts[2][0].inspect}? (rest: #{parts[2][1..-1].inspect})"
                  parts[2]
                end
              end
      elsif parts[1].start_with?("\t")
        stop = next_tab(parts[1].length)
        if stop.nil?
          # prevent exception on running out of tabs - happening all the time, because... why?
          warn "out of tabs after #{parts[0].inspect} with tabs=#{@state[:tabs].inspect}! (rest: #{parts[2][1..-1].inspect})"
          @current_block << ' '	# REVIEW any space at all is possibly not correct; nroff just runstexttogether when there are no more tabs
        else
          @current_tabstop.instance_variable_set(:@tab_width, "#{to_em((stop - @current_tabstop[:tab_stop]).to_s)}em")
          @current_block << '&roffctl_endspan;'
          apply {
            @current_block.text.last[:tab_stop] = stop
          }
          @current_tabstop = @current_block.text.last
        end
        str = parts[2]
      else # no tabs or esc chars remain in str
        str = parts[2]
      end

    end until str.empty?
  end

  def translate(str = '')
    #  I probably have to protect stuff that was unescaped into an entity or anything
    #  else that was left on parts[2] from the last iteration
    #    - yes, you do. ms(5) [GL2-W2.5]
    #  Ruby lookbehinds must be of deterministic length.
    #  Also this is apparently quite slow - what can be done? REVIEW
    #@state[:translate].any? ? str.gsub(/(?<!\&)(?<!\S)*?[#{Regexp.quote(@state[:translate].keys.join)}](?!\S*?;)/) { |c| @state[:translate][c] } : str
    if @state[:translate].any?
      ent_regx = %r{(?:\&\S+?;)}
      entities = str.scan(ent_regx)
      str.split(ent_regx).collect do |substr|
        [ substr.gsub(%r{[#{Regexp.quote(@state[:translate].keys.join)}]}) { |c| @state[:translate][c] },
          entities.shift ]
      end.flatten.join
    else
      str
    end
  end

end
