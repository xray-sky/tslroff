# adjust.rb
# ---------------
#    Troff adjustments methods
# ---------------
#

module Troff

  private

  def break_adj
    # TODO: this
  end

  def space_adj
    return if @current_block.empty? || continuation?
    # An input text line ending with ., ?, !, .), ?), or !) is taken to be the end
    # of a sentence, and an additional space character is automatically provided during
    # filling.  §4.1
    sentence_end? and @current_block << ' '
    @current_block << ' '
  end

  def it_adj
    @state[:input_trap] = Hash[ @state[:input_trap].collect do |trap, macros|
                                  [ trap += 1 , macros ]
                                end ]

  end
end
