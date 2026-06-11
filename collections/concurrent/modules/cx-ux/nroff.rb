# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Concurrent CX/UX Platform Overrides
#

module CX_UX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)(?:\.z)?$/, '') # nroff pages are compressed
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

  end
end
