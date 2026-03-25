# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX R4.11 Version Overrides
#

class DG_UX::R4_11
  class Manual < DG_UX::Manual
    def initialize file, vendor_class: nil, source_args: nil
      case File.basename file
      when /^(?:contents|index)\d?\.(?:B2|C2|dgux|failover|nfs|onc|sdk|tcpip|X11)/
        raise ManualIsBlacklisted, 'is metadata'
      end

      srcargs = source_args.dup || {}
      srcargs[:encoding] = Encoding::ISO_8859_1

      super file, vendor_class: vendor_class, source_args: srcargs
    end
  end

  class Nroff < DG_UX::Nroff

    def initialize(source)
      super(source)
      @lines_per_page = nil
    end

  end
end


