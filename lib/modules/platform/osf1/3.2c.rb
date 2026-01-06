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
#

class Digital_UNIX
  class V32c
    class Troff < ::OSF1::Troff

      def source_init
        case @source.file
        when 'vrestore.8' then @source.patch_line 111, /\\\*\\-/, "\\*L\\-"
        end
        super
      end

    end
  end
end
