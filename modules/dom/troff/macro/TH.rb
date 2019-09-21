# TH.rb
# -------------
#   troff
# -------------
#
#   .TH t s c n
#
#     Set the title and entry heading; t is the title, s is the section number,
#     c is extra commentary, e.g., "local", n is new manual name. Invokes .DT
#
#   Marks a "three-part header"
#
# The following number registers are given default values by .TH:
#       IN  Left margin indent relative to subheads
#           (default is 7.2en in troff(1), 5 en in nroff(1)
#            -- tmac.an sets it to 0.5i and it never changes).
#       LL  Line length including IN.
#       PD  Current interparagraph distance.
#
# none of this is relevant to tslroff (REVIEW: unless some man page tries to use them)
# TODO: this is totally incomplete
#

module Troff
  def req_TH(*args)
    apply do
      @current_block.type = :th
      @current_block << args.join(' ')
    end
    @current_block = blockproto
    @document << @current_block
  end
end
