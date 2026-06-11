# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# MWC Coherent Platform Overrides
#

require_relative 'nroff'

module Coherent
  class Manual < Manual
    def output_directory
      @source.dir.split('/').last
    end
  end
end
