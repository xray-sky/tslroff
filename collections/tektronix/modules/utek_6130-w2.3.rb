# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/25/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# UTek 6130 W2.3 Platform Overrides
#

module UTek
  module W2_3_6130

    class Nroff < Nroff
      def initialize(source, **kwargs)
        case source.file
        # malformed title line: ACCESS (dfs)(5N)
        when 'access.5n' then @manual_section = '5n'
        end
        super(source, **kwargs)
      end
    end

    def self.name_for_section(sec)
      UTek.name_for_section(sec)
    end

  end
end
