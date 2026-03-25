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
  class Nroff < A_UX::Nroff

    def initialize(source)
      case source.file
      # title line: 'updater()     updater()'
      when 'updater.1.z'
        @manual_section = '1'
        @output_directory = 'man1'
      end
      super(source)
    end

  end
end

class A_UX::V2_0 < A_UX ; end
