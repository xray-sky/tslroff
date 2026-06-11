# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# MWC Coherent Platform Overrides
#
#  these are all nroff without the normal unix online manual
#  structures around them
#

require_relative 'modules/coherent/manual'

module Coherent

  def self.name_for_section(sec)
    # TODO - take sections from dir names?
    String.new
  end

end
