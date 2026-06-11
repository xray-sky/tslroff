# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX 0.7 Version Overrides
#
# TODO
#    postscript pages have RCSID text?
#

module A_UX
  module V0_7
    class Nroff < Nroff

      def initialize(source, **kwargs)
        case source.file
        # title line: 'updater()     updater()'
        when 'updater.1.z'
          @manual_section = '1'
          @output_directory = 'man1'
        end
        super(source, **kwargs)
      end

    end

    def self.name_for_section(sec)
      A_UX.name_for_section(sec)
    end
  end
end
