# in.rb
# -------------
#   troff
# -------------
#
#   §6
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .in ±N        N=0       previous  B,E,m   Indent is set to ±N. The indent is prepended
#                                           to each output line.
#
# sets register .i
#

module Troff
  def req_in(indent = nil)
    previous = @state[:previous_indent]
    @state[:previous_indent] = @register['.i'].value
    @register['.i'].value = if indent
                              indent.sub!(/^([-+])/, "#{@state[:previous_indent]}u\\1")
                              to_u(indent, default_unit: 'm')
                            else
                              previous
                            end
  warn "set indent to #{@register['.i'].value.inspect}"
  req_P
  @current_block.style.css[:margin_top] = '0'
  end

  def init_in
    @base_indent = 400 #to_u('2m').to_i		# from the CSS; TODO: link this with css
  end
end
