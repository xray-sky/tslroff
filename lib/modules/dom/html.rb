# html.rb
# ---------------
#    html methods
# ---------------
#
# frozen_string_literal: true
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
require_relative '../../classes/textformatter'

class HTML < TextFormatter

  extend Forwardable
  def_delegators :@structured_source, :title, :xpath

  def initialize(source, **kwargs)
    @manual_entry ||= source.file.sub(/\.html?$/, '')
    super(source, **kwargs)
    @structured_source = Nokogiri::HTML @source.iter.collect(&:to_s).join
  end

  # REVIEW some kind of default html processing baseline
  def to_html(halt_on: nil)
    return if halt_on
    body = xpath('//body')

    body_styles = String.new
    bgcolor = body.attribute('bgcolor')
    background = body.attribute('background')
    body_styles << %(background-color:#{bgcolor.value};) if bgcolor
    body_styles << %(background-image:url('#{background.value}');background-repeat:repeat;) if background

    body.css('a').each do |link|
      # ditch external links (e.g. to www.be.com) -- should cover http://, https://, ftp://, etc.
      link.replace(link.text) if link['href']&.include?('://') or link['href']&.start_with?('mailto:')
      # update links to '.htm' pages as '.html'
      link['href'] &&= link['href']&.sub!(%r{\.htm(#.*)?$}, '.html\1')
    end

    # also for image map links, e.g. Tru64 C++ 6.2
    body.css('area').each do |link|
      link.delete('href') if link['href']&.include?('://') or link['href']&.start_with?('mailto:')
    end

    <<~DOC
      <div class="title"><h1>#{page_title}</h1></div>
      <div class="htbody"#{%( style="#{body_styles}") unless body_styles.empty?}>
          <div id="man">
      #{body.children.to_xhtml(encoding: 'UTF-8').gsub(/&#13;/, '')}
          </div>
      </div>
    DOC
  end

  def page_title
    xpath('//head/title').text
  end

  #def input_line_number
  #  '*'
  #end

  # default behavior: flatten, single level
  def output_directory
    ''
  end

  def index_name
    @manual_entry
  end

  def index_description
    xpath('//head/title').text
  end
end
