# RE.rb
# -------------
#   troff
# -------------
#
#   .RE k
#
#     Return to the kth relative indent level (initially, k=1; k=0 is equivalent to k=1);
#     if k is omitted, return to the most recent lower indent level.
#
#   this works like a stack (see .RS)
#

module Troff
  def req_RE(k = nil)
    case k
    when nil then true
    when '0' then @register[')p'] = Register.new(1, 1)
    else          @register[')p'] = Register.new(k, 1)
    end

    @register[')I'].value = @register["]#{@register[')p'].value}"].value
    @register[')R'].value = @register[")#{@register[')p'].value}"].value
    @register[')p'].- if @register[')p'].value > 0

    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'].value)
  end
end
