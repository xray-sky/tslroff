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

class NEWS_os::V4_2_1R_en_US

  class Manual < ::Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'chgrp.1', 'prof.1'
        @source = Source.new(file, magic: 'Troff', source_args: source_args)
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class Troff < ::NEWS_os::Troff

    def source_init
      case @source.file
      when 'index.3', 'index.3f7768'
        @manual_entry = '_index'
      # TODO when we resolve the baseline/font issue with \u, \d, and \s
      # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
      # also there's the issue of doing rewrites in .so for gamma.3m
      #when 'lgamma.3m'
      #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
      when 'chgrp.1'
        # incorrectly recognized as nroff source as the first character is ' '
        @source.patch_line(1, /^ /, '')
      when 'prof.1'
        # incorrectly recognized as nroff source as the first character is 'p'
        @source.patch_line(1, /^p/, '.')
      end
      super
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          footer: "NEWS-OS\t\\s-2Release 4.2.1R\\s+2",
          ']D' => "NEWS-OS Programmer's Manual",
          ']W' => "7th Edition"
        }
      )
    end

  end
end
