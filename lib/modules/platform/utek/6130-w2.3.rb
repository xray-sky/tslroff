# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/25/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# UTek W2.3 Platform Overrides
#

module UTek
  module W2_3_6130
    class Nroff < Nroff
      def initialize(source)
        case source.file
        # malformed title line: ACCESS (dfs)(5N)
        when 'access.5n' then @manual_section = '5n'
        end
        super source
      end
    end
  end
end
