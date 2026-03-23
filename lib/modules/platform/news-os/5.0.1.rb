# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 5.0.1 Platform Overrides
#
# Yes, it actually does use the same macro file as SunOS 4.0.
# Just the definition of ]W changes (to not say SunOS)
# not sure ]W matters, as the troff pages are all X-related
# and I think have their own ]W via .TH
#
# TODO
#   ...-bsd pages (systype crib)
#    - there are some overlaps (e.g. cc(1), cc(1-bsd)) but the SEE ALSO links don't specify
#

require_relative '../sunos'
require_relative '../sunos/4.0'

class NEWS_os::V5_0_1
  class Nroff < ::NEWS_os::Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r{^(?<section>[A-Z][A-Za-z\s]+)$}
      @title_detection ||= %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))} # REVIEW now what?
      super(source)
    end
  end

  class Troff < ::SunOS::V4_0::Troff

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          ']W' => File.mtime(@source.path).strftime('%B %d, %Y'),
        }
      )
    end

  end
end
