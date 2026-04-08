# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/14/22.
# Copyright 2022 Typewritten Software. All rights reserved.
# encoding: UTF-8
#
# Inferno 1e Platform Overrides
#
# 1e has HTML format input. This should be interesting.
#
# this html is dogshit. was it created by microsoft word? nokogiri enforces malicious compliance.
# easier to rewrite the input than to try to ask nokogiri to move things around
#
# 1e has HTML format input. Fully flat, no directory structure.
#
# TODO
# √ lost the img files?
#

module Inferno
  module FirstEd
    class Source < Source
      def initialize(file, **kwargs, &block)
        # some of the pages have extended characters encoded Windows-1252
        kwargs[:encoding] ||= Encoding::Windows_1252

        super(file, **kwargs, &block)

        # nokogiri is inserting extra whitespace at the beginning of <pre>,
        # if followed (pointelessly?) by <tt>
        patch %r{<pre><tt>}, '<pre>', global: true
        # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
        patch %r{(</?)kbd>}, '\1tt>', global: true
        # they've used gifs for some greek letters
        patch %r{<img src="chars/capgamma.gif">}, '&Gamma;', global: true
        patch %r{<img src="chars/(.+?).gif">}, '&\1;', global: true

        case file
        when 'index.htm'    then patch_line(1, %r{<title></title>}, '<title>Inferno Reference HTML &mdash; Release 1.0</title>')
        when 'devices.htm'  then patch_line(202, %r{^<em>}, '</a>')
        when 'md_misc4.htm' then patch_line( 54, %r{^<em>}, '</a>')
        when 'md_pref.htm'  then patch_line( 56, %r{^<em>}, '</a>')
        when 'md_pref4.htm' then patch_line( 77, %r{^<em>}, '</a>')
        when 'md_sys6.htm'  then patch_line( 28, %r{^<em>}, '</a>')
        when 'md_sys7.htm'  then patch_line(163, %r{^<em>}, '</a>')
        when 'md_sys8.htm'  then patch_line( 23, %r{^<em>}, '</a>')
        when 'md_sys10.htm' then patch_line( 85, %r{^<em>}, '</a>')
        when 'md_sys11.htm' then patch_line(219, %r{^<em>}, '</a>')
        when 'md_sys15.htm' then patch_line( 21, %r{^<em>}, '</a>')
        when 'proto.htm'    then patch_line(391, %r{^<em>}, '</a>')
        when 'proto5.htm'   then patch_line( 30, %r{^<em>}, '</a>')
        when 'proto6.htm'   then patch_lines([115, 118, 121], %r{^<em>}, '</a>')
        when 'proto7.htm'   then patch_line( 45, %r{^<em>}, '</a>')
        when 'cmd6.htm', 'md_math1.htm', 'md_sec4.htm', 'md_sec8.htm', 'md_sec9.htm',
             'md_sec12.htm', 'md_sec13.htm', 'md_sec14.htm', 'md_sec19.htm', 'md_sys1.htm', 'md_sys4.htm'
          patch_line(8, %r{</a>}, '', global: true)
          patch_line(8, /$/, '</a>')
          patch_line(10, %r{^<pre>}, '') # _sec14 only
        end
      end
    end

    class HTML < Inferno::HTML

      def initialize(source)
        @manual_entry ||= source.file.sub(/\.htm$/, '')

        super(source)

        case @source.file
        when 'index.htm'
          define_singleton_method :page_title, proc { 'Inferno Reference &mdash; Inferno 1ed' }
        end
      end

      def to_html(halt_on: nil)
        return nil if halt_on
        title = title.sub(%r{^(Inferno|Limbo)([^/\s])}, '\1 \2')
        body = xpath('//body')

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
        "#{xpath('//h1').first.text} &mdash; Inferno 1ed"
      end
    end
  end
end
