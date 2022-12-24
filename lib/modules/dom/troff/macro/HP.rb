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
  define_method 'HP' do |indent = nil, *_args|
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
    @current_block = blockproto
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'] + @register[')I'])
    temp_indent -@register[')I']
  end
end
