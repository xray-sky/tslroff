# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/3/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno 1.1e Platform Overrides
#
# 1.1e has HTML format input. Fully flat, no directory structure. Manual entry is mpgs.html
#
# TODO
# √ lost the img files?
#   fix watermark alpha channel, if possible, to deal with non-white background
#

module  Inferno
  module FirstEd_1
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
        when 'index.htm'  then patch_line(1, %r{<title></title>}, '<title>Inferno Reference HTML &mdash; Release 1.0</title>')
        when 'mpgs8.htm'  then patch_lines([51, 56], %r{^<em>}, '</a>')
        when 'mpgs56.htm' then patch_line(51, %r{^<em>}, '</a>')
        when 'mpgs66.htm' then patch_line(62, %r{^<em>}, '</a>')
        when 'mpgs77.htm' then patch_line( 32, %r{^<em>}, '</a>')
        when 'mpgs78.htm' then patch_line(146, %r{<em><a}, '<a')
        when 'mpgs79.htm' then patch_line( 27, %r{^<em>}, '</a>')
        when 'mpgs81.htm' then patch_line( 67, %r{^<em>}, '</a>')
        when 'mpgs82.htm' then patch_line(113, %r{^<em>}, '</a>')
        when 'mpgs86.htm' then patch_line( 25, %r{^<em>}, '</a>')
        end
      end
    end

    class HTML < Inferno::HTML

      def initialize(source)
        @manual_entry ||= source.file.sub(/\.htm$/, '')

        super(source)

        case @source.file
        when 'index.htm'   then define_singleton_method :page_title, proc { 'Inferno Reference &mdash; Inferno 1.1ed' }
        when 'mpgs32.htm'  then define_singleton_method :page_title, proc { 'Environmental Utilities &mdash; Inferno 1.1ed' }
        when 'mpgs46.htm'  then define_singleton_method :page_title, proc { 'Limbo Keyring Modules &mdash; Inferno 1.1ed' }
        when 'mpgs62.htm'  then define_singleton_method :page_title, proc { 'Limbo Math Modules &mdash; Inferno 1.1ed' }
        when 'mpgs66.htm'  then define_singleton_method :page_title, proc { 'Limbo Prefab Modules &mdash; Inferno 1.1ed' }
        when 'mpgs71.htm'  then define_singleton_method :page_title, proc { 'Limbo System Modules &mdash; Inferno 1.1ed' }
        when 'mpgs90.htm'  then define_singleton_method :page_title, proc { 'Toolkit Graphic Interface Modules &mdash; Inferno 1.1ed' }
        when 'mpgs93.htm'  then define_singleton_method :page_title, proc { 'Miscellaneous Limbo Modules &mdash; Inferno 1.1ed' }
        when 'mpgs105.htm' then define_singleton_method :page_title, proc { 'Inferno Devices &mdash; Inferno 1.1ed' }
        when 'mpgs113.htm' then define_singleton_method :page_title, proc { 'Inferno File Protocol &mdash; Inferno 1.1ed' }
        when 'mpgs125.htm' then define_singleton_method :page_title, proc { 'Limbo Format Specifications &mdash; Inferno 1.1ed' }
        when 'mpgs131.htm' then define_singleton_method :page_title, proc { 'Limbo Daemons &mdash; Inferno 1.1ed' }
        end
      end

      def to_html(halt_on: nil)
        return nil if halt_on
        title = title
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
        "#{xpath('//h1').first.text} &mdash; Inferno 1.1ed"
      end
    end
  end
end
