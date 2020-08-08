# RS.rb
# -------------
#   troff
# -------------
#
#   .RS in
#
#     Increase relative indent (initially zero). Indent all output an extra in units
#     from the current left margin.
#
#   this works like a stack (see .RE)
#   tmac.an tracks the stack depth in )p
#                  the current indent )I is saved in ]1 -- ]9 (depending on value of )p) (this would be set by HP or TP)
#                  the current indent )R is saved in )1 -- )9 (depending on value of )p)
#                  the new indent is )R -- either the arg in (en) is added to it or it goes up by )I
#                  the new )I is )M (u) (3.6m for troff; 5n for nroff)
#          --alt-- the new )I is 0.5i (== 3.6m)
#
#   note: "all output"
#
# TODO: make this use .in under the covers?
#

module Troff

  def req_RS(indent = nil)
    # troff won't tolerate more than 9 levels of indent even though theoretically we could
    raise RuntimeError "out of stack space for indents in .RS at line #{input_line_number}" if @register[')p'].value == 9
    @register[')p'].+
    @register["]#{@register[')p'].value}"].value = @register[')I'].value
    @register[")#{@register[')p'].value}"].value = @register[')R'].value
    @register[')R'].value += if indent
      # divert the width; don't let it get into the output stream.
      @current_block = Block.new(type: :bare)
      unescape(indent)
      to_u(@current_block.text.pop.text.strip, :default_unit => 'n').to_i
    else
      @register[')I'].value
    end
    req_in("#{@register[')R'].value}u")
    init_IP
  end

  def init_RS
    @register[')R'] = Register.new(to_u('2m'))   # 2em is the base indent from the CSS -- also declared in blockproto
    @register[')p'] = Register.new(0, 1)
    ('1'..'9').each do |n|
      [')', ']'].each do |i|
        @register[i+n] = Register.new
      end
    end
  end
end
