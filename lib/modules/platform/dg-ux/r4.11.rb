# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX R4.11 Version Overrides
#

module DG_UX
  module R4_11
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when /^(?:contents|index)\d?\.(?:B2|C2|dgux|failover|nfs|onc|sdk|tcpip|X11)/
          raise ManualIsBlacklisted, 'is metadata'
        end
        super(file, **kwargs, &block)
      end
    end

    class Nroff < Nroff
      def initialize(source)
        super(source)
        @lines_per_page = nil
      end
    end
  end
end
