# adjust.rb
# ---------------
#    Troff adjustments methods
# ---------------
#

module Troff

  private

  def break_adj
    # TODO: this - I'm taking this over to erase end-of-block breaks, because I don't
    #              remember what this was originally supposed to be about
    if @current_block.text.length > 1
      end_of_block = @current_block.text[-2..-1]
      if end_of_block[0].is_a?(LineBreak) and end_of_block[1].empty?
        @current_block.text.pop
        @current_block.text.pop
      end
    end
  end

  def space_adj
    return if @current_block.empty? || continuation?

    # check for input traps before we trip the output indicator
    process_input_traps if @current_block.output_indicator?

    # janky hack to prevent space adjusting after .IP tag (once)
    if @current_block.text.last.instance_variable_defined?(:@no_space_adj)
      @current_block.text.last.remove_instance_variable(:@no_space_adj)
      return
    end

    # An input text line ending with ., ?, !, .), ?), or !) is taken to be the end
    # of a sentence, and an additional space character is automatically provided during
    # filling.  §4.1
    sentence_end? and @current_block << ' '
    @current_block << ' '

    # this is a bit janky, but we need to avoid the space adjustment tripping the
    # output indicator, in order to correctly account for input line traps through
    # macros which do or do not output (i.e. count as an input line)
    #
    # well... it has to be reset _somewhere_. just make sure you do everything
    # that relies on it before space_adj.

    @current_block.reset_output_indicator
  end

  def it_adj
    @state[:input_trap] = Hash[ @state[:input_trap].collect do |trap, macros|
                                  [ trap += 1 , macros ]
                                end ]

  end
end
