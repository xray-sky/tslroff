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

module DomainIX
  module SR9_5
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'root.3m' then raise ManualIsBlacklisted, 'not a manual entry'
        end
        super(file, **kwargs, &block)
      end
    end

    class Nroff < Nroff

      def initialize(source)
        @related_info_heading ||= 'RELATED INFORMATION'
        super(source)
      end

      def page_title
        super << " Domain/IX SR9.5"
      end

    end

    class Troff < Troff ; end

  end
end

# module aliases
AUX = DomainIX

module AUX
  module SR8_1
    class Nroff < Nroff
      def initialize(source)
        case source.file
        when 'aux.release_notes.sr8.1' then @lines_per_page = 63
        end
        super(source)
      end
    end
  end
end

# module aliases
Aegis::SR7_B = Aegis
Aegis::SR8_0 = Aegis
Aegis::SR8_1_update = Aegis
Aegis::SR9_0 = Aegis
Aegis::SR9_0_020 = Aegis
Aegis::SR9_2 = Aegis
Aegis::SR9_6 = Aegis
Aegis::SR9_7 = Aegis
Aegis::SR9_7_1 = Aegis
DomainIX::SR9_2_3 = DomainIX
DomainOS::SR10_0 = DomainOS
DomainOS::SR10_1 = DomainOS
DomainOS::SR10_1_PSK4 = DomainOS
DomainOS::SR10_2 = DomainOS
DomainOS::SR10_3 = DomainOS
