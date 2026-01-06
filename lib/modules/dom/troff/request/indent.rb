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
# .in ±N        N=0       previous  B,‡,E,m Indent is set to ±N. The indent is prepended
#                                           to each output line.
#
#  sets register .i
#
#  REVIEW seems troff starts with .i = 0; but our css starts with '2m'. so all
#        calculations are base that?
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
#  TODO "The effect of .ll, .in, or .ti is delayed, if a partially collected line exists,
#        until after that line is output." (how? - does it matter?)
#
#
# .ti ±N        -         ignored   B,‡,E,m Temporary indent. The next output text line
#                                           will be indented a distance ±N with respect
#                                           to the current indent. The resulting total
#                                           indent may be zero (equal to the current
#                                           page offset) but may not be less than the
#                                           current page offset. The temporary indent
#                                           applies only for the one output line
#                                           following the request; the value of the
#                                           current indent (that value stored in the
#                                           .i register) is not changed.
#
#  so an absolute position is relative to the page, and in html context needs to be
#  relative to the current indent. but a relative position (starts with ±) needs nothing.
#
#  looks like it's meant to cause a break too. mount_cachefs(1m) [SunOS 5.5.1]
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
#

class Troff
  def ti(argstr = '', breaking: true)
    return nil if argstr.empty?
    indent = argstr.split.first
    warn ".ti invoked with nobreak - how to?" unless breaking
    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block
    temp_indent(to_u(indent.match(/^[-+]/) ? "#{indent}" : "#{indent}-#{@register['.i']}u", default_unit: 'm'))
  end

  def in(argstr = '', breaking: true)
    warn ".in invoked with nobreak - how to?" unless breaking
    indent = argstr.split.first

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

  def temp_indent(hang)
    apply { @current_block.style.css[:text_indent] = "#{to_em(hang.to_s)}em" }
  end

  def xinit_in
    @state[:base_indent] = to_u('2m').to_i		# from the CSS; TODO link this with css
    @register['.i'] = Register.new(@state[:base_indent], :ro => true)
    @state[:previous_indent] = @register['.i'].value
  end
end
