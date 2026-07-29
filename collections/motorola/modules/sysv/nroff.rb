# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Motorola SysV Platform Overrides
#

module Motorola_SysV
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/(?:\.\dX?\S?)?(?:\.[zZ])?$/, '')

      # TODO subclass properly
      case kwargs[:ver]
      when '1.02', 'R32V2' # Commercial Net Ext., MultiPersonal System
        case @manual_entry
        when 'bootpd'
          @heading_detection = %r{^(?<section>[A-Z][A-Za-z\s]+)$}
          @title_detection = %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
        when 'sledit'
          @heading_detection = %r{^\s{3}(?<section>[A-Z][A-Za-z\s]+)$}
          @title_detection = %r{^\s{3}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
        else
          @heading_detection = %r{^\s{5}(?<section>[A-Z][A-Za-z\s]+)$}
          @title_detection = %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
        end
      when 'Release 3.2 Version 1.2C'
        @heading_detection = %r{^\s{2}(?<section>[A-Z][A-Za-z\s]+)$}
        @title_detection = %r{^\s{2}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
      end

      super(source, **kwargs)
    end

  end
end
