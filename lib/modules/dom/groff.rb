# groff.rb
# ---------------
#    groff main
# ---------------
#
#   https://www.gnu.org/software/groff/manual/groff.html#gtroff-Reference
#
#
# TODO
#   requests/macros MUST be followed by a space, because there are some longer than two characters?
#   I see .als, .mso, .while, .shift, .chop - what else?
#   has extra units allowed in expressions (s, z, f, M)
#   has extra escapes (\A, \B)
#   .if !\n(.g apparently works as a test for groff
#

require_relative 'groff/tokenize.rb'

module Groff

  def init_nr_groff
    @register['.g'] = Register.new(1, ro: true)
  end

end
