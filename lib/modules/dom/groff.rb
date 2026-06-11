# frozen_string_literal: true
#
# groff.rb
# ---------------
#    groff main
# ---------------
#
#   https://www.gnu.org/software/groff/manual/groff.html#gtroff-Reference
#
# TODO
#   requests/macros MUST be followed by a space, because there are some longer than two characters?
#   I see .als, .mso, .while, .shift, .chop - what else?
#   has extra units allowed in expressions (s, z, f, M)
#   has extra escapes (\A, \B)
#   .if !\n(.g apparently works as a test for groff
#   386BSD (UCB) manual includes groff
#       probably useful reference for getting started on differences from troff, tbl, eqn, etc.
#

#require_relative '../../classes/textformatter'
require_relative 'troff'
require_relative 'groff/tokenize'

# REVIEW this inheritance relationship
class Groff < Troff

  def init_nr_groff
    @register['.g'] = Register.new(1, ro: true)
  end

  # invalid identifiers are empty or contain spaces, tabs, newlines, or escape sequences that
  # interpolate something other than a sequence of ordinary characters.
  # \A'ident' 1 if valid; 0 if not -- https://www.gnu.org/software/groff/manual/groff.html.node/Identifiers.html
  def identifier?(str)
    # TODO inadequate
    str.match?(/[\s\n]/) ? false : true
  end

  # groff mounts named fonts to next available pos on first reference.
  def ft(argstr = '', breaking: nil)
    f = argstr[0..1].strip
    pos = case f
          when 'P', '' then @previous_fp
          when /^[A-Z][A-Z]?$/
            @font_positions[f] || (fp = @font_positions.find_index(nil) || @font_positions.length ; warn "automatically mounted font #{f} on position #{fp}" ; mount_font(fp, f)) # mount it on next available position
          else f.to_i
          end
    @previous_fp = @register['.f'].value
    @register['.f'].value = pos
    activate_font
    ''
  end

end
