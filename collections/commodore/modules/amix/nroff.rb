# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Amiga SVR4 Platform Overrides
#
# TODO
#   type clashes in openlook entries - can't parse title
#

module AMIX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)?(?:\.?[Zz])?$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

  end
end
