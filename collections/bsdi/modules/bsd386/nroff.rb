# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/17/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# BSDI BSD/386 Overrides
#

module BSD386
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      super(source, **kwargs)
    end

  end
end
