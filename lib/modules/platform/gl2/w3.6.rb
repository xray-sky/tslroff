# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W3.6 Platform Overrides
#
# TODO
#    adb(1) ::
#        .ie '\*(.T'psc' .ds IM \(im
#        .el .ds IM \v'.1m'=\v'-.1m'\s-2\h'-.1m'>\h'.1m'\s+2
#      our \*(.T is 'html' and we don't have an \(im defined. but maybe we want to implement something.
#

class GL2::W3_6
  class Troff < GL2::Troff

    def initialize(source)
      case source.file
      when 'intro.2'  then source.patch_line 317, /\\x-1/, '\s-1'
      when 'tz.4'     then source.patch_line  45, /center\./, 'center;'
      when 'regexp.5' then source.patch_line 419, /^\.in/, '.if'
      end
      super(source)
      @version = "W3.6"
    end

  end
end


=begin <- bootstrap from W2.5

TODO:

 check para spacing in Bugs on 300(1) & 450(1)
 related link fault on bs(1)
 check double quotes on .TP args in acctcon(1m)
 check crazy tabs in Display Options on arch(1d)		-- confirmed page bug
 capture(1w)	unnamed section at start - .SH\(Dy ??
 how did a <br> end up in the footer on ci(1)?
 check odd whitespace in col(1)							-- confirmed page bug
 problem with defined macros in comb(1) - truncated
 check odd alignment in position designators on csh(1)	-- confirmed page bug
 text wrap within TP tag in conv on dd(1) due to \|
 problem with defined macros in delta(1) - truncated
 run on bold format in eqn(1); line 46
 check crazy tabs in Description on ex(1)				-- confirmed page bug
 factor(1)		check square root for proper display (use of \o)
 find(1)		malformed tag in Description			-- appears likely page bug
 get(1)			table crazy
 heme(1d)		uses .bp in a way that suggests an .sp substitution REVIEW
 hp(1)			odd spacing in Diagnostics				-- confirmed correct
 install(1)		odd spacing in Examples					-- confirmed essentially correct
 jet(1d)		crazy tabs in Description				-- appears to be font metric fencepost
 sendmail(1m)	maybe too wide in exit statuses? fault in .ti (needs to send negative indent to temp_indent)
 sh(1)			crazy tabs in Files						-- appears to be font metric fencepost
 shuttle(1d)	crazy tabs in Description				-- appears to be font metric fencepost
 spline(1g)		contains eqn macros
 vmstat(1m)		at least one page appears to ref vmstat(1)

 arcg(3g)		unnamed section at start (from \(Dy)
 gamma(3m)		contains eqn macros
 intro(3g)		odd indents (.ti bug?)

 a.out(4)		too much .sp (.sp 6em + .sp -6em ???)
 fstab(4)		check indent on NFS options
 holidays(4)	crazy tabs in Description

 me(5)			crazy Requests
 ms(5)			exposed &roffctl
 passwd(4)		unexpected font usage

 boot(8)		".fi" appears in output as text (requests in tbl text block)

=end
