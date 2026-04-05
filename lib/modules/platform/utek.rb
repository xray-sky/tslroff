# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/21/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Tektronix UTek Platform Overrides
#
# TODO rewrite busted overstrike |^H'+' (&dagg;) in signal(3c)
# REVIEW what's with the final page of the nroff stuff -- %%index%% ??
#        see buildif(1man) and manindex(5man) for details
#
# TODO getting extra section info in filename for e.g. 1csh, 1sccs (not 1m, etc.)

module UTek
  class Nroff < Nroff
    def initialize source
      @manual_entry ||= source.file.sub(/\.([\dZz][^.]*)$/, '')
      super source
    end
  end
end


