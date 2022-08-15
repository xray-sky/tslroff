# EQ.rb
# -------------
#   troff
# -------------
#
#   .EQ
#
#   http://bitsavers.trailing-edge.com/pdf/altos/3068/690-15844-001_Altos_Unix_System_V_Documenters_Workbench_Vol_2_Jul85.pdf
#
#     Begin equation (eqn) processing
#
#     troff does not alter .EQ/.EN lines, so they may be defined in macro packages to get
#     centering, numbering, etc.
#
#     use braces {} for grouping; generally speaking, anywhere you can use a single
#     character such as x, you may use a complicated construction enclosed in braces instead.
#
#     when processing between .EQ/.EN it looks like no requests or macros are processed.
#     no whitespace allowed; must end exactly with /^\.EN$/
#
#     Any argument to the .EQ macro will be placed at the right margin as an equation number.
#
#     Whitespace on input is not used to create space in the output. This includes newlines.
#     Tabs output. Spaces should be put around separate parts of the input. "pi" is not
#     recognized given the input, "f(pi)". It looks like maybe this is only important for
#     "sequences of letters".
#
#     Digits, parentheses, brackets, punctuation marks, and the following mathematical words
#     are converted to Roman font:
#     %w(sin cos tan sinh cosh tanh arc max min lim log ln exp Re Im and if for det)
#
#     As with the "sub" and "sup" keywords, size and font changes affect only the string that
#     follows and revert to the normal situation afterward.
#
#     'fat' is an allowed font style.
#     Legal font sizes are %w(6 7 8 9 10 11 12 14 16 18 20 22 24 28 36)
#     "In-line font changes must be closed before in-line equations are encountered."
#
#     If braces are not used to group functions, the eqn formatter will do operations in
#     the following order:
#
#        dyad vec under bar tllde hat dot dotdot fwd back down up
#        fat roman italic bold size
#        sub sup sqrt over
#        from to
#
#     The following operations group to the left:
#
#        over sqrt left right
#
#     All others group to the right.
#
#  words: sub sup over sqrt
#         from to left right c f
#         pile lpile cpile rpile matrix rcol
#         dot dotdot hat tilde bar vec dyad under
#         size roman italic bold font gsize gfont
#         mark lineup
#         define
#         sum int inf >= != -> (greek letters spelled out in desired case; alpha, GAMMA)
#         double quoted strings passed through untouched
#         to embolden digits, parentheses, etc. it is necessary to quote them,
#            as in bold "12.3", when used with the mm macro package.
#         displayed equations must appear only inside displays
#
# &lceil; &rceil;  &lfloor; &rfloor; (combine these into left and right brackets?)
#
# &lmoust; upper left or lower right curly bracket section
# &rmoust; upper right or lower left curly bracket section
#
# NOTE
#   Be careful about side effects calling out to other methods --
#   * unescape str vs. parse str (space adjust, breaks)
#   * req_ft and req_ps vs. parse ".ft" and parse ".ps" (@output_indicator)
#   * @register['.u'] vs. req_fi (blockproto)
#   * etc.
#
# TODO
# √ correctly space adjust (or don't) - use eqn(1) [NEWS-os 4.2.1R] lines 246, 248, 250 to test.
#   can something be done to the css to prevent breaking between Eqn and punctuation?
#     eqn(1) [SunOS 3.5] can give e.g. a sub i sup 2 with , on the next line.

module Troff
  def req_EN(*args)
    raise EndOfEqn
  end

  def req_EQ(*args)
    warn ".EQ received #{args.inspect} as margin equation number" unless args.empty?

    @state[:eqn_gfont] ||= '2' # appears the default font is italic.
    @state[:eqn_gsize] ||= Font.defaultsize

    # TODO need to parse eqn in macro args too! e.g. .BR eqn(1) [SunOS 5.5.1] :: [190]
    #      so how much would it break if we moved it ahead of the req processing,
    #      like a true preprocessor?
    #
    #      ...a lot, since we are more or less obligated to spit out Objects,
    #         rather than strings for unescaping
    #
    # REVIEW maybe we can send request lines with delims here, and parse them out that way?
    #        seems like that would be very fragile though
    loop do
      parse_eqn(next_line)
    end
  rescue EndOfEqn => e
    true
  end

  def eqn_setup
    @state[:eqn_active] = true
    @eqnhold = @current_block
    @current_block = EqnBlock.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    # save and set fonts
    @register['98'] = @register['.f'].dup
    @register['99'] = @register['.s'].dup
    req_ft @state[:eqn_gfont]
    req_ps @state[:eqn_gsize]
  end

  def eqn_restore
    @state[:eqn_active] = false
    @eqnhold << @current_block
    @current_block = @eqnhold
    # restore fonts
    # seems to happen two or more times, through various strategies
    # I guess to make sure that \s0 and \fP get cleared?
    req_ft @register['98'].to_s
    req_ft @register['98'].to_s
    req_ps @register['99'].to_s
    req_ps @register['99'].to_s
  end

  def parse_eqn(line)
    # this is a desultory first draft just to get something happening
    # and clean the no request warnings out of stderr.
    # TODO probably gonna have to disregard escaped delims. maybe mid-word delims? (or is this handled already from parse())

    # "Set apart keywords recognized by eqn with spaces, tabs, new-lines, braces, double quotes, tildes, and circumflexes."
    # "Use braces for grouping; generally speaking, anywhere you can use a single character such as x, you may use a complicated constrution enclosed in braces instead."
    # "Tilde (~) represents a full space in the output, circumflex (^) half as much."
    words = line.split
    if respond_to? "eqn_#{words[0]}"
      send "eqn_#{words[0]}", line[words[0].length + 1..-1]
    else
      case words[0]
      #when '.EN'
      #  raise EndOfEqn
      when /^[\.']/ # is request
        parse line
      else
        warn "eqn parsing #{line.inspect}"
        # I think we will want to do the delim processing outside of here, and only send
        # whatever's inside delim to parse_eqn. leave this to just doing eqn and nothing else.
        #
        # we don't, because piece-mealing the calls to unescape results in extraneous breaks
        # we can assume, however, that if we got here, there is definitely eqn to parse.
        #
        # so, if there are no delimiters, then we are in .EQ/.EN and the whole line goes

        resc = Regexp.quote @state[:escape_char]
        eqnline = ''

        unless @state[:eqn_start] and line.match?(/(?<!#{resc})#{resc}#{resc}#{Regexp.quote @state[:eqn_start]}|(?<!#{resc})#{Regexp.quote @state[:eqn_start]}/)
          # we are parsing .EQ/.EN
          #warn ".EQ parse_tree built #{eqn_parse_tree(line.dup).inspect}"

          eqn_setup
          gen_eqn eqn_parse_tree(line)
          eqn_restore

        else
          ## need to temporarily suppress :nofill
          fill = @register['.u'].value
          # req_fi breaks, has block-related side effects
          @register['.u'].value = 1
          loop do
            break if line.empty?
            rbeg = Regexp.escape @state[:eqn_start]
            rend = Regexp.escape @state[:eqn_end]
            mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rbeg}|(?<!#{resc})#{rbeg}/)
            if mark
              head = line.slice!(0..mark).chop
              mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rend}|(?<!#{resc})#{rend}/)
              #warn "eqn unterminated delim #{@state[:eqn_end].inspect}!" and break unless mark
              unless mark
                warn "eqn unterminated delim #{@state[:eqn_end].inspect}! -- pulling next line"
                line << next_line
              end
              unescape head
              eqn_setup
              gen_eqn eqn_parse_tree(line.slice!(0..mark).chop)
              eqn_restore
            else
              unescape line.slice!(0..-1)
            end
          end
          @register['.u'].value = fill
        end
      end
    end
  end

end
