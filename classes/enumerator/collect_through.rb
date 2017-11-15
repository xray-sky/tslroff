# collect_through.rb
#
#  Extends the Enumerator class
# 
#   advances the internal position until the condition provided
#   by &block is met
#
#   returns an array containing all intervening items
#

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