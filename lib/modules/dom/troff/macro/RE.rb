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
#   kermit(1c) [GL2-W2.5] seems to call it repeatedly without ever having called .RS.
#

module Troff
  def req_RE(k = nil)
    return if @register[')p'].zero?		# never .RS'd.
    case k
    when nil then true
    when '0' then @register[')p'] = Register.new(1, 1)
    else          @register[')p'] = Register.new(k, 1)
    end

    @register[')I'].value = @register["]#{@register[')p']}"].value
    @register[')R'].value = @register[")#{@register[')p']}"].value
    @register[')p'].decr if @register[')p'] > 0

    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = '0'
      @document << @current_block
    end
    indent(@state[:base_indent] + @register[')R'])
  end
end
