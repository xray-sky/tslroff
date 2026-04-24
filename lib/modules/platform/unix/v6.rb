# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX V6 Platform Overrides
#
#   from GL2-W2.5 lib/macros/an6
#   can't seem to find the 'an' macros from the v6 kit (look again)
#   this ought to be interesting
#
# TODO
#   redo as first-class macro package
# √ link detection - section in roman numerals
#   is everything here ok? what's up with cc(i) ?
#

module UNIX
  module V6
    class Source < Source
      def initialize(file, **kwargs, &block)
        super(file, **kwargs, &block)
        case @file
        when 'greek.5' then patch_line 17, /\s([.1])/, ' +\1', global: true
        end
      end
    end

    # this is working to avoid killing ::Block::Paragraph (`class Block::Paragraph < ::Block` did this)
    # but neither was the UNIX::V6 Troff making use of it.
    # overriding blockproto() was sufficient to fix, but fragile.

    class Block
      class Paragraph < ::Block::Paragraph
        def to_html
          # this used to happen before every block was processed.
          # TODO something better.
          #      something not tied to Block::Paragraph.
          #      something that can be overridden.
          #        => V6 manual refs are like "syscall (II)"
          # NOTE Nroff Line class has its own link rewrite

          t = @text.collect(&:to_html).join
          t.gsub!(%r{(?<break>(?:<br />)*)(?<text>(?:<[^<]+?>)*(?<entry>\S+?)\s{0,1}(?:<[^<]+?>)*\s{0,1}\((?:<[^<]+?>)*(?<fullsec>(?<section>[IV]*?))(?:<[^<]+?>)*\)(?:<[^<]+?>)*)}) do |_m|
            caps = Regexp.last_match
            entry = caps[:entry].sub(/&minus;/, '-')  # this was interfering with link generation - ali(1) [AOS 4.3]
            %(#{caps[:break]}<a href="../man#{caps[:fullsec]}/#{entry}.html">#{caps[:text]}</a>)
          end if style[:linkify]

          "<p#{@style}>\n#{t}\n</p>\n"
        end
      end
    end

    class Troff < ::Troff::Man6
      def initialize(source)
        @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
        @manual_section ||= Regexp.last_match[1] if Regexp.last_match
        super(source)
      end

      # override to get our own Block::Paragraph class as default
      def blockproto(type = Block::Paragraph)
        super(type)
      end

      def output_directory
        @manual_section and return "man#{@manual_section}"
        super
      end
    end
  end
end
