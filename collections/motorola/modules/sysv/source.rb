# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Motorola SysV Platform Overrides
#

module Motorola_SysV
  class Source < Source

    def initialize(file, **kwargs)
      case File.basename(file)
      when 'Imakefile' then raise ManualIsBlacklisted "Imakefile"
      end
      super(file, **kwargs)
    end

  end
end
