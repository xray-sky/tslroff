# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop 1.1.1g Platform Overrides
#

class OpenDesktop::V1_1_1g

  class Manual < OpenDesktop::Manual
    ZEXTRA = %w[ ksh.C.z messages.M.z terminfo.M.z X.X.z mwm.X.z scoterm.X.z xdm.X.z xterm.X.z ]

    def initialize(file, vendor_class: nil, source_args: nil)
      srcargs = source_args.dup || {}
      if ZEXTRA.include? File.basename(file)
        srcargs[:magic] = 'Nroff'
        super(file, vendor_class: vendor_class, source_args: srcargs) { |f| IO.readlines("| gzip_10.6 -dc #{f} | zcat") }
      else
        super(file, vendor_class: vendor_class, source_args: srcargs)
      end
    end
  end

  class Nroff < OpenDesktop::Nroff
    def initialize(source)
      case source.file
      when 'bdftosnf.X.z', 'ico.X.z', 'mkfontdir.X.z', 'oclock.X.z', 'showsnf.X.z',
           'xdpyinfo.X.z', 'xev.X.z', 'xeyes.X.z', 'xmodmap.X.z', 'xset.X.z', 'xwininfo.X.z'
        @title_detection = %r{^\s{4}(?<manentry>(?<cmd>\S+?)\s\((?<section>[A-Z]+)\))\s+}
        @related_info_heading = 'SEE ALSO'
      end
      @heading_detection ||= %r(^\s{4,5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
      @related_info_heading ||= 'See Also'
      super(source)
    end

  end
end
