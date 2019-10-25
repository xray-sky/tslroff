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

module Troff
  def req_IP(tag = '', indent = nil)	# )I reg holds carryover indent
    if indent
      # divert the width; don't let it get into the output stream.
      @current_block = Block.new(type: :bare)
      unescape(indent)
      @register[')I'].value = to_u(@current_block.text.pop.text.strip, :default_unit => 'n')
    end

    tag_block = Block.new(type: :bare)
    tag_block.text = tag
    unless tag_block.empty?
      @webdriver.get(tag_block.to_selenium)
      tag_width = to_u(@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
      tag_block.style.css[:width] = '100%' if tag_width + 36 > @register[')I'].value # add the width of a space
    end

    text_block = blockproto(:bare)
    @current_block = blockproto(:dl)
    @document << @current_block

    @current_block.style[:dt] = tag_block
    @current_block.style[:dd] = text_block
    @current_block.style[:dd].style.css[:margin_left] = "#{to_em(@register[')I'].value.to_s + 'u')}em"

  end

  def init_IP
    @register[')I'] = Register.new(to_u('0.5i'))
  end
end
