# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Acorn RISCix 1.2 Platform Overrides
#
# TODO
#   at least one page has SEE ALSO refs with whitespace, e.g. "ref (sec)", maybe mostly for the (1v) refs? -- also as (1V)
#    - stty(1v)
#   Mail(1) can't find man1/mail.1 to .so
#   neqn(1) numeric sub/superscripts are too large?
#   list(3r) can't find man3/List.3r to .so
# √ XCreateWindow(3x11) seem to have lost the *s in /* */ - REVIEW in this and other X pages, also intro(4n), probably more
#   math(3m) wants to use tab fill repetition char \(ru
#   nym(4) SEE ALSO refs with , (and no space)
#   tty(4) wants to use \z and \l
#   rcsfile(5) wants to ".vs 12pts" - REVIEW how troff deals with this. 12p ? or ignore.
#   several pages want to .so header files - these need adding to the input collection“
#   termcap(5) wants to manipulate environment (.ev) - REVIEW
#   hunt(6) wants to flush output buffer (.fl), and also expects to .cs - REVIEW
#   sail(6) includes explicit page break - REVIEW
#   sccstorcs(8) SEE ALSO refs with space between name and section
#

class Source
  def magic
    case File.basename(@filename)
    when 'sticky.8' then 'Troff'
    else @magic
    end
  end
end

module RISCiX_1_2

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'sticky.8'
      # misidentified as nroff
      k.instance_variable_get('@source').lines[0].insert(0, '.\\"')
    end
  end

end
