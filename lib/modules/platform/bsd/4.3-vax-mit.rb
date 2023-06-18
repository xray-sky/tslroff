# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BSD 4.3-VAX-MIT Platform Overrides (tmac.an.new)
#
# TODO
#

module BSD_4_3_VAX_MIT

  def self.extended(k)
  end

  # tmac.an.new
  define_method 'UC' do |v = nil, *_args|
    req_ds(']W ' + case v
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end
          )
  end

end
