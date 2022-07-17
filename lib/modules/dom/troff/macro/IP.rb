# IP.rb
# -------------
#   troff
# -------------
#
#   .IP t in
#
#     Same as .TP with tag t; often used to get an indented paragraph without a tag.
#
# tmac.an turns ligatures off for the tag. interesting. -- did this via css. (TODO no longer after having removed dl/dd/dt)
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

    @current_block = blockproto
    @document << @current_block

    tagpara(tag)
  end

  def init_IP
    @register[')I'] = Register.new(to_u('0.5i'))
    # this is effectively a constant. nothing changes it.
    @state[:tag_padding] = to_u('3p').to_i
  end
end
