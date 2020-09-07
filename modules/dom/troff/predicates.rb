# predicates.rb
# ---------------
#    Troff predicate routines
# ---------------
#

module Troff

  private

  def broke?
    #@current_block.type != :cell && @current_block.text.last.text.match(/&roffctl_br;\s+$/)
    @current_block.empty? || @current_block.text[-2].is_a?(LineBreak) # TODO this fails if, for example, we have .PP -> .vs -> \ \ foo -- mset(1) [AOS 4.3]
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
    @register['.u'].value == 1
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
    @current_block.text.last.text.match(/(?:\!|\.|\?)\)?$/)
  end

  def self.macro?(req)
    req.length.between?(1,2) and req.upcase == req
  end

  def self.req?(line)
    line.match(/^[\.\']\s*\S{1,2}\s*(?:\S.*|$)/)
  end

end
