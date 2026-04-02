# frozen_string_literal: true
#
# escapes.rb
# ---------------
#    Troff.escapes source
# ---------------
#
# TODO not happy about the proliferation of basically identical methods
#

class Troff

  private

  def unescape(str, copymode: nil, output: nil)
    # REVIEW how does @escape_character interact with copymode?
    if copymode
      return __unesc_cm(str) # no longer destructive of str
    end

    if output
      hold_block = @current_block
      @current_block = output
    end

    # eqn delims can be hidden by escaping them
    resc = Regexp.quote @escape_character || ''
    if @eqn_start and str.match?(/(?<!#{@resc})#{@resc}#{@resc}#{Regexp.quote @eqn_start}|(?<!#{@resc})#{Regexp.quote @eqn_start}/)
      parse_eqn str
    else
      __unesc(str.dup)
    end

    @current_block = hold_block if output
  end

  # Perform a single unescape class on a string. These must always return plain String types
  # e.g. \w, \n, \* -- nothing that could emit typesetter state or an object, e.g. \f, \h

  def __unesc_single(str)
    return str unless escapes?
    method = __callee__.to_s[-1]

    i = 0
    out = String.new
    resc = Regexp.escape @escape_character
    rmethod = Regexp.escape method # could be '*'
    loop do
      break unless e = str.index(/(?<!#{@resc})#{@resc}#{rmethod}/, i)
      out << str[i..e - 1] unless e.zero?
      esc = get_char str[e..-1]
      out << send("esc_#{method}", esc[2..-1])
      i = e + esc.length
    end
    out << str[i..-1]
  end

  alias :'__unesc_*' :__unesc_single
  #alias :__unesc_n :__unesc_single
  alias :__unesc_w :__unesc_single

# §7.2
#
# Copy mode input interpretation
#
#   During the definition and extension of strings and macros, the input is
#   read in copy mode. The input is copied without interpretation except that
#
#     * the contents of number registers, indicated by '\n', are substituted.
#     * Strings, indicated by '\*x' and '\*(xx', are read into the text.
#     * Arguments indicated by '\$' are replaced by the appropriate values at
#         the current macro level.
#     * Concealed new-lines indicated by '\(new-line)' are eliminated.
#     * Comments indicated by '\"' are eliminated.
#     * '\t' and '\a' are interpreted as ASCII horizontal tab and SOH respectively.
#     * '\\' is interpreted as '\'.
#     * '\.' is interpreted as '.'.
#
#   These interpretations can be suppressed by prepending a \. For example,
#   since \\ maps into a \, '\\n' will copy as '\n' which will be interpreted
#   as a number register indicator when the macro or string is reread.
#
# We do it right-to-left, since \*(\n(aa and \*(\*(ab and \n(\*(ac and \n(\n(ad (...etc...) are allowed

  def __unesc_cm(str)
    return str unless escapes?
    copy = String.new
    strend = str.length
    while i = str.rindex(/(?<!#{@resc})#{@resc}[.*"ant]|#{@resc}#{@resc}/, strend) and !(strend < 0)
      esc = get_escape(str, offset: i)
      copy.prepend str[i + esc.length..strend]
      case esc[1]
      when @escape_character then copy.prepend @escape_character
      when '.' then copy.prepend '.'
      when 't' then copy.prepend "\t" # tab
      when 'a' then copy.prepend "\a" # SOH
      when 'n' then copy.prepend esc_n esc[2..-1]
      when '*' then copy.prepend send 'esc_*', esc[2..-1]
      when '"' then # \" comment
        #@current_block << Comment.new(text: copy) # TODO wrong
        copy = String.new
      end
      strend = i - 1
    end
    copy.prepend str[0..strend] unless strend < 0
    copy
  end

  def __unesc(str)
    # we may have more \* or \n emitted from an \* interpreted in copy mode
    # but they don't appear to combine the way they are allowed to in copy mode.
    # ...or at the very least they maybe go berzerk in a way that is enough to suggest
    # we'll never see it happen? that'll be a relief. REVIEW
    #
    # TODO unescaped trailing whitespace gets stripped after \* expanded
    # I think that's the only way we could get "unexpected" trailing whitespace
    #
    # TODO if this works, get the hyphenation character into it
    #      check it works with escapes disabled, too.

    # start with a copy mode style r-to-l replacement of \* and \n and \w to collect
    # all the changes to the input text

    if escapes?
      exp = String.new
      strend = str.length
      while i = str.rindex(/(?<!#{@resc})#{@resc}[*"nw]/, strend) and !(strend < 0)
        esc = get_escape(str, offset: i)
        exp.prepend str[i + esc.length..strend]
        case esc[1]
        when 'n' then exp.prepend esc_n esc[2..-1]
        when 'w' then exp.prepend esc_w esc[2..-1]
        when '*' then exp.prepend send 'esc_*', esc[2..-1]
        when '"' then # \" comment
          #@current_block << Comment.new(text: copy) # TODO wrong
          exp = String.new
        end
        strend = i - 1
      end
      exp.prepend str[0..strend] unless strend < 0
      str = exp
    end

    strpos = 0
    # cut any unescaped trailing whitespace we might've introduced by expanding \*
    strlen = str.sub!(/((?<!#{@resc})#{@resc} )? *$/, '\1').length

    xlations = @character_translations.keys
    xlate = if escapes?
              xlations.empty? ? %r{\t|#{@resc}} : %r{\t|#{@resc}|#{xlations.map { |x| Regexp.escape x }.join('|')}}
            else
              xlations.empty? ? %r{\t} : %r{\t|#{xlations.map { |x| Regexp.escape x }.join('|')}}
            end
    while i = str.index(xlate, strpos)
      @current_block << str[strpos..i - 1] unless i == 0
      c = get_char str[i..-1]
#                            warn "unesc xlating #{c.inspect}"
      case c
      when @hyphenation_character then @current_block << '&shy;'

      when "\t"
        # collect however many sequential tabs there might be
        count = 1
        while str[i + 1] == "\t"
          i += 1
          count += 1
        end
        stop = next_tab(count)
        if stop
          insert_tab(width: to_em(stop - @current_block.last_tab_position), stop: stop)
        else # next_tab returns nil when we run out of tabs
          # prevent exception on running out of tabs - happening all the time, because... why?
          warn "out of tabs after #{@current_block.terminal_string.inspect} with tabs=#{@tabstops.inspect}! (rest: #{str.inspect})"
          @current_block << ' '	# REVIEW any space at all is possibly not correct; nroff just runstexttogether when there are no more tabs
                                # I choose to insert the space because of rogue tabs in e.g. fnattr(1) [SunOS 5.5.1]
        end

      when *xlations
        xlc = @character_translations[c].dup
        if xlc.start_with? "\e"
          oesc = @escape_character
          ec "\e"
          __unesc(xlc)
          ec oesc
        else
          @current_block << xlc
        end

      else # an escape
        @current_block << case c[1] #esc
                          # TODO \{ and \} separate from .if appears to output nothing printable.
                          # thus, should break if appearing on a line with only spaces or by itself. (...maybe?)
                          when 'n', 'w', '*' then c              # don't interpret \n, \w, or \* again, we already did them above
                          when 'a', 't' then ''                  # always ignored during output mode; "\a" is "non-interpreted leader character"
                          when '_' then '_'                      # underrule, equivalent to \(ul
                          when '-' then '&minus;'                # "minus sign in current font"
                          when ' ' then '&nbsp;'                 # "unpaddable space-sized character"
                          when '0' then '&ensp;'                 # "digit-width space" - possibly "en space"?
                          when '%' then '&shy;'                  # discretionary hyphen - TODO this is overrideable, even as something that isn't an escape.
                          when "'" then '&acute;'                # "typographically equivalent to \(aa" §23.
                          when '`' then '&#96;'                  # "typographically equivalent to \(ga" §23.
                          #when '&' then ''                      # "non-printing, zero-width character"
                          when 'H' then warn 'uncertain use of \\H (char height)' ; '' # p.24 - default unit 'p' TODO this is wrong, it has an arg we need to advance past
                          when 'S' then warn 'uncertain use of \\S (char slant)' ; '' # p.26 also wrong
                          when '&' then @current_block.style[:numeric_align] ? '&zwj;' : '' # more useful as '' except we need &zwj; for numeric align in tbl
                          when '|' then NarrowSpace.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)          # 1/6 em      narrow space char
                          when '^' then HalfNarrowSpace.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)      # 1/12em half-narrow space char
                          when 'e', @escape_character then @escape_character.dup # printable escape char - don't push a reference, or << may modify it!
                          when 'c' # apparently everything past the \c is discarded
                            i = strlen - 2 # we're done (leave 2 chars left from end, we'll add \c at the end of the loop)
                            Continuation.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup) # continuation (shouldn't have been space-adjusted) pdx(1) [SunOS 1.0]
                          when '*' # need to handle \* as a special case
                            # potentially need to unescape its contents
                            # REVIEW will we need to deal with \*(\n(.. ??
                            # REVIEW will this need to go through output, for field processing??
                            __unesc(send 'esc_*', c[2..-1])
                            ''
                          when 'p'
                            if fill?
                              warn 'uncertain use of \\p (fill break)' # p.29
                              # TODO this breaks at _end of word_, which might not be where the \p is
                              # REVIEW should also cause the line to be justified normally
                              LineBreak.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
                            else
                              ''
                            end
                          else
                            #warn "unesc elsed #{c.inspect}"
                            if respond_to? esc_method = "esc_#{c[1]}"
                              send esc_method, c[2..-1]
                            else
                              warn "pointless escape #{c.inspect}"
                              c[1..-1]
                            end
                          end
      end
      strpos = i + c.length
    end
    @current_block << str[strpos..-1]
  end

  # REVIEW does this correctly fail to translate _input_ escapes if escapes
  #        are turned off, or the escape character has changed? I think so,
  #        since it won't be read as an escape by get_char.
  #
  # TODO mostly unneeded now, track down remaining uses and rewrite

  #def translate(chr = '')
  #  return '&shy;' if chr == @hyphenation_character
  #  xlc = @character_translations[chr]&.dup or return @current_block << chr
  #  #return @current_block << chr unless xlc
  #  return @current_block << xlc unless xlc.start_with?("\e")
  #  oesc = @escape_character
  #  ec "\e"
  #  __unesc(xlc)
  #  ec oesc
  #end

end
