# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR9.7.5 Platform Overrides
#
# TODO:
#   acls.hlp lacks RELATED TOPICS heading
#   aa.hlp, ap.hlp, dm.hlp
#         lacks RELATED TOPICS heading; contains HELP AP unstructured ref in body text
#          - consider a link sr9 method that detects HELP ALL_CAPS anywhere
#   cdm.hlp RELATED TOPICS alt format
#   echo.hlp has multiple related topics on one line - HELP WGE, WME
#   exit.hlp has help topics in quotes - HELP 'FOR'
#

class Aegis::SR9_7_5
  class Nroff < Aegis::Nroff

    def initialize(source)
      @base_indent = 2
      @related_info_heading = 'RELATED TOPICS'

      case source.file
      when 'edacl.hlp'
        @heading_detection = %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
      when 'cc.hlp', 'lisp.hlp', 'pas.hlp'
        raise ManualIsBlacklisted, 'is unbundled'
      end

      super(source)
    end

    def page_title
      super << " Aegis SR9.7.5"
    end

  end
end
