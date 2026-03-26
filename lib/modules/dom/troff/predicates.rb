# predicates.rb
# ---------------
#    Troff predicate routines
# ---------------
#
# frozen_string_literal: true
#

class Troff

  private

  def nobreak?
    @break_suppressed
  end

  def broke?
    return true if @current_block.empty?
    return true if @current_block.terminal_text_obj.is_a?(LineBreak) # REVIEW this probably never happens anymore,
                                                             # since << LineBreak automatically appends another empty Text after
    return true if @current_block.text[-2].is_a?(LineBreak) and @current_block.terminal_text_obj.empty?.tap{ |n| "last is empty? #{n.inspect}" }
    return true if @current_block.text[-2].is_a?(VerticalSpace) and @current_block.terminal_text_obj.empty?
    false
  end

  def adj?
    @adjust == true
  end

  def noadj?
    @adjust == false
  end

  def fill?
    @register['.u'] > 0
  end

  def nofill?
    @register['.u'].zero?
  end

  def space?
    @nospace.nil?
  end

  def nospace?
    @nospace == true
  end

  def sentence_end?
    #!broke? and !@current_block.terminal_string.is_a?(RoffControl) and @current_block.terminal_string.match?(/[?!\.]\)?$/)
    !broke? and !@current_block.text[-2].is_a?(RoffControl) and @current_block.terminal_string.match?(/[?!\.]\)?$/)
  end

  def escapes?
    !@escape_character.nil?
  end

  def fields?
    !@field_delimiter.nil?
  end
end
