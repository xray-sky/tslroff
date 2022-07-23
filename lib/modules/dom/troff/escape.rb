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
      # we might go through some parts of the document twice, and some of
      # the methods used by unescape are destructive of str. so dup it, to
      # protect the Source.
      copymode ? __unesc_cm(str.dup) : __unesc(str.dup)
    else
      @current_block << str
    end
  end

  # these __unesc_ methods were rewritten to avoid the use of .sub! because
  # the replacement strings could reasonably contain strings with special
  # meanings to Regexp, e.g. \', that would need special escaping.
  # split on regex followed by join with replacement seems a reasonable
  # way to avoid this complication.

  # this is used by .if
  def __unesc_star(str)	# want this in .if for testing string equality; this is the only escape that would need processing
    esc = @state[:escape_char]
    return str unless esc	# REVIEW how does this interact with copymode?
    resc = Regexp.escape(esc)
    loop do
      break unless star = str.index(/(?<!#{resc})#{resc}\*/)
      req_str = get_def_str(str[(star+2)..-1])
      str = str.split(/(?<!#{resc})#{resc}\*#{Regexp.quote(req_str)}/).join(esc_star(req_str))
    end
    str
  end # TODO is there a sensible way to make this reusable with _n and _w ?

  # this is used by getargs and .if
  def __unesc_n(str)
    esc = @state[:escape_char]
    return str unless esc	# REVIEW how does this interact with copymode?
    resc = Regexp.escape(esc)
    loop do
      break unless n = str.index(/(?<!#{resc})#{resc}n/)
      req_str = get_def_str(str[(n+2)..-1])
      str = str.split(/(?<!#{resc})#{resc}n#{Regexp.quote(req_str)}/).join(esc_n(req_str))
    end
    str
  end

  # this is used by getargs and .if
  def __unesc_w(str)
    esc = @state[:escape_char]
    # TODO this is trying to parse \\w (which shouldn't, as it's a _printing_ escape) - zwgc(1) [AOS 4.3]
    return str unless esc	# REVIEW how does this interact with copymode?
    resc = Regexp.escape(esc)
    loop do
      break unless w = str.index(/(?<!#{resc})#{resc}w/)
      req_str = get_quot_str(str[(w+2)..-1])
      str = str.split(/(?<!#{resc})#{resc}w#{Regexp.quote(req_str)}/).join(esc_w(req_str))
    end
    str
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
#            * '\\' is interpreted as '\'.
#            * '\.' is interpreted as '.'.
#            These interpretations can be suppressed by prepending a \. For example,
#            since \\ maps into a \, '\\n' will copy as '\n' which will be interpreted
#            as a number register indicator when the macro or string is reread.
#
# FIX: copy mode is currently expanding \\*(xx when it shouldn't be (double escaped)

  def __unesc_cm(str)
    copy = String.new
    until str.empty?
      c = get_char str
      case c
      when @state[:escape_char]
        esc = get_escape str[1..-1]
        esc_method = "esc_#{Troff.quote_method(esc[0])}"
        if %w[esc_n esc_star].include? esc_method
          copy << send(esc_method, esc[1..-1])
        else
          copy << case esc
                  when '.' then '.'
                  when 't' then "\t"
                  when 'a' then "\a"
                  when @state[:escape_char] then @state[:escape_char]
                  else "\\#{esc}"
                  end
        end
        str.slice! 0..esc.length  # remove processed esc from str
      else
        copy << str.slice!(0)     # remove processed chr from str
      end
    end
    copy
  end

  def __unesc(str)
    # REVIEW: are we meant to do a copy-mode pass first, then do everything else? is this how
    #         to keep .ds with stuff like \h from vanishing prematurely?? (instead of unescaping
    #         the output of \* directly in esc_star, which causes it to be parsed during assignment in .ds?)

    resc = Regexp.quote @state[:escape_char]

    # TODO: lines with escape chars prior to tabs result in that text living outside the tab span!
    #         csh(1) [GL2-W2.5]
    # - to this end, fix up the text block if we just broke. we oughtn't need to deal with
    #   a mid-unesc break.
    #
    # there's a special case if we just had a break. we don't want to set the tab width on that.
    # REVIEW: is there a more orderly way of handling this?
    #
    # TODO: split the output, with tabs and fields and translation, from unescape
    #       that's going to be hard as long as we are spitting e.g. font changes out
    #       directly into the document, instead of returning

    if broke?
      @current_block << String.new
      @current_tabstop = @current_block.text.last
      @current_tabstop[:tab_stop] = 0
    end

    # start by breaking up fields, then re-entering for each field part, if fields are enabled
    # skip entirely if all field markers are preceeded by single escape.
    # TODO: this is processing fields in too many places - in macro args, etc.
    if fields? and str =~ /(?<!(?<!#{resc})#{resc})#{Regexp.quote @state[:field_delimiter]}/
      warn "processing fields - #{str.inspect}"
      # don't match a field character preceeded by a single escape.
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

    until __unesc_star(str).empty?
      c = get_char str
      case c
      when "\t"
        # collect however many sequential tabs there might be
        count = 1
        str.slice!(0)
        while str.start_with?("\t")
          get_char str
          str.slice!(0)
          count = count + 1
        end
        stop = next_tab(count)
        if stop
          @current_tabstop.instance_variable_set(:@tab_width, "#{to_em((stop - @current_tabstop[:tab_stop]).to_s)}em")
          @current_block << '&roffctl_endspan;'
          apply {
            @current_block.text.last[:tab_stop] = stop
          }
          @current_tabstop = @current_block.text.last
        else # next_tab returns nil when we run out of tabs
          # prevent exception on running out of tabs - happening all the time, because... why?
          warn "out of tabs after #{@current_block.text.last.text.inspect} with tabs=#{@state[:tabs].inspect}! (rest: #{str.inspect})"
          @current_block << ''	# REVIEW any space at all is possibly not correct; nroff just runstexttogether when there are no more tabs
        end
      when @state[:escape_char]
        esc = get_escape str[1..-1]
        esc_method = "esc_#{Troff.quote_method(esc[0])}"
        if respond_to? esc_method
          # TODO: \* returns insead of outputting - I made this awful complex
          #       perhaps I should just make all esc_ methods return String, empty or otherwise
          @current_block << send(esc_method, esc[1..-1])#.tap { |n| warn "appending #{n.inspect} from #{esc_method.inspect}(#{esc.inspect})" }
        else
          @current_block << case esc
                            when 'a', 't' then ''                  # always ignored during output mode
                            when '_' then '_'                      # underrule, equivalent to \(ul
                            when '-' then '&minus;'                # "minus sign in current font"
                            when ' ' then '&nbsp;'                 # "unpaddable space-sized character"
                            when '0' then '&ensp;'                 # "digit-width space" - possibly "en space"?
                            when '%' then '&shy;'                  # discretionary hyphen - TODO this is overrideable, even as something that isn't an escape.
                            when '&' then '&zwj;'                  # "non-printing, zero-width character" - possibly "zero-width joiner"
                            #when '&' then ''                      # "non-printing, zero-width character" - more useful as '' except we need &zwj; for numeric align in tbl
                            when "'" then '&acute;'                # "typographically equivalent to \(aa" §23.
                            when '`' then '&#96;'                  # "typographically equivalent to \(ga" §23.
                            when '|' then '&roffctl_nrs;'          # 1/6 em      narrow space char
                            when '^' then '&roffctl_hns;'          # 1/12em half-narrow space char
                            when 'c' then '&roffctl_continuation;' # continuation (shouldn't have been space-adjusted)
                            when 'e' then @state[:escape_char].dup # printable escape char - don't push a reference, or << may modify it!
                            when @state[:escape_char] then @state[:escape_char]
                            else
                              warn "pointless escape #{esc.inspect}"
                              esc                                  # REVIEW: subject this to .tr, or not?
                            end
        end
        str.slice! 0..esc.length                                   # remove processed esc from str
      else
        translate(str.slice! 0)                                    # remove processed chr from str
      end
    end
  end

  def translate(chr = '')
    #  I probably have to protect stuff that was unescaped into an entity or anything
    #  else that was left on parts[2] from the last iteration
    #    - yes, you do. ms(5) [GL2-W2.5]
    # TODO: special chars ('\(mu') allowed in both .tr and .hc - see req_hc
    return '&shy;' if chr == @state[:hyphenation_character]
    xlc = @state[:translate][chr]
    xlc ? unescape(xlc) : (@current_block << chr)
  end

end
