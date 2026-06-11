# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#
# .\" Basic Font Usage:
# .\"   For *troff processing, these macros assume the fonts are in the
# .\"   following order:
# .\"	  Position: 1  2  3  4  5  6  7  8  9  10 11 12
# .\"	  Font:     R  I  B  BI CW CB H  HI HB HX S1 S
#
# TODO
# √ OSF/1 3.0 macros (an, an.repro, rsml, sml) (identical to 3.2c except copyright date)
#
# √ something's got to be done about the huge volume of warnings from all the comments
#     in the osf macro files. .so of them on every. goddamn. page. is fucking killing us.
#
# √ reference links are all bogus
# √  - http://dev.online.typewritten.org/Manual/DEC/Tru64/5.1b/man1ssl/%E2%80%8D%3Cstrong%3Egendsa%E2%80%8D.html
# √  - section 1ssl only? no, I see it in section 1 too. was ok in (the one page in) 3cde.
# √  - looks like it's full of &zwj; (likely from \*L and \*O) and this is probably the problem.
#
# √ some pages have RELATED INFORMATION instead of SEE ALSO
#   cdoc(1) [3.0] has 'See Also'
#   CA.pl(1s) no read perms on output??? (because it is named .pl? looks like it)
#   hier(7) links Functions:‍symlink‍(2) -- lack of whitespace; other pages WITH whitespace still linking this way
# √ lp(1) [1.0/mips] infinite loop => stack overflow due to double inclusion of sml/rsml macros
# √   - the 1.0 macros do not guard against this like the 3.x macros do
#

require_relative 'modules/osf1/manual'
require_relative 'modules/osf1_3.2c'
require_relative 'modules/osf1_4.0d'

module OSF1

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1b'    then "<strong>#{sec}.</strong> Bourne Shell"
    when '1cde'  then "<strong>#{sec}.</strong> CDE Commands"
    when '1g'    then "<strong>#{sec}.</strong> GNU Commands"
    when '1m'    then "<strong>#{sec}.</strong> Motif Commands"
    when '1old'  then "<strong>#{sec}.</strong> Obsoleted Commands"
    when '1p'    then "<strong>#{sec}.</strong> POSIX Commands"
    when '1ssl'  then "<strong>#{sec}.</strong> OpenSSL Commands"
    when '1u'    then "<strong>#{sec}.</strong> Compatibility Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1xmit' then "<strong>#{sec}.</strong> X11 Commands (MIT)"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2sv'   then "<strong>#{sec}.</strong> System V Calls"
    when '3'     then "<strong>#{sec}.</strong> Library Functions"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'    then "<strong>#{sec}.</strong> PHIGS Library"  # TODO is OpenGL @ Tru64 5.1
    when '3gl'   then "<strong>#{sec}.</strong> OpenGL Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Libraries"
    when '3xt'   then "<strong>#{sec}.</strong> X Toolkit"
    when '4'     then "<strong>#{sec}.</strong> File Formats"
    when '4cde'  then "<strong>#{sec}.</strong> CDE File Formats"
    when '5'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5x'    then "<strong>#{sec}.</strong> Motif File Formats"
    when '6'     then "<strong>#{sec}.</strong> Games and Demos"
    when '7'     then "<strong>#{sec}.</strong> Special Files"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8x'    then "<strong>#{sec}.</strong> DECwindows Maintenance Tools"
    when '8cdfs' then "<strong>#{sec}.</strong> ISO 9660 Commands"
    when '9'     then "<strong>#{sec}.</strong> Kernel Modules"
    when '9r'    then "<strong>#{sec}.</strong> Kernel Module Routines"
    when '9s'    then "<strong>#{sec}.</strong> Kernel Module Data Structures"
    when '9v'    then "<strong>#{sec}.</strong> Kernel Module Global Variables"
    else "Section #{sec}"
    end
  end

end

# module aliases
Digital_UNIX = OSF1
Tru64 = OSF1
Tru64::V4_0f = Tru64
