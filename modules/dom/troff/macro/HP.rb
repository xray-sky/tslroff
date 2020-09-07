# HP.rb
# -------------
#   troff
# -------------
#
#   .HP in			Begin paragraph with hanging indent.
#
#
#  e.g. paragraph has indent in, first line doesn't
#

module Troff
  def req_HP(indent = nil)
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
    @current_block = blockproto
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'].value + @register[')I'].value)
    temp_indent(-@register[')I'].value)
  end
end
