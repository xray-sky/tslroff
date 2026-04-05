# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.2.1R Platform Overrides
#
# TODO
# TODO pic - libfcvg(3x)
#

module NEWS_os
  module V4_2_1R_en_US
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'chgrp.1', 'prof.1' then srcargs[:magic] = 'Troff'
        end
        super(source, **kwargs, &block)
        case @file
        # TODO when we resolve the baseline/font issue with \u, \d, and \s
        # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
        # also there's the issue of doing rewrites in .so for gamma.3m
        #when 'lgamma.3m' then source.lines[26].gsub!(/\\s10/, "\\s12")
        # incorrectly recognized as nroff source as the first character is ' '
        when 'chgrp.1' then source.patch_line(1, /^ /, '')
        # incorrectly recognized as nroff source as the first character is 'p'
        when 'prof.1' then source.patch_line(1, /^p/, '.')
        end
      end
    end

    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            footer: "NEWS-OS\t\\s-2Release 4.2.1R\\s+2".+@,
            ']D' => "NEWS-OS Programmer's Manual",
            ']W' => "7th Edition"
          }
        )
      end
    end
  end
end
