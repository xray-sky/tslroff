# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Digital UNIX 3.2c Platform Overrides
#
# TODO
# √ vrestore(8) infinite loop - rewrite for page bug; loop in \* (get_def_str) also fixed
#   flex(1) has some overstrikes that appear misplaced / empty - Equivalence class expressions
# √  - misplaced due to text-indent style inherited from parent; that should be a css fix
# √  - empty overstrikes still outstanding
#

module Digital_UNIX
  module V3_2c
    class Source < Source ; end
    class Manual < Manual ; end
    class Nroff < Nroff ; end
    class Troff < Troff
      def initialize(source)
        case source.file
        when 'vrestore.8' then source.patch_line 111, /\\\*\\-/, "\\*L\\-"
        end
        super source
      end
    end
  end
end
