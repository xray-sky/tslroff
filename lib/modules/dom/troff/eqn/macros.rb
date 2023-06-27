#   .EQ
#
#   http://bitsavers.trailing-edge.com/pdf/altos/3068/690-15844-001_Altos_Unix_System_V_Documenters_Workbench_Vol_2_Jul85.pdf
#
#     Begin equation (eqn) processing
#
#     troff does not alter .EQ/.EN lines, so they may be defined in macro packages to get
#     centering, numbering, etc.
#
# TODO
# √ correctly space adjust (or don't) - use eqn(1) [NEWS-os 4.2.1R] lines 246, 248, 250 to test.
#   can something be done to the css to prevent breaking between Eqn and punctuation?
#     eqn(1) [SunOS 3.5] can give e.g. a sub i sup 2 with , on the next line.

class EndOfEqn < RuntimeError ; end

module Troff

  define_method 'EN' do |*_args|
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
