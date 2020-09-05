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
    @register['.i'].value = if indent
                              indent.sub!(/^([-+])/, "#{@state[:previous_indent]}u\\1")
                              to_u("#{@base_indent}u+#{indent}", default_unit: 'm')
                            else
                              previous
                            end
    # do we need to break? or is this already a brand new block.
    # this should keep .PP followed by .RS from collapsing margin_top - bfs(1) [GL2-W2.5]
    if @current_block.immutable?
      case @current_block.type
      when :p  then req_P
      when :dl then req_IP('')
      else warn "trying to do .in in unexpected context (#{@current_block.type.inspect})"
      end
      @current_block.style[:margin_top] = 0
    end
    apply { @current_block.style.css[:margin_left] = "#{to_em(@register['.i'].value.to_s + 'u')}em" } unless @register['.i'].value == @base_indent
  end

  def xinit_in
    @base_indent = 400 #to_u('2m').to_i		# from the CSS; TODO: link this with css
  end
end
