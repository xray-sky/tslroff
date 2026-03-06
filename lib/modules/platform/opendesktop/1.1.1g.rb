# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop 1.1.1g Platform Overrides
#

class Source
  def magic
    case File.basename(@filename)
    when 'ksh.C.z', 'messages.M.z',
         'terminfo.M.z', 'X.X.z', 'mwm.X.z', 'scoterm.X.z', 'xdm.X.z', 'xterm.X.z'
      'Nroff'
    else @magic
    end
  end
end

module OpenDesktop_1_1_1g

  class Manual < ::Manual
    ZEXTRA = %w[ ksh.C.z messages.M.z terminfo.M.z X.X.z mwm.X.z scoterm.X.z xdm.X.z xterm.X.z ]

    def initialize(file, vendor_class: nil, source_args: {})
      if ZEXTRA.include? File.basename(file)
        @source = Source.new(file, magic: 'Nroff', source_args: source_args) { |f| IO.readlines("| gzip_old -dc #{f} | zcat") }
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class Nroff < ::OpenDesktop::Nroff
    def initialize(source)
      @heading_detection ||= %r(^\s{4,5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
      @related_info_heading ||= 'See Also'
      super(source)
    end

    def source_init
      case @source.file
      when 'bdftosnf.X.z', 'ico.X.z', 'mkfontdir.X.z', 'oclock.X.z', 'showsnf.X.z',
           'xdpyinfo.X.z', 'xev.X.z', 'xeyes.X.z', 'xmodmap.X.z', 'xset.X.z', 'xwininfo.X.z'
        @title_detection = %r{^\s{4}(?<manentry>(?<cmd>\S+?)\s\((?<section>[A-Z]+)\))\s+}
        @related_info_heading = 'SEE ALSO'
      end
      super
    end

  end
end
