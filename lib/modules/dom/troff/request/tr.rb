# frozen_string_literal: true
#
# tr.rb
# -------------
#   troff
# -------------
#
#   §10.5
#

class Troff
  # Request      Initial   If no     Notes   Explanation
  #  form         value    argument
  #
  # .tr abcd...  none     -          O       Translate 'a' into 'b', 'c' into 'd', etc.
  #                                          If an odd number of characters is given, the
  #                                          last one will be mapped into the space
  #                                          character. To be consistent, a particular
  #                                          translation must stay in effect from input to
  #                                          output time. To reset '.tr', follow request
  #                                          with previous arguments given in duplicate.
  #                                          The example given at the start of this entry,
  #                                          for instance, would be turned off as follows:
  #                                          '.tr aacc'.
  #
  # All text processing (e.g., character comparisons) takes place with the input
  # (stand-in) character which appears to have the width of the final character. The
  # graphic translation occurs at the moment of output (including diversions).
  #
  # This is not a strict one-to-one arrangement. Constructs like \& and \(**
  # are allowed for the either the given or substituted character.
  #
  # See csh(1) [GL2-W2.5], eqn(1) [Rhapsody DR2] for examples.
  #
  #
  # based on an infinite loop in ar(5) [SunOS 0.3] resulting from the combination of
  # .tr *\(** and .ec % I infer (and observe from troff itself) that the escape is
  # considered to have been processed at the moment of .tr and needn't still be active
  # for the translation to be effective.
  #
  # This does _not_ extend to escapes in named strings however, nor the _input_ part
  # of the equation. given .tr \(ts", no translation occurs if the escape char is
  # changed, or escapes disabled entirely. (e.g. the "special character" \(ts is not
  # the same thing as the four-character string "\(ts")
  #
  # To facilitate this behavior, we will use ASCII ESC to indicate a "permanent" escape
  # for the output side. We should (SHOULD) never see an \x1B (\e) in legit input.

  def tr(argstr = '', breaking: nil)
    return nil if argstr.empty?
    warn "enabling .tr for #{argstr.inspect}"
    begin
      a = argstr.slice!(0, get_char(argstr).length)
      b = argstr.slice!(0, get_char(argstr)&.length || 0)
      case b
      when a then @character_translations.delete(a)
      when '' then @character_translations[a] = ' '
      else
        @character_translations[a] = (@escape_character ? b.sub(/^#{Regexp.quote @escape_character}/, "\e") : b)
      end
    end until argstr.empty?
  end

  def init_tr
    @character_translations = Hash.new
    # set a default_proc which will allow us to output everything
    # through translation whether there are any translations or not.
    @character_translations.default_proc { |_h, c| c }
    true
  end
end
