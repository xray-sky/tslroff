# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ardent SysV 3.0 Platform Overrides
#
# TODO
# √ find the tmac.an for 3.0 (have only tmac.vgrind??) - is in unbundled dwb (thanks vaxbarn)
#   file modification dates are as copied, not as archived
#   gamma(3m) has font size issues (leaving inline eqn? because \s10 and not \s+2 or \s\n(.s ?)
#

class Ardent_SysV::R3_0
  class Troff < Ardent_SysV::Troff

    def init_ds
      super
      @named_strings.merge!(
        {
          'Tt' => 'Stardent 1500/3000',
          ']D' => 'Stardent Computer Inc.',
        }
      )
    end

  end
end
