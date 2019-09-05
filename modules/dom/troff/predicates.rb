# predicates.rb
# ---------------
#    Troff predicate routines
# ---------------
#

module Troff

  private

  def broke?
    @current_block.text.last.text.match(/&roffctl_br;\s+$/)
  end

  def continuation?
    @current_block.to_s.match(/&roffctl_continuation;$/)
  end

  def fill?
    @state[:register]['.u'].zero? ? false : true
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
