# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX 3.0.1 Version Overrides
#

class A_UX::V3_0_1
  class Nroff < A_UX::Nroff

    def initialize(source)
      case source.file
      when 'appres.1.Z'
        @heading_detection = %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
        @title_detection = %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      when 'XtCreateApplicationContext.3xt.Z', 'XtDestroyApplicationContext.3xt.Z',
           'XtToolkitInitialize.3xt.Z', 'XtWidgetToApplicationContext.3xt.Z'
        @title_detection = %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s+$}
      when 'Autologin.4.Z'
        raise ManualIsBlacklisted, 'is tar file' # TODO (later)
      end
      @manual_entry ||= source.file.sub(/\.(?<section>\d\S*?)(?:\.[zZ])?$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      super(source)
    end

  end
end
