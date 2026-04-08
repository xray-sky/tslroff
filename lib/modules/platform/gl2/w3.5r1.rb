# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/08/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W3.5r1 Platform Overrides
#

module GL2
  module W3_3_1
    class Troff < Troff
      def initialize(source)
        super(source)
        @version = "W3.3.1"
      end
    end
  end

  module W3_5r1
    class Troff < Troff
      def initialize(source)
        super(source)
        @version = "W3.5r1"
      end
    end
  end
end

