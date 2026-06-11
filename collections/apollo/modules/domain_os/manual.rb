# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#

require_relative 'utils'
require_relative 'nroff'
require_relative 'troff'
require_relative 'help'

module Aegis
  class Manual < Manual

    def initialize(file, **kwargs, &block)
      kwargs[:document_class] = Aegis::Help if File.dirname(file).include?('/help')
      super(file, **kwargs, &block)
    end

  end
end
