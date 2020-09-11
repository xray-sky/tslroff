# predicates.rb
# ---------------
#    Troff predicate routines
# ---------------
#

module Troff

  private

  def broke?
    return true if @current_block.empty?
    return true if @current_block.text.last.text.is_a?(LineBreak)
    if @current_block.text[-2]&.text and !@current_block.text[-2].text.is_a?(LineBreak)
      return true if @current_block.text[-2].text.start_with?('&roffctl_vs')
    end
    false
  end

  def continuation?
    @current_block.to_s.match(/&roffctl_continuation;$/)
  end

  def adj?
    @state[:adjust] == true
  end

  def noadj?
    @state[:adjust] == false
  end

  def fill?
    @register['.u'] == 1
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
    !broke? and @current_block.text.last.text.match(/(?:\!|\.|\?)\)?$/)
  end

  def self.macro?(req)
    req.length.between?(1,2) and req.upcase == req
  end

  def self.req?(line)
    line.match(/^[\.\']\s*\S{1,2}\s*(?:\S.*|$)/)
  end

end
