# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/08/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W2.3 Platform Overrides
#

module GL2
  module W2_3
    class Nroff < Nroff
      def initialize(source)
        case source.file
        when 'trenter.1'  # is nroff
          @heading_detection = %r{^\s{5}(?<section>[A-Z][A-Za-z0-9\s]+)$}
          @title_detection = %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
        end
        super(source)
      end
    end

    class Troff < Troff
      def initialize(source)
        case source.file
        when 'regexp.5' then source.patch_line 418, /^\.in/, '.if'
        end
        super(source)
        @version = "W2.3"
      end
    end
  end
end

