# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/13/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# BeOS Platform Overrides
#

require_relative 'html'

module BeOS
  class Manual < Manual
    def output_directory
      @source.dir.partition(%r{^.*/(?:beos/documentation|develop)/?}).last
    end
  end
end
