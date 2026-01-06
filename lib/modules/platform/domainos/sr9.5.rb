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

class DomainIX
  class SR9_5

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
end
