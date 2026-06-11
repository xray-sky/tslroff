# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR9.5 Platform Overrides
#
# TODO:
#    SR9.0 BSD eqn(1) has postprocessed EQN. it kinda works but has "issues". and badly parsed See Also
#    SR9.0 Sys5 pages (many, not all) are not correctly processing title for manual section
#

module Aegis
  module SR9_5

    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'root.3m' then raise ManualIsBlacklisted, 'not a manual entry'
        end
        super(file, **kwargs, &block)
      end
    end

    class Manual < Manual ; end

    class Nroff < Nroff
      def initialize(source, **kwargs)
        @related_info_heading ||= 'RELATED INFORMATION'
        super(source, **kwargs)
      end

      def page_title
        super << " Domain/IX SR9.5"
      end
    end

    class Troff < Troff ; end

    def self.name_for_section(sec)
      Aegis.name_for_section(sec)
    end

  end
end
