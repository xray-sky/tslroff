# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R4.5 Platform Overrides
#
# HTML format input.
#
# TODO User's Guide has footer (with copyright we should maintain) outside </body>
# √     Shell Tools/man1 gives us related links; these need rewriting (apparently)
#          - plus allowing into Related Info menu
#       also might want related info menu in the Be Book. but not on the index pages? blah.
#       copyrights outputs too wide?? wtf
#       do an Anchors menu too? (probably should)
# REVIEW also interesting use of <p class="body"> which could be considered to interfere with our CSS
#         ...but where is it defined in their manual? no css I can see.
#

module BeOS
  module R4_5
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.dirname(file)
        when /French/ then kwargs[:encoding] = Encoding::ISO_8859_1
        # TODO this is way wrong. I can't find a working encoding, not here,
        # not on classic Mac, and not on BeOS itself, and I wonder if it was
        # mojibaked before it went on the disc. This prevents invalid byte
        # sequence exceptions, at least, although it does leave us pages full
        # of garbage.
        when /Japan/
          #@language = 'ja'
          #srcargs[:encoding] = Encoding::ISO_8859_1
          raise ManualIsBlacklisted, 'mojibake'
        end

        case File.basename file
        when 'doc'      then kwargs[:magic] = :Nroff
        when 'rcs.html' then kwargs[:magic] = :HTML
        when '_SEE_4.1__THINK_4.5' then raise ManualIsBlacklisted, 'not useful'
        end

        super(file, **kwargs, &block)

        case @file
        when 'rcs.html' then patch_line(1, /^\s+{/, '')
        when /fm.html/, 'Metrowerks_License.html' # metrowerks
          # the metrowerks source is too heinous for nokogiri, too much malicious compliance to cope with
          # maybe the features are regular enough we can just... fudge it.
          # * none of the pages have titles
          # * all have navigation content before <body>
          #
          patch(%r{^\s*<body bgcolor=#ffffff BACKGROUND="images/arnoldbg.gif">\s*$}, '')
          # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
          patch(%r{(</?)kbd>}, '\1tt>', global: true)
          # looks like these are the only two external links appearing in the metrowerks manual
          patch(%r{<a href="http://www.metrowerks.com">(http://www.metrowerks.com)</a>}, '\1', global: true)
          patch(%r{<a href="mailto:support@metrowerks.com">(support@metrowerks.com)</a>}, '\1', global: true)
        else
          patch(/&(nbsp|mdash|lt|gt|copy)(?!;)/, '&\1;', global: true)
        end
      end
    end

    class Manual < Manual
      def initialize(file, vendor_class: nil, source_args: nil)
        case File.dirname(file)
        when /German/ then @language = 'de'
        when /French/ then @language = 'fr'
        when /Japan/  then @language = 'ja'
        end
        super(file, vendor_class: vendor_class, source_args: source_args)
      end
    end

    class Nroff < Nroff ; end
    class HTML < HTML
      def initialize(source)
        super source

        # unlink the blacklisted Japanese pages
        xpath('//body').css('a').each { |l| l.replace(l.text) if l['href']&.include?('Japan') }

        case @source.file
        when 'doc'
          # this is a plain text file. correctly magicked, but no title, etc.
          define_singleton_method :parse_title, proc { 'Synchronization: Semaphores vs. Spinlocks' }
        when /fm.html/, 'Metrowerks_License.html' # metrowerks
          @content_start = @source.index { |l| l.match? %r{<a name="Top">} }
          @content_end   = @source.index { |l| l.match? %r{<a name="Bottom">} }
          define_singleton_method :to_html, method(:to_html_metrowerks)
        end
      end
    end
  end
end
