# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/25/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# UTek W2.3 Platform Overrides
#

module UTek_6130_W2_3

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'access.5n'
      # malformed title line: ACCESS (dfs)(5N)
      k.instance_variable_set '@output_directory', 'man5n'
    end
  end

end
