# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop 1.1.1g Platform Overrides
#

module OpenDesktop
  module V1_1_1g
    class Source < Source
      def initialize(file, **kwargs, &block)
        if ZEXTRA.include? File.basename(file)
          kwargs[:magic] = 'Nroff'
          super(file, **kwargs) { |f| IO.readlines("| gzip_10.6 -dc #{f} | zcat") }
        else
          super(file, **kwargs, &block)
        end
      end
    end

    class Nroff < Nroff
      def initialize(source)
        case source.file
        when 'bdftosnf.X.z', 'ico.X.z', 'mkfontdir.X.z', 'oclock.X.z', 'showsnf.X.z',
             'xdpyinfo.X.z', 'xev.X.z', 'xeyes.X.z', 'xmodmap.X.z', 'xset.X.z', 'xwininfo.X.z'
          @title_detection = %r{^\s{4}(?<manentry>(?<cmd>\S+?)\s\((?<section>[A-Z]+)\))\s+}
          @related_info_heading = 'SEE ALSO'
        end
        @heading_detection ||= %r(^\s{4,5}(?<section>[A-Z][A-Za-z\s]+)$)
        @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
        @related_info_heading ||= 'See Also'
        super(source)
      end
    end

    ZEXTRA = %w[ ksh.C.z messages.M.z terminfo.M.z X.X.z mwm.X.z scoterm.X.z xdm.X.z xterm.X.z ].freeze
  end
end
