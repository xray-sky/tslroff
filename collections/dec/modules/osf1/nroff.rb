# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#

module OSF1
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(?<filesection>\d\S*)(?:\.[zZ])?$/, '')
      #@manual_section = Regexp&.last_match&.[](:filesection)
      super
    end

  end
end

