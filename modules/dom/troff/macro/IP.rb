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
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent

    # give us a block if we need one. doing it here keeps the paragraph spacing
    # the test prevents us from losing paragraph spacing we already got:
    # e.g. .PP -> .PD 0 -> .TP foo -- adb(1) [GL2-W2.5]
    #
    # TODO: but then we lose it at the other end - ugh how
    #       .RE -> .PD -> .TP foo
    #       the problem is that .PP outputs vertical space. but in HTML context, this is
    #       an empty container! REVIEW are we grown up enough to not skip empty blocks?
    #                                  we aren't pushing any "unnecessary" ones into the doc?

    #if @current_block.immutable?
      @current_block = blockproto
      @document << @current_block
    #end

    indent = @state[:base_indent] + @register[')R'].value + @register[')I'].value
    req_in("#{indent}u")

    unless tag.empty?
      req_ti("0-#{@register[')I'].value}u")
      tag.class == String ? unescape(tag) : @current_block.text = tag

      # get the width
      @@webdriver.get(Block.new(type: :bare, text: @current_block.text).to_selenium)
      tag_width = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i

      # is the tag wider than 3 points less than the indent?
      if tag_width + @state[:tag_padding] > @register[')I'].value
        req_br
      else
        tab_width = to_em("#{@register[')I'].value}u")

        # The odd insertion is so we don't clobber tags which themselves include tabs.
        # - adb(1) [GL2-W2.5]
        #
        # The "control character" is so the Text object holding the inserted tab
        # isn't skipped for being "empty". it'll translate to nothing (an empty string)
        # during output processing. Otherwise, it's as if there had been a tab.

        tab = Text.new(text: "&roffctl_nil;")
        tab.instance_variable_set(:@tab_width, "#{tab_width}em")
        @current_block.text = @current_block.text.insert(0, tab)

        @current_block << '&roffctl_endspan;'
        apply { @current_block.text.last[:tab_stop] = 0 }
        @current_tabstop = @current_block.text.last
        @current_tabstop.instance_variable_set(:@no_space_adj, true)
      end
    end

  end

  def init_IP
    @register[')I'] = Register.new(to_u('0.5i'))
    # this is effectively a constant. nothing changes it.
    @state[:tag_padding] = to_u('3p').to_i
  end
end
