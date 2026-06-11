# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 06/8/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# Fujitsu-Siemens Reliant UNIX Platform Overrides
#
# TODO
# √ en_US MLX addendum overwriting parent pages e.g. awk, admin (where do they come from? -- answer: mixed in mlx/)
# √ de_DE crazy lines_per_page??! awk(1) - also in en_US! as(1)
#   still losing a few pages to overwrites (en_US processes 1969, apropos gives 1957; de_DE 1817 / 1811)
#

module Reliant_UNIX

  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([\dZz]\S?)$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][-A-Za-z\s]+)$)
      @lines_per_page = 58
      if source.dir.include?('_D') # TODO pass this through from Manual class
        @language = 'de'
        @related_info_heading = 'SIEHE AUCH'
      end
      super(source, **kwargs)
    end

    def to_html(halt_on: nil)
      return super if halt_on
      html = super
      @manual_entry << '.mlx' if @index_description.include?('MLX addendum')
      html
    end

    # h4x for collapsed linefeeds / random page length
    def next_line
      l = super
      unformat(l).match?(/^(?:Page|Seite) \d/) ? "\f\e7#{l}" : l
    end
  end

end
