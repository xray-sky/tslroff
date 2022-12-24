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
#
# TODO DomainOS softbench uses .TQ macro instead of .TH - this prevents us from outputting a correct set of divs
# TODO consider trying to get an actual .tl style title in html, which would help us prevent the hanging \(em
#      when some info is missing. I know we tried a bunch of nonsense ages ago, and didn't really solve it.
#

module Troff
  define_method 'TH' do |*args, heading: nil|
    #@manual_section ||= args[1]
    # I want the section inferred from the filename to be a default
    # in case we don't get or can't parse the one from .TH
    @manual_section = args[1] if args[1] and !args[1].strip.empty?   # REVIEW ...do I? - I'm doing it that way in nroff. but this also means I can't override in platform/version
    @output_directory = "man#{@manual_section.downcase}" if @manual_section
    send 'DT'
    @state[:named_string][:header] = heading || "#{args[0]}\\^(\\^#{args[1]}\\^)"
    @current_block = blockproto
    @document << @current_block
  end
end
