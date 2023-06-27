# html.rb
# ---------------
#    html methods
# ---------------
#
# TODO
#   background watermark alpha blend (instead of white background & matte) should allow it to overlay an asset background image
#    - can an svg background maybe do this?
# √ dead absolute links (e.g. to http://www.be.com/)
# √ copy static resources (images) to output directory (tricky without access to $outd) - done in build tool
# √ suppress related links menu
#   _optionally_ suppress related links menu
#   DOM compliance?
#   local CSS compliance? (e.g. use of <b> or <table>, probably don't want my own rules under headings, etc.)
#     - margin on bare <img> ?
#   title overrides (to prepend os/ver/whatever else)
#   frameset (ARGH)
#   everything
#
# might need this: https://makandracards.com/makandra/481802-how-to-prevent-nokogiri-from-fixing-invalid-html
#                  (use Nokogiri::XML instead of ::HTML - how many messarounds can we get rid of if we do?)
#                                                         presumably we lose .css() though
# write out with : Nokogiri::XML.fragment("<h1><p>foo</p><span>bar</span></h1>").to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_HTML)
#                  (avoids some extraneous \n with .to_s on output)
#

module HTML
  def source_init
    # might need to re-encode based on input charset; save this so that is possible
    @source_lines = @source.lines
    @source = Nokogiri::HTML @source_lines.join

    #load_platform_overrides
    #load_version_overrides
  end

  def input_line_number
    '*'
  end
end
