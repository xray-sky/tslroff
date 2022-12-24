# encoding: US-ASCII
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

module OSF1_4_0d

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'vrestore.8.gz'
      k.instance_variable_get('@source').lines[125].sub!(/\\\*\\-/, "\\*L\\-")
    end
  end

end
