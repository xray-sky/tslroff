# collect_through.rb
#
#  Extends the Enumerator class
#
#   advances the internal position until the condition provided
#   by &block is met
#
#   returns an array containing all intervening items
#
#
# REVIEW: have I reimplemented .take_while ?!? maybe not; calling .take_while
#         on Enumerator (vs. using it to create one) doesn't account for or
#         affect internal state.
# REVIEW: can this be replaced by better using Enumerable methods like .detect
#         or maybe automatically generating callback methods, since this fucks
#         up input line counting, etc.

class Enumerator
  def collect_through(&block)
    return enum_for(__callee__) unless block_given?
    result = Array.new
    loop do
      result << self.peek
      break if yield(self.next)
    end
    result
  end
end
