# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/14/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno 1e Platform Overrides
#
# 1e has HTML format input. This should be interesting.
#
# this html is dogshit. was it created by microsoft word? nokogiri enforces malicious compliance.
# easier to rewrite the input than to try to ask nokogiri to move things around
#
# TODO
#   lost the img files?
#

module Inferno_1ed

  def self.extended(k)
    k.instance_variable_set('@output_directory', '') #+ k.instance_variable_get('@source_dir')) # wrong
    k.instance_variable_set('@manual_entry', k.instance_variable_get('@input_filename').sub(/\.htm$/, ''))
    k.instance_variable_get('@source').lines.each do |l|
      # some of the pages have extended characters encoded Windows-1252
      l.force_encoding Encoding::Windows_1252
      # nokogiri is inserting extra whitespace at the beginning of <pre>,
      # if followed (pointelessly?) by <tt>
      l.gsub!(%r{<pre><tt>}, '<pre>')
      # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
      l.gsub!(%r{(</?)kbd>}, '\1tt>')
      # they've used gifs for some greek letters
      l.gsub!(%r{<img src="chars/(.+?).gif">}, '&\1;')
    end
    case k.instance_variable_get '@input_filename'
    when 'index.htm'
      k.define_singleton_method(:page_title, proc { 'Inferno Reference &mdash; Inferno 1ed' })
      k.patch_line(0, %r{<title></title>}, '<title>Inferno Reference HTML &mdash; Release 1.0</title>')
    when 'cmd6.htm', 'md_math1.htm',
         'md_sec4.htm', 'md_sec8.htm', 'md_sec9.htm', 'md_sec12.htm', 'md_sec13.htm', 'md_sec14.htm',
         'md_sec19.htm', 'md_sys1.htm', 'md_sys4.htm'
      k.patch_line(7, %r{</a>}, '', global: true)
      k.patch_line(7, /$/, '</a>')
      k.patch_line(9, %r{^<pre>}, '') # _sec14 only
    when 'devices.htm'  then k.patch_line(201, %r{^<em>}, '</a>')
    when 'md_misc4.htm' then k.patch_line( 53, %r{^<em>}, '</a>')
    when 'md_pref.htm'  then k.patch_line( 55, %r{^<em>}, '</a>')
    when 'md_pref4.htm' then k.patch_line( 76, %r{^<em>}, '</a>')
    when 'md_sys6.htm'  then k.patch_line( 27, %r{^<em>}, '</a>')
    when 'md_sys7.htm'  then k.patch_line(162, %r{^<em>}, '</a>')
    when 'md_sys8.htm'  then k.patch_line( 22, %r{^<em>}, '</a>')
    when 'md_sys10.htm' then k.patch_line( 84, %r{^<em>}, '</a>')
    when 'md_sys11.htm' then k.patch_line(218, %r{^<em>}, '</a>')
    when 'md_sys15.htm' then k.patch_line( 20, %r{^<em>}, '</a>')
    when 'proto.htm'    then k.patch_line(390, %r{^<em>}, '</a>')
    when 'proto5.htm'   then k.patch_line( 29, %r{^<em>}, '</a>')
    when 'proto6.htm'   then k.patch_lines([114, 117, 120], %r{^<em>}, '</a>')
    when 'proto7.htm'   then k.patch_line( 43, %r{^<em>}, '</a>')
    end
  end

  def to_html
    title = @source.title.sub(%r{^(Inferno|Limbo)([^/\s])}, '\1 \2')
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
      <div class="htbody"#{%( style="#{body_styles}") unless body_styles.empty?}>
          <div id="man">
      #{body.children.to_xhtml(encoding: 'UTF-8')}
          </div>
      </div>
    DOC
  end

  def page_title
    "#{@source.xpath('//h1').first.text} &mdash; Inferno 1ed"
  end
end
