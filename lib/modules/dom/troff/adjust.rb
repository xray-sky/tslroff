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
    @current_block.text.pop if @current_block.text.last.text.is_a?(LineBreak)
  end

  def space_adj
    return if @current_block.empty? || broke? || continuation?

    # check for input traps before we trip the output indicator
    #process_input_traps if @current_block.output_indicator?

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

  end

end
