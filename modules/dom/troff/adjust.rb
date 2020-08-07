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

    # check for input traps before we trip the output indicator
    process_input_traps if @current_block.output_indicator?

    # An input text line ending with ., ?, !, .), ?), or !) is taken to be the end
    # of a sentence, and an additional space character is automatically provided during
    # filling.  §4.1
    sentence_end? and @current_block << ' '
    @current_block << ' '

    # this is a bit janky, but we need to avoid the space adjustment tripping the
    # output indicator, in order to correctly account for input line traps through
    # macros which do or do not output (i.e. count as an input line)
    @current_block.reset_output_indicator
  end

  def it_adj
    @state[:input_trap] = Hash[ @state[:input_trap].collect do |trap, macros|
                                  [ trap += 1 , macros ]
                                end ]

  end
end
