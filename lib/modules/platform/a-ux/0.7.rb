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

class A_UX::V0_7
  class Nroff < ::Nroff

    def source_init
      case @source.file
      # title line: 'updater()     updater()'
      when 'updater.1.z'
        define_singleton_method :parse_title, {
          @manual_section = '1'
          @output_directory = 'man1'
          true
        }
      end
      super
    end

  end
end
