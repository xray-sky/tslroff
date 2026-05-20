# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno 4e Platform Overrides
#
# TODO
#   can't find the macros - .EE, .EX, .L, .LR, .RL, .TF, font position 5
#   .L* is probably font 'L'; might also be font pos 5
#

module Inferno
  module FourthEd
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'INDEX' then raise ManualIsBlacklisted, 'is nonsense'
        end
        super(file, **kwargs, &block)
      end
    end

    class Nroff < Nroff ; end
    class Troff < Troff ; end

    MANUAL_SECTION_NAMES = {
      '1'    => 'Commands',
      #'1e'   => '', ?
      '2'    => 'Limbo Modules and Inferno System Calls',
      '3'    => 'Kernel Devices',
      '4'    => 'File Services',
      '5'    => 'Styx File Service Protocol',
      '6'    => 'File Formats and Conventions',
      '7'    => 'Databases and Database Access Modules',
      '8'    => 'Administrative Modules and System Services',
      '9'    => 'Limbo/Tk',
      '10'   => 'Build Environment and Device Drivers',
      '10.1' => 'Kernel Build Commands',
      '10.2' => 'Kernel Functions',
      '10.6' => 'File Formats',
      '10.8' => 'Bootstrap Procedures'
    }.freeze

  end
end
