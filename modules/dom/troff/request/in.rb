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
# REVIEW: seems troff starts with .i = 0; but our css starts with '2m'. so all
#         calculations are base that?
#
# TODO: The effect of .ll, .in, or .ti is delayed, if a partially collected line exists,
#       until after that line is output. (how? - does it matter?)
#

module Troff
  def req_in(indent = nil)
    previous = @state[:previous_indent]
    @state[:previous_indent] = @register['.i'].value

    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block

    indent(if indent
             indent.sub!(/^([-+])/, "#{@state[:previous_indent]}u\\1")
             to_u("#{indent}", default_unit: 'm')
           else
             previous
           end)
  end

  def indent(margin)
    @register['.i'].value = margin
    apply { @current_block.style.css[:margin_left] = "#{to_em(margin.to_s)}em" }
    @current_block.style.css.delete(:margin_left) if margin == @state[:base_indent]
  end

  def xinit_in
    @state[:base_indent] = to_u('2m').to_i		# from the CSS; TODO: link this with css
    @register['.i'] = Register.new(@state[:base_indent], :ro => true)
    @state[:previous_indent] = @register['.i'].value
  end
end
