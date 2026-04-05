# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SGI GL1-W2.1 Platform Overrides
#
# REVIEW mv(5)
#

class GL2::W2_1
  class Troff < GL2::Troff

    def initialize(source)
      case source.file
      when 'regexp.5' then source.patch_line 418, /^\.in/, '.if'
      end
      super(source)
      @version = "W2.1"
    end

  end
end

