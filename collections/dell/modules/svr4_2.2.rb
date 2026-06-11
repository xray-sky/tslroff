# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/01/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Dell SVR4 Issue 2.2 Platform Overrides
#

module Dell_SVR4
  module Issue_2_2

    class Nroff < Nroff
      def initialize(source, **kwargs)
        case File.basename source.file
        when 'olMenuShell.3.Z', 'olTxtEdt.3.Z', 'olStGagVl.3.Z'
          @title_detection ||= %r{(?<manentry>(?<cmd>\S+?))$}
        else
          @title_detection ||= %r{(?<manentry>(?<cmd>\S+?(?: Macros| Widget.+?| Focus| Conversion| Key/Button)?)\((?<section>\S+?)\))$}
        end

        super(source, **kwargs)

        case File.basename source.file
        when 'olMenuShell.3.Z', 'olTxtEdt.3.Z', 'olStGagVl.3.Z'
          @manual_section = '3W'
        when 'XTLTTProp.3X.Z', 'XSLTTProp.3X.Z', 'XChMMap.3X.Z', 'XChProp.3X.Z'
          @manual_section = '3X11'
        when 'XtCreACon.3X.Z'
          @manual_section = '3Xt'
        when 'bggen.1.Z', 'pbmtozinc.1.Z', 'xcoloredit.1.Z', 'xnetload.1.Z', 'xv.1.Z'
          @manual_section = '1L'
        when 'xcal_cal.1.Z', 'xmphone.1.Z', 'rcmd.1.Z', 'vf2bdf.1.Z', 'xplaces.1.Z'
          @manual_section = '1'
        when 'oneko.6.Z', 'neko.6.Z', 'xneko.6.Z', 'xmandel.6.Z'
          @manual_section = '6'
        end
      end
    end


    def self.name_for_section(sec)
      Dell_SVR4.name_for_section(sec)
    end

  end
end
