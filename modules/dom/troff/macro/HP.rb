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
      @register[')I'].value = to_u(indent, :default_unit => 'n')
    end

    hang = 0 - @register[')I'].value
    indent = @register[')R'].value + @register[')I'].value

    req_in("#{indent}u")
    req_ti("#{hang}u")

  end
end
