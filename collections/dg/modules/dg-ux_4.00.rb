# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/21/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.00 (Eclipse MV) Version Overrides
#
# TODO
# ~ indexser misbhavior: multiline names on e.g. drand48(3)
#

module DG_UX
  module V4_00

    class Nroff < Nroff
      def initialize(source, **kwargs)
        @heading_detection ||= %r(^\s(?<section>[A-Z][A-Z\s]+)$)
        super
      end

      def parse_title
        title = super
        # missing title lines
        case @source.file
        when 'environ.5' then @manual_section = '5'
        when 'getprotobyname.3n', 'getprotobynumber.3n', 'getprotoent.3n', 'setprotoent.3n', 'endprotoent.3n',
             'getservbyname.3n', 'getservbyport.3n', 'getservent.3n', 'setservent.3n', 'endservent.3n'
          @manual_section = '3n'
        end
        title
      end

      def name_lines
        iter = @document[0].text.each
        iter.next until iter.peek.to_html.match? /_{8}/
        iter.next # skip rule line
        names = iter.next # might only be a subset of names, some span two lines
        descr = iter.next until iter.peek.to_html.match? /_{8}/
        [ names, descr ]
      end

      def index_entry(lines)
        (name, descr) = lines.map(&:to_html)
        return if name.empty? or descr.empty?
        [ strip_tags(name.strip.split(/\s{3,}/).first), descr.strip ]
      end
    end

    def self.name_for_section(sec)
      DG_UX.name_for_section(sec)
    end

  end
end
