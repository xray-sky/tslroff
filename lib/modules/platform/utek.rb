# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/21/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Tektronix UTek Platform Overrides
#
# TODO: rewrite busted overstrike |^H'+' (&dagg;) in signal(3c)
# REVIEW: what's with the final page of the nroff stuff -- %%index%% ??
#
# TODO: getting extra section info in filename for e.g. 1csh, 1sccs (not 1m, etc.)

module UTek

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([\dZz][^.]*)$/, '')
  end

end


