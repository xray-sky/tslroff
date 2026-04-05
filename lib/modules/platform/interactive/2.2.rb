# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Kodak Interactive UNIX v2.2 Platform Overrides
#
# TODO
#   disk(7) - overstruck 'SEE ALSO'
#

module Interactive
  module V2_2
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when /\.cpio$/ then raise ManualIsBlacklisted, 'is cpio install pkg'
        end
        super(file, **kwargs, &block)
      end
    end

    class Nroff < Nroff

      def initialize(source)
        @manual_entry ||= source.file.sub(/\.(\d\S?)(?:\.z)?$/, '')
        @heading_detection ||= %r(^\s{10}(?<section>[A-Z][A-Za-z\s]+)$)
        # some of these entries with longish names end up with clashes in the title line
        # so detect just on closing parenthesis, regardless of following whitespace
        @title_detection ||= %r{^\s{10}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:-(?<systype>\S+?))?\))}
        super(source)
      end

    end
  end
end
