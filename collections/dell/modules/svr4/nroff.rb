# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/01/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Dell SVR4 Platform Overrides
#

module Dell_SVR4

  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(?:\d\S?)(?:\.g?[zZ])?$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][-A-Za-z\s]+):?$)
      @title_detection ||= %r{(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))$}
      super(source, **kwargs)
    end
  end

end
