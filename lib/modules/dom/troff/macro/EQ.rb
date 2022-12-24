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

  define_method 'EN' do |*args|
    raise EndOfEqn
  end

  define_method 'EQ' do |*args|
    warn ".EQ received #{args.inspect} as margin equation number" unless args.empty?

    @state[:eqn_gfont] ||= '2' # appears the default font is italic.
    @state[:eqn_gsize] ||= Font.defaultsize

    loop do
      parse_eqn(next_line, inline: false)
    end
  rescue EndOfEqn => e
    true
  end

end
