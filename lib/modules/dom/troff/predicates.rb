# predicates.rb
# ---------------
#    Troff predicate routines
# ---------------
#

module Troff

  private

  def broke?
    #return false if @current_block.is_a? String # we are trying to reduce() an escape
    return true if @current_block.empty?
    #return true if @current_block.text.last.text.is_a?(LineBreak)
    return true if @current_block.text.last.is_a?(LineBreak)
    #if @current_block.text[-2]&.text and !@current_block.text[-2].text.is_a?(LineBreak)
    if !@current_block.text[-2].is_a?(LineBreak)
      #return true if @current_block.text.last.text.empty? and @current_block.text[-2].text.start_with?('&roffctl_vs')
      return true if @current_block.text.last.text.empty? and @current_block.text[-2].is_a? VerticalSpace
    end
    false
  end

  # was only used by space_adj, now redundant since Continuation became a RoffControl
  # and an empty Text will always follow one that has been Block <<'ed
  #
  #def continuation?
  #  #@current_block.to_s.match(/&roffctl_continuation;$/)
  #  #@current_block.text.last.is_a? Continuation
  #  # We've already appended an extra Text object in order to avoid writing into Continuation.text
  #  # REVIEW maybe it's sensible to let Continuation be written into, let it be a straight subclass
  #  #        of Text, treat it as effectively just another name for Text
  #  #@current_block.text[-2].is_a? Continuation
  #  #@current_block.text.last.is_a? Continuation
  #  # no, we do not want to let Continuation be another name for Text, as it screws up space_adj
  #  @current_block.text[-2].is_a? Continuation
  #end

  def adj?
    @state[:adjust] == true
  end

  def noadj?
    @state[:adjust] == false
  end

  def fill?
    @register['.u'] > 0
  end

  def nofill?
    @register['.u'].zero?
  end

  def space?
    @state[:nospace].nil?
  end

  def nospace?
    @state[:nospace] == true
  end

  def sentence_end?
    !broke? and !@current_block.text.last.text.is_a?(RoffControl) and @current_block.text.last.text.match?(/[?!\.]\)?$/)
  end

  def escapes?
    !@state[:escape_char].nil?
  end

  def fields?
    !@state[:field_delimiter].nil?
  end

  def self.macro?(req)
    # TODO a macro with lowercase letters is not illegal
    req.length.between?(1,2) and req.upcase == req
  end

  def self.req?(line)
    # TODO these request characters are selectable
    line.match(/^[\.\']\s*\S{1,2}\s*(?:\S.*|$)/)
  end

end
