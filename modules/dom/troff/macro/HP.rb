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
    if indent
      # divert the width; don't let it get into the output stream.
      @current_block = Block.new(type: :bare)
      unescape(indent)
      @register[')I'].value = to_u(@current_block.text.pop.text.strip, :default_unit => 'n')
    end

    hang = @register['.i'].value - @register[')I'].value
    req_in("#{@register[')I'].value}u")
    req_sp("#{@register[')P'].value}u")
    req_ti("#{hang}u")

  end
end
