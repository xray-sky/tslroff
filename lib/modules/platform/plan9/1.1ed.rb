# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/3/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Plan9 1.1e Platform Overrides
#
# 1.1e has HTML format input.
#
# TODO fix watermark alpha channel, if possible, to deal with non-white background
#

module Plan9_1_1ed

  def self.extended(k)
    k.instance_variable_set('@output_directory', '') #+ k.instance_variable_get('@source_dir')) # wrong
    k.instance_variable_set('@manual_entry', k.instance_variable_get('@input_filename').sub(/\.htm$/, ''))
    k.instance_variable_get('@source_lines').each do |l|
      # some of the pages have extended characters encoded Windows-1252
      l.force_encoding Encoding::Windows_1252
      # nokogiri is inserting extra whitespace at the beginning of <pre>,
      # if followed (pointelessly?) by <tt>
      l.gsub!(%r{<pre><tt>}, '<pre>')
      # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
      l.gsub!(%r{(</?)kbd>}, '\1tt>')
      # they've used gifs for some greek letters
      l.gsub!(%r{<img src="chars/capgamma.gif">}, '&Gamma;')
      l.gsub!(%r{<img src="chars/(.+?).gif">}, '&\1;')
    end
    case k.instance_variable_get '@input_filename'
    when 'index.htm'
      #k.instance_variable_set '@manual_entry', '_index'
      k.define_singleton_method :page_title, proc { 'Inferno Reference &mdash; Plan9 1.1ed' }
      k.instance_variable_get('@source_lines')[0].sub!(%r{<title></title>}, '<title>Inferno Reference HTML &mdash; Release 1.0</title>')
    when 'mpgs8.htm'
      k.instance_variable_get('@source_lines')[50].sub!(%r{^<em>}, '</a>')
      k.instance_variable_get('@source_lines')[55].sub!(%r{^<em>}, '</a>')
    when 'mpgs32.htm'
      k.define_singleton_method :page_title, proc { 'Environmental Utilities &mdash; Plan9 1.1ed' }
    when 'mpgs46.htm'
      k.define_singleton_method :page_title, proc { 'Limbo Keyring Modules &mdash; Plan9 1.1ed' }
    when 'mpgs56.htm'
      k.instance_variable_get('@source_lines')[50].sub!(%r{^<em>}, '</a>')
    when 'mpgs62.htm'
      k.define_singleton_method :page_title, proc { 'Limbo Math Modules &mdash; Plan9 1.1ed' }
    when 'mpgs66.htm'
      k.define_singleton_method :page_title, proc { 'Limbo Prefab Modules &mdash; Plan9 1.1ed' }
      k.instance_variable_get('@source_lines')[61].sub!(%r{^<em>}, '</a>')
    when 'mpgs71.htm'
      k.define_singleton_method :page_title, proc { 'Limbo System Modules &mdash; Plan9 1.1ed' }
    when 'mpgs77.htm'
      k.instance_variable_get('@source_lines')[31].sub!(%r{^<em>}, '</a>')
    when 'mpgs78.htm'
      k.instance_variable_get('@source_lines')[145].sub!(%r{<em><a}, '<a')
    when 'mpgs79.htm'
      k.instance_variable_get('@source_lines')[26].sub!(%r{^<em>}, '</a>')
    when 'mpgs81.htm'
      k.instance_variable_get('@source_lines')[66].sub!(%r{^<em>}, '</a>')
    when 'mpgs82.htm'
      k.instance_variable_get('@source_lines')[112].sub!(%r{^<em>}, '</a>')
    when 'mpgs86.htm'
      k.instance_variable_get('@source_lines')[24].sub!(%r{^<em>}, '</a>')
    when 'mpgs90.htm'
      k.define_singleton_method :page_title, proc { 'Toolkit Graphic Interface Modules &mdash; Plan9 1.1ed' }
    when 'mpgs93.htm'
      k.define_singleton_method :page_title, proc { 'Miscellaneous Limbo Modules &mdash; Plan9 1.1ed' }
    when 'mpgs105.htm'
      k.define_singleton_method :page_title, proc { 'Inferno Devices &mdash; Plan9 1.1ed' }
    when 'mpgs113.htm'
      k.define_singleton_method :page_title, proc { 'Inferno File Protocol &mdash; Plan9 1.1ed' }
    when 'mpgs125.htm'
      k.define_singleton_method :page_title, proc { 'Limbo Format Specifications &mdash; Plan9 1.1ed' }
    when 'mpgs131.htm'
      k.define_singleton_method :page_title, proc { 'Limbo Daemons &mdash; Plan9 1.1ed' }
    end
    # pick up changes to the source we rewrote
    k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join))
  end

  def to_html
    title = @source.title
    body = @source.xpath('//body')

    body_styles = ''
    bgcolor = body.attribute('bgcolor')
    background = body.attribute('background')
    body_styles << %(background-color:#{bgcolor.value};) if bgcolor
    body_styles << %(background-image:url('#{background.value}');background-repeat:repeat;) if background

    # ditch external links (e.g. to www.be.com)
    # rewrite relative links to *.htm as *.html (many anchors include # hrefs)
    body.css('a').each do |link|
      link.replace(link.text) if link['href']&.include?('://') or link['href']&.start_with?('mailto:') # should cover http://, https://, ftp://, etc.
      link['href'] &&= link['href']&.sub!(%r{\.htm(#.*)?$}, '.html\1')
    end

    # warn about page assets
    #asset_locations = body.css('img').collect do |img|
    #  File.dirname(img['src'])
    #end.compact
    #warn "asset locations: #{asset_locations.sort.uniq.inspect}" if asset_locations.any?

    <<~DOC
      <div class="title"><h1>#{title}</h1></div>
      <div class="htbody"#{(' style="' + body_styles + '"') unless body_styles.empty?}>
          <div id="man">
      #{body.children.to_xhtml(encoding: 'UTF-8')}
          </div>
      </div>
    DOC
  end

  def page_title
    @source.xpath('//h1').first.text + ' &mdash; Plan9 1.1ed'
  end
end
