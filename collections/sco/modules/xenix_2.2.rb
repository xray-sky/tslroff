# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# SCO Xenix 2.2 Platform Overrides
#
# TODO
#   Some section titles are all caps (so 'See Also' is not matched)
#   Some related info refs have whitespace between manual and section
#

module Xenix
  module V2_2
    class Nroff < Nroff

      def initialize(source, **kwargs)
        @related_info_heading ||= 'SEE ALSO'
        super
      end

    end
  end
end
