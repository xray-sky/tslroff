# getargs.rb
# ---------------
#    Troff.getargs source
# ---------------
#
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
#
# TODO: not happy about the proliferation of basically identical methods
#

module Troff

  private

  def unescape(str, copymode: nil)
    copymode ? __unesc_cm(str) : __unesc(__unesc_cm(str))
  end

  def __unesc_nr(str)
    copy = String.new
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
    copy = String.new
    # why am I doing this separately? translation is already happening safely in esc_w
    # doing it here interferes with hiding " from argument parsing -- adb(1) [AOS 4.3]
    #@state[:translate].any? and str.gsub!(/[#{Regexp.quote(@state[:translate].keys.join)}]/) { |c| @state[:translate][c] }
    begin
      esc   = @state[:escape_char]
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
    @state[:translate].any? and str.gsub!(/[#{Regexp.quote(@state[:translate].keys.join)}]/) { |c| @state[:translate][c] }
    esc = @state[:escape_char]
    begin
      # do tabs too, while we're at it, so the input line is only dissected once
      parts = str.partition(/#{Regexp.quote(esc)}|\t+/)
      @current_block << parts[0].sub(/&roffctl_esc;/, esc) unless parts[0].empty? # str might begin with esc

      if parts[1] == esc
        str = case parts[2][0]
              when esc then parts[2].sub(/^#{Regexp.quote(esc)}/, '&roffctl_esc;')  # REVIEW: is this actually right?? does changing it prevent \*S from working??
              when '_' then parts[2]                             # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/,  '&minus;')       # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /,  '&nbsp;')        # "unpaddable space-sized character"
              when '0' then parts[2].sub(/^0/,  '&ensp;')        # "digit-width space" - possibly "en space"?
              when '%' then parts[2].sub(/^%/,  '&shy;')         # discretionary hyphen
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
        stop = @state[:tabs].last and warn "out of tabs after #{parts[1].inspect} with tabs=#{@state[:tabs].inspect}! (rest: #{parts[2][1..-1].inspect})" if stop.nil? # should prevent exception on running out of tabs, but will result in overlapping text boxes - seems necessary? see a.out(5) [AOS 4.3]
        @current_tabstop.instance_variable_set(:@tab_width, "#{to_em((stop - @current_tabstop[:tab_stop]).to_s)}em")
        @current_block << '&roffctl_endspan;'
        apply {
          @current_block.text.last[:tab_stop] = stop
        }
        @current_tabstop = @current_block.text.last
        str = parts[2]
      else # no tabs or esc chars remain in str
        str = parts[2]
      end

    end until str.empty?
  end

end
