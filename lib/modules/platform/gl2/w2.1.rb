# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SGI GL1-W2.1 Platform Overrides
#

module GL2_W2_1

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'regexp.5'
      k.instance_variable_get('@source').lines[418].sub!(/^\.in/, '.if')
    end
  end

end
