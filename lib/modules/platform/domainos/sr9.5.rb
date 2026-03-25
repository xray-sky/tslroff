# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR9.5 Platform Overrides
#
# TODO:
#

class DomainIX::SR9_5
  class Manual < DomainIX::Manual
    def initialize file, vendor_class: nil, source_args: nil
      case File.basename file
      when 'root.3m' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Nroff < DomainIX::Nroff

    def initialize(source)
      @related_info_heading ||= 'RELATED INFORMATION'
      super(source)
    end

    def page_title
      super << " Domain/IX SR9.5"
    end

  end

  class Troff < DomainIX::Troff ; end

end

class AUX < DomainIX ; end
class AUX::SR8_0 < AUX ; end

class AUX::SR8_1
  class Nroff < DomainIX::Nroff
    def initialize(source)
      case source.file
      when 'aux.release_notes.sr8.1' then @lines_per_page = 63
      end
      super(source)
    end
  end
end

class Aegis::SR7_B < Aegis ; end
class Aegis::SR8_0 < Aegis ; end
class Aegis::SR8_1 < Aegis ; end
class Aegis::SR8_1_update < Aegis ; end
class Aegis::SR9_0 < Aegis ; end
class Aegis::SR9_0_020 < Aegis ; end
class Aegis::SR9_2 < Aegis ; end
class Aegis::SR9_5 < DomainIX::SR9_5 ; end
class Aegis::SR9_6 < Aegis ; end
class Aegis::SR9_7 < Aegis ; end
class Aegis::SR9_7_1 < Aegis ; end
class DomainIX::SR9_2_3 < DomainIX ; end
class DomainOS::SR10_0 < DomainOS ; end
class DomainOS::SR10_1 < DomainOS ; end
class DomainOS::SR10_1_PSK4 < DomainOS ; end
class DomainOS::SR10_2 < DomainOS ; end
class DomainOS::SR10_3 < DomainOS ; end
