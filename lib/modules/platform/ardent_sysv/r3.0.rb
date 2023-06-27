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
#   modification dates
#   gamma(3m) has font size issues (leaving inline eqn? because \s10 and not \s+2 or \s\n(.s ?)
#

module Ardent_SysV_R3_0

  #def self.extended(k)
  #
  #end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        'Tt' => 'Stardent 1500/3000',
        ']D' => 'Stardent Computer Inc.',
      }
    )
  end

end

