# tr.rb
# -------------
#   troff
# -------------
#
#   §10.5
#
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
# Unfortunately this is not a strict one-to-one arrangement. Constructs like \& and \(**
# are allowed for the substituted "character". See csh(1) [GL2-W2.5] for example.
#
# TODO: apparently they're also allowed for the input character. .tr \(ts" appears in
#       eqn(1) [Rhapsody DR2]
#

module Troff
  def req_tr(str)
    warn "enabling .tr for #{str.inspect}"
    begin
      a = str.slice!(0)
      b = str.slice!(0)
      case b
      when a then @state[:translate].delete(a)
      when '\\'
        b << str.slice!(0)
        case b[1]
        when '('
          b << str.slice!(0..1)
          @state[:translate][a] = b
        when '*'
          b << str.slice(0)
          b[2] == '(' and b << str.slice!(0..1)
          @state[:translate][a] = b
        else @state[:translate][a] = b
        end
      else @state[:translate][a] = b
      end
    end until str.empty?
  end

  def init_tr
    @state[:translate] = Hash.new
    true
  end
end
