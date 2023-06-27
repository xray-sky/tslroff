# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Concurrent CX/UX 6.20 Platform Overrides
#
# TODO
#   troff manuals don't seem to have altnames given, so e.g. min(3F) is troff, but min0(3F), amin0(3F), etc. all nroff
#
#   font shme: \f3 (if not bold), \f4, \f5, \fl
#   extensive use of \f4 (which is... what?)
#    - I don't see any straight bold, and it's used in that way, so maybe that's what it is.
#    - but then, what's \f3? does it matter if it's not used?
#   use of \fL right next to \f4 in acc_vector(4) so probably that's not in the running
#   use of \fl in sar(1m) - what is that
#   use of \f5 in sendmail(1m), addseverity(3c), fmtmsg(3c), admin(1) - what is that, maybe CW. used in section 3c for console output
#   use of \f3 in several pages in section 7 - for subsection head, and once in text as emphasis (almost certainly plain bold)
#   use of \f3 in ar(4), fs(4)
#   use of \f4 and \f3 right next to each other in pathfind(3x)
#   acc_vector(4) tbl expects to use \f3 to set entire row
#    - don't seem to have troff or the fonts, so I guess \fl is a mystery for now
#

module CX_UX_6_20

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'cxref.1'
      k.instance_variable_get('@source').lines[11].sub!(/$/, 'P') # suppress the warning, doesn't need action
    when 'ftp.1c'
      k.instance_variable_get('@source').lines[209].sub!(/$/, 'P') # suppress the warning, doesn't need action
      k.instance_variable_get('@source').lines[355].sub!(/\\P/, 'P') # suppress the warning, doesn't need action
    when 'index.3c.z', 'index.3f.z', 'index.3x.z'
      k.instance_variable_set '@manual_entry', '_index'
    when 'localeconv.3c'
      k.instance_variable_get('@source').lines[37].sub!(/\\fp/, '') # suppress the warning, doesn't need action
      k.instance_variable_get('@source').lines[41].sub!(/\\fp/, '') # suppress the warning, doesn't need action
    when 'gps.4'
      k.instance_variable_get('@source').lines[16].sub!(/$/, 'P') # suppress the warning, doesn't need action
    end
  end

end
