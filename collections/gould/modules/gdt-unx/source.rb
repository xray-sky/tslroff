# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Gould G-NIX Platform Overrides
#

module GDT_UNX
  class Source < Source

    def initialize(file, **kwargs, &block)
      case File.basename(file)
      when 'Script', 'Scrit' then raise ManualIsBlacklisted, 'not a manual entry'
      end

      super(file, **kwargs, &block)

      case @file
      # REVIEW there are several pages that exist as 'copy___'. are these all strict duplicates?
      # cpmcopy.9 is ~66 lines per page but the first page is short. Insert extra lines after the title.
      when 'cpmcopy.9' then @lines.insert(25, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
      end
    end

  end
end
