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
  class Nroff < ::DomainIX::Nroff

    def initialize(source)
      @related_info_heading ||= 'RELATED INFORMATION'
      super(source)
    end

    def source_init
      case @source.file
      when 'root.3m' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super
    end

    def page_title
      super << " Domain/IX SR9.5"
    end

  end

  class Troff < ::DomainIX::Troff ; end

end

=begin
  def self.extended(k)
    k.instance_variable_set '@lines_per_page', 66	# REVIEW: at least for /IX
    k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
    case k.instance_variable_get '@input_filename'
    when 'index.hlp'
      k.instance_variable_set '@manual_entry', '_index'
    when 'edacl.hlp'
      k.instance_variable_set '@heading_detection', %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
      k.instance_variable_set '@related_info_heading', 'RELATED TOPICS'
    when 'root.3m'
      raise ManualIsBlacklisted, 'not a manual entry'
    end
  end
=end

class AUX < :: DomainIX ; end
class AUX::SR8_0 < :: AUX ; end
class AUX::SR8_1_update < :: AUX ; end
class Aegis::SR7_B < ::Aegis ; end
class Aegis::SR8_0 < ::Aegis ; end
class Aegis::SR8_1 < ::Aegis ; end
class Aegis::SR8_1_update < ::Aegis ; end
class Aegis::SR9_0 < ::Aegis ; end
class Aegis::SR9_0_020 < ::Aegis ; end
class Aegis::SR9_2 < ::Aegis ; end
class Aegis::SR9_5 < ::DomainIX::SR9_5 ; end
class Aegis::SR9_6 < ::Aegis ; end
class Aegis::SR9_7 < ::Aegis ; end
class Aegis::SR9_7_1 < ::Aegis ; end
class DomainIX::SR9_2_3 < ::DomainIX ; end
class DomainOS::SR10_0 < ::DomainOS ; end
class DomainOS::SR10_1 < ::DomainOS ; end
class DomainOS::SR10_1_PSK4 < ::DomainOS ; end
class DomainOS::SR10_2 < ::DomainOS ; end
class DomainOS::SR10_3 < ::DomainOS ; end
