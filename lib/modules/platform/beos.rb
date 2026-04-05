# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/13/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# BeOS Platform Overrides
#
# HTML format input. This should be interesting.
#
# TODO User's Guide has footer (with copyright we should maintain) outside </body>
#       Shell Tools/man1/gcc.html, rcsfile.html start with "Content-type: text/html"
#                        rcs.html, rcsintro.html, uuencode.html start with garbage
#       Shell Tools/man1 output is a mess (CSS clash)
#       Shell Tools/man1 gives us related links; these need rewriting (apparently) plus allowing into Related Info menu
#       also might want related info menu in the Be Book. but not on the index pages? blah.
#       figure out @output_directory which makes the css link correctly for everything
#          - stuff in the root, outside the book directories, gets one too many ../
#          - or if we fix the root pages, the stuff in the book directories gets one too few
#       copyrights outputs too wide?? wtf
#       do an Anchors menu too? (probably should)
# √     can we use roman (don't italic) <a> without href= ? metroworks body text is all <a name=>
#       malicious compliance from nokogiri on metrowerks pages, which can't as easily be
#         rewritten prior to parsing, as we did in plan9
#       <title> correctly, not unix manual style "index()". <h1> is fine.
# REVIEW also interesting use of <p class="body"> which could be considered to interfere with our CSS
#         ...but where is it defined in their manual? no css I can see.
#

class BeOS
  class Manual < Manual
    def output_directory
      @source.dir.partition(%r{^.*/(?:beos/documentation|develop)/?}).last
    end
  end

  class Nroff < Nroff ; end

  class HTML < HTML
    def initialize source
      @manual_entry = source.file.sub(/\.html$/, '')
      super source
    end

    def to_html(halt_on: nil)
      return nil if halt_on
      body = xpath('//body')

      body_styles = ''
      bgcolor = body.attribute('bgcolor')
      background = body.attribute('background')
      body_styles << %(background-color:#{bgcolor.value};) if bgcolor
      body_styles << %(background-image:url('#{background.value}');background-repeat:repeat;) if background

      # ditch external links (e.g. to www.be.com)
      body.css('a').each do |link|
        link.replace(link.text) if link['href']&.include?('://') or link['href']&.start_with?('mailto:') # should cover http://, https://, ftp://, etc.
        # also fix links in Shell Tools/man1 that link to "page.1" for some silly reason
        link['href'] &&= link['href'].sub(/\.1L?$/, '.html')
      end

      <<~DOC
        <div class="title"><h1>#{title}</h1></div>
        <div class="htbody"#{%( style="#{body_styles}") unless body_styles.empty?}>
            <div id="man">
        #{body.children.to_xhtml(encoding: 'UTF-8').gsub(/&#13;/, '')}
            </div>
        </div>
      DOC
    end

    def to_html_metrowerks(halt_on: nil)
      return nil if halt_on
      title = "CodeWarrior &mdash; #{@platform} #{@version}"

      <<~DOC
        <div class="title"><h1>#{title}</h1></div>
        <div class="htbody" style="background-color:white;background-image:url('images/arnoldbg.gif');background-repeat:repeat;">
            <div id="man">
        #{@source.lines[@content_start..@content_end].join}
            </div>
        </div>
      DOC
    end

  end
end
