# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Solbourne OS/MP Platform Overrides
#

module OS_MP
  class Nroff < Nroff

    def initialize(source, **kwargs)
      case source.file
      when 'ce_db_build.1', 'ce_db_merge.1' # no title line
        @manual_section = '1'
        @manual_entry = (source.file)[0..-3]
        # TODO also has see also link w/ whitespace (e.g. "ref (section)")
      end
      super(source, **kwargs)
      @lines_per_page = nil
    end

  end
end
