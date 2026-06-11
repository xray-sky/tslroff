# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W2.5r1 Platform Overrides
#

module GL2
  module W2_5r1

    class Troff < Troff
      def initialize(source, **kwargs)
        super(source, **kwargs)
        @version = "W2.5r1"
      end
    end

    def self.name_for_section(sec)
      GL2.name_for_section(sec)
    end

  end
end
