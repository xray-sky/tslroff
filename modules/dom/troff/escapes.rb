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

module Troff

  private

  def unescape(str, copymode: nil)
    copymode ? __unesc_cm(str) : __unesc(str)
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
    @state[:translate].any? and str.gsub!(/[#{Regexp.quote(@state[:translate].keys.join)}]/) { |c| @state[:translate][c] }
    esc = @state[:escape_char]
    begin
      parts = str.partition(esc)
      @current_block << parts[0].sub(/&roffctl_esc;/, esc) unless parts[0].empty? # str might begin with esc

      if parts[1] == esc
        str = case parts[2][0]
              when esc then parts[2].sub(/^#{Regexp.quote(esc)}/, '&roffctl_esc;')  # REVIEW: is this actually right?? does changing it prevent \*S from working??
              when '_' then parts[2]                             # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/,  '&minus;')       # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /,  '&nbsp;')        # "unpaddable space-sized character"
              when '0' then parts[2].sub(/^0/,  '&ensp;')        # "digit-width space" - possibly "en space"?
              when '%' then parts[2].sub(/^%/,  '&shy;')         # discretionary hyphen
              #when '&' then parts[2].sub(/^\&/, '&zwj;')         # "non-printing, zero-width character" - possibly "zero-width joiner"
              when '&' then parts[2].sub(/^\&/, '')              # "non-printing, zero-width character" - more useful as ''
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
                  warn "unescaped char in line #{@state[:register]['.c'].value}: #{parts[2][0].inspect} (#{parts[2][1..-1].inspect})"
                  parts[2]
                end
              end
      else # no esc chars remain in str
        str = parts[2]
      end

    end until str.empty?
  end

end
