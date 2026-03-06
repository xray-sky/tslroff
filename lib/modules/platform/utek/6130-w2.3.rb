# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/25/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# UTek W2.3 Platform Overrides
#

class UTek::W2_3_6130
  class Nroff < ::UTek::Nroff

    def source_init
      case @source.file
      when 'access.5n'
        # malformed title line: ACCESS (dfs)(5N)
        @output_directory = 'man5n'
      end
      super
    end

  end
end
