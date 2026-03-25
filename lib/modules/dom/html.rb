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

require 'forwardable'

class HTML < TextFormatter

  extend Forwardable
  def_delegators :@structured_source, :title, :xpath

  def initialize source
    super source
    @structured_source = Nokogiri::HTML @source.lines.join
  end

  def input_line_number
    '*'
  end

  # default behavior: flatten
  def output_directory
    ''
  end
end
