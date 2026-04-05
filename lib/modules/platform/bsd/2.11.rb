# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# BSD 2.11 Platform Overrides (tmac.an.new) - same as 4.3_VAX_MIT except extra cases in .UC
#
# TODO
# √ macros
# √ manual section may be e.g. 4f or 4n (currently output directory is just man4/)
#

class BSD::V2_11
  class Troff < BSD::Troff

    # tmac.an.new
    def UC(v = nil, *_args)
      ds(']W ' + case v
                 when '2' then '2nd Berkeley Distribution' # is actually "2rd" in tmac.an.new
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 when '7' then '4.4 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
        )
    end

  end
end
