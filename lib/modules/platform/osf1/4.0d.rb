# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Digital UNIX 4.0d Platform Overrides
#
# TODO
# √ vrestore(8) infinite loop - rewrite for page bug; loop in \* (get_def_str) also fixed
#

module Digital_UNIX
  module V4_0d
    class Source < Source ; end
    class Manual < Manual ; end
    class Nroff < Nroff ; end
    class Troff < Troff
      def initialize source
        case source.file
        when 'vrestore.8' then source.patch_line 126, /\\\*\\-/, "\\*L\\-"
        end
        super source
      end
    end
  end
end
