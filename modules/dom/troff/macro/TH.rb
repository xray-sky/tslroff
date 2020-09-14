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
# none of this is relevant to tslroff (REVIEW: unless some man page tries to use them - e.g. IN in ms.5)
# TODO: this is totally incomplete
# TOOD: TH just sets registers; they necessarily don't get printed until later (e.g. at page footer)
#       subsequent macros may overwrite these registers, and it is those later values which
#       will get used! see e.g. -- a.out(5) [AOS 4.3]
#

module Troff
  def req_TH(*args, heading: nil)
    @state[:manual_section] = args[1]
    req_DT
    apply do
      @current_block.type = :th
    end
    unescape(heading || "#{args[0]}\\^(\\^#{args[1]}\\^)") # TODO delay this until first output, somehow, because of macros that expect to rewrite this
    @current_block = blockproto
    @document << @current_block
  end
end
