# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX 0.7 Version Overrides
#
# TODO
#    postscript pages have RCSID text?
#

module A_UX_0_7

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'updater.1.z'
      # title line: 'updater()     updater()'
      k.define_singleton_method :parse_title, k.method(:parse_title_updater)
    end
  end

  def parse_title_updater
    @manual_section = '1'
    @output_directory = 'man1'
    true
  end
end


