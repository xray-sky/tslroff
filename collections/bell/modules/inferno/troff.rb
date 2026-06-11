# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/14/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno Platform Overrides
#

module Inferno
  class Troff < Troff::Man
    alias :LP :P
  end
end
