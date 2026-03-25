# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R5 Platform Overrides
#
# HTML format input.
#
# TODO
#   User's Guide has footer (with copyright we should maintain) outside </body>
# √ Shell Tools/man1/gcc.html, rcsfile.html start with "Content-type: text/html"
# √                  rcs.html, rcsintro.html, uuencode.html start with garbage
# √ Shell Tools/man1 output is a mess (CSS clash)
# √ Shell Tools/man1 gives us related links; these need rewriting (apparently)
#      - plus allowing into Related Info menu
#   also might want related info menu in the Be Book. but not on the index pages? blah.
#   figure out @output_directory which makes the css link correctly for everything
#      - stuff in the root, outside the book directories, gets one too many ../
#      - or if we fix the root pages, the stuff in the book directories gets one too few
#   copyrights outputs too wide?? wtf
#   do an Anchors menu too? (probably should)
# √ can we use roman (don't italic) <a> without href= ? metroworks body text is all <a name=>
# √ also interesting use of <p class="body"> in User's Guide which could be considered to
#      interfere with our CSS ...but where is it defined in their manual? no css I can see.
#
# REVIEW
#

class BeOS::R5

  class Manual < BeOS::Manual
    def initialize(file, vendor_class: nil, source_args: nil)
      srcargs = source_args.dup || {}
      case File.basename(file)
      when 'gcc.html', 'rcs.html', 'rcsfile.html', 'rcsintro.html', 'uuencode.html'
        srcargs[:magic] = :HTML
      end
      super(file, vendor_class: vendor_class, source_args: srcargs, preprocess: :preprocessing)
    end

  private

    def preprocessing
      case @source.file
      when 'rcs.html'      then @source.patch_line(1, /^\s+{/, '')
      when 'uuencode.html' then @source.lines.slice!(0, 40)
      when 'gcc.html', 'rcsfile.html', 'rcsintro.html'
        @source.patch_line(1, /^.*$/, '')
      when /fm.html/, 'Metrowerks_License.html' # metrowerks
        # the metrowerks source is too heinous for nokogiri, too much malicious compliance to cope with
        # maybe the features are regular enough we can just... fudge it.
        # * none of the pages have titles
        # * all have navigation content before <body>

        @source.patch(%r{^\s*<body bgcolor=#ffffff BACKGROUND="images/arnoldbg.gif">\s*$}, '')
        # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
        @source.patch(%r{(</?)kbd>}, '\1tt>', global: true)
        # looks like these are the only two external links appearing in the metrowerks manual
        @source.patch(%r{<a href="http://www.metrowerks.com">(http://www.metrowerks.com)</a>}, '\1', global: true)
        @source.patch(%r{<a href="mailto:support@metrowerks.com">(support@metrowerks.com)</a>}, '\1', global: true)
      end
    end
  end

  class Nroff < BeOS::Nroff ; end

  class HTML < BeOS::HTML

    def initialize source
      super source

      case @source.dir
      when /User's Guide/ then xpath('//p[@class="body"]').each { |pp| pp.remove_class('body') }
      end

      case @source.file
      when /fm.html/, 'Metrowerks_License.html' # metrowerks
        @content_start = @source.lines.index { |l| l.match? %r{<a name="Top">} }
        @content_end   = @source.lines.index { |l| l.match? %r{<a name="Bottom">} }
        define_singleton_method :to_html, method(:to_html_metrowerks)
      end
    end

  end
end
