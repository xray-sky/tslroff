# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W2.5 Platform Overrides
#

module GL2_W2_5

=begin

TODO:

 check para spacing in Bugs on 300(1) & 450(1)
 related link fault on bs(1)
 check double quotes on .TP args in acctcon(1m)
 check crazy tabs in Display Options on arch(1d)		-- confirmed page bug
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
 ftp(1c)		run-on bold/tag for hash cmd			-- confirmed page bug; line 211 rewrite needed
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

 arcg(3g)		unnamed section at start
 gamma(3m)		contains eqn macros
 intro(3g)		odd indents (.ti bug?)

 a.out(4)		too much .sp (.sp 6em + .sp -6em ???)
 fstab(4)		check indent on NFS options
 gps(4)			unprocessed escapes in .SH/.SM
 holidays(4)	crazy tabs in Description

 me(5)			crazy Requests
 ms(5)			exposed &roffctl
 passwd(4)		unexpected font usage

 boot(8)		".fi" appears in output as text (requests in tbl text block)

=end
end


