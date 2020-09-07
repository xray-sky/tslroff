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

module Troff

  def req_RS(indent = nil)
    # troff won't tolerate more than 9 levels of indent even though theoretically we could
    raise RuntimeError "out of stack space for indents in .RS at line #{input_line_number}" if @register[')p'].value == 9

    # push old values onto stack
    @register[')p'].+
    @register["]#{@register[')p'].value}"].value = @register[')I'].value
    @register[")#{@register[')p'].value}"].value = @register[')R'].value

    # increase relative indent by arg, or by )I if arg not given
    @register[')R'].value += if indent
      to_u(indent, :default_unit => 'n').to_i
    else
      @register[')I'].value
    end

    init_IP
    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'].value)

  end

  def init_RS
    @register[')R'] = Register.new(0)
    @register[')p'] = Register.new(0, 1)
    ('1'..'9').each do |n|
      [')', ']'].each do |i|
        @register[i+n] = Register.new
      end
    end
  end
end
