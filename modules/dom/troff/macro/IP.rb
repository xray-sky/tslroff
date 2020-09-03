# IP.rb
# -------------
#   troff
# -------------
#
#   .IP t in
#
#     Same as .TP with tag t; often used to get an indented paragraph without a tag.
#
# tmac.an turns ligatures off for the tag. interesting. -- did this via css.
# \n()I is also manipulated by/used for the indents on .RS and .HP
#
# REVIEW .IP/.PP/.IP with no further args is giving inconsistent indents, ar(1) Examples [GL2-W2.5]
#        -- that first .IP is holding over from .TP in previous section; should .SH reset like .PP does? porbly
#

module Troff
  def req_IP(tag = '', indent = nil)	# )I reg holds carryover indent
    if indent
      # divert the width; don't let it get into the output stream.
      @current_block = Block.new(type: :bare)
      unescape(indent)
      @register[')I'].value = to_u(@current_block.text.pop.text.strip, :default_unit => 'n')
      # which unit is assumed? tmac.an suggests n, but usage suggests m ?? which usage? in AOS-4.3? REVIEW
      # lpadmin(1m) [GL2-W2.5] makes it look like 'n'.
      #@register[')I'].value = to_u(@current_block.text.pop.text.strip, :default_unit => 'm')
    end

    tag_block = Block.new(type: :bare)
    if tag.class == String 	# we didn't get a Text object passed from e.g. .TP
      @current_block = tag_block
      @current_tabstop = @current_block.text.last
      @current_tabstop[:tab_stop] = 0	# REVIEW or is it indent ??
      unescape(tag)
    else
      tag_block.text = tag
    end

    unless tag_block.empty?
      @@webdriver.get(tag_block.to_selenium)
      tag_width = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
      tag_block.style.css[:display] = 'inline-block'
      tag_block.style.css[:width] = (tag_width + 36 > @register[')I'].value) ? '100%' : (to_em("#{@register[')I'].value}u").to_s + 'em') # add the width of a space
    end

    text_block = blockproto(:bare)
    @current_block = blockproto(:dl)
    @document << @current_block

    @current_block.style[:dt] = tag_block
    @current_block.style[:dd] = text_block
    @current_block.style[:dd].style.css[:margin_left] = "#{to_em(@register[')I'].value.to_s + 'u')}em"
    @current_block.style[:dd].style.css[:margin_top] = '0' # REVIEW what about if the interparagraph spacing changes??
  end

  def init_IP
    @register[')I'] = Register.new(to_u('0.5i'))
  end
end
