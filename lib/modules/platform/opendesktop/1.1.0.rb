# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop 1.1.0 Platform Overrides
#
# TODO
#   binary garbage in several pages?? - they're packed AND compressed.
#

module OpenDesktop_1_1_0

  def self.extended(k)
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
    k.instance_variable_set '@related_info_heading', 'See Also'
    case k.instance_variable_get '@input_filename'
    # ...really?
    # these are all packed, and THEN compressed.
    when 'Intro.ADM.z', 'accept.ADM.z', 'authsh.ADM.z', 'brc.ADM.z', 'clri.ADM.z', 'cprint.ADM.z',
         'crash.ADM.z', 'dcopy.ADM.z', 'dial.ADM.z', 'divvy.ADM.z', 'dmesg.ADM.z', 'dparam.ADM.z',
         'fdisk.ADM.z', 'fdswap.ADM.z', 'fsave.ADM.z', 'fsname.ADM.z', 'fsstat.ADM.z', 'graph.ADM.z',
         'idtune.ADM.z', 'ipcrm.ADM.z', 'kbmode.ADM.z', 'link.ADM.z', 'list.ADM.z', 'lpsh.ADM.z',
         'mkfs.ADM.z', 'mnlist.ADM.z', 'mvdir.ADM.z', 'ncheck.ADM.z', 'rc0.ADM.z', 'rc2.ADM.z',
         'rmail.ADM.z', 'rmpkg.ADM.z', 'sfmt.ADM.z', 'strace.ADM.z', 'strerr.ADM.z', 'submit.ADM.z',
         'swap.ADM.z', 'sysdef.ADM.z', 'timex.ADM.z', 'tplot.ADM.z', 'umount.ADM.z', 'uuxqt.ADM.z',
         'wtinit.ADM.z', 'xtd.ADM.z', 'xts.ADM.z', '4014.C.z', 'assign.C.z', 'at.C.z', 'auths.C.z',
         'awk.C.z', 'bfs.C.z', 'cal.C.z', 'calendar.C.z', 'chgrp.C.z', 'cmp.C.z', 'col.C.z',
         'compress.C.z', 'cp.C.z', 'crypt.C.z', 'csplit.C.z', 'ct.C.z', 'cu.C.z',
         'date.C.z', 'dc.C.z', 'df.C.z', 'diff.C.z', 'diff3.C.z',
         'disable.C.z', 'dos.C.z', 'dtox.C.z', 'du.C.z', 'enable.C.z', 'env.C.z',
         'expr.C.z', 'getopt.C.z', 'grpcheck.C.z', 'hd.C.z', 'hello.C.z', 'hwconfig.C.z',
         'i286emul.C.z', 'ismpx.C.z', 'join.C.z', 'l.C.z', 'layers.C.z', 'lc.C.z', 'line.C.z',
         'lock.C.z', 'lprint.C.z', 'ls.C.z', 'man.C.z', 'mkdir.C.z', 'mknod.C.z', 'more.C.z',
         'newgrp.C.z', 'news.C.z', 'nice.C.z', 'nohup.C.z', 'od.C.z', 'pack.C.z', 'passwd.C.z',
         'pcpio.C.z', 'pg.C.z', 'ps.C.z', 'pstat.C.z', 'ptar.C.z', 'purge.C.z', 'pwd.C.z',
         'quot.C.z', 'random.C.z', 'rcp.C.z', 'rm.C.z', 'rsh.C.z', 'sdiff.C.z', 'sed.C.z',
         'setcolor.C.z', 'sleep.C.z', 'sort.C.z', 'strings.C.z', 'stty.C.z', 'su.C.z', 'sum.C.z',
         'swconfig.C.z', 'tabs.C.z', 'tape.C.z', 'tapedump.C.z', 'test.C.z', 'tic.C.z', 'time.C.z',
         'touch.C.z', 'tput.C.z', 'tr.C.z', 'true.C.z', 'tty.C.z', 'units.C.z', 'uptime.C.z',
         'usemouse.C.z', 'uucp.C.z', 'uuencode.C.z', 'vc.C.z', 'vmstat.C.z', 'wait.C.z', 'wc.C.z',
         'write.C.z', 'x286emul.C.z', 'xtod.C.z', '86rel.F.z', 'Intro.F.z', 'ar.F.z', 'archive.F.z', 'cpio.F.z',
         'default.F.z', 'devices.F.z', 'dialers.F.z', 'dir.F.z', 'dirent.F.z', 'filesys.F.z', 'gps.F.z',
         'inode.F.z', 'issue.F.z', 'langif.F.z', 'ldfcn.F.z', 'logs.F.z', 'maildel.F.z', 'maxuus.F.z',
         'maxuux.F.z', 'mdevice.F.z', 'mtune.F.z', 'mvdevice.F.z', 'null.F.z', 'passwd.F.z',
         'purge.F.z', 'queue.F.z', 'sfsys.F.z', 'stat.F.z', 'stune.F.z', 'syms.F.z', 'sysfiles.F.z',
         'systemid.F.z', 'systems.F.z', 'tar.F.z', 'term.F.z', 'timezone.F.z', 'unistd.F.z',
         '80387.HW.z', 'audit.HW.z', 'fd.HW.z', 'lp.HW.z', 'prf.HW.z', 'scsi.HW.z', 'serial.HW.z',
         'Intro.M.z', 'chrtbl.M.z', 'clone.M.z', 'coltbl.M.z', 'console.M.z', 'cvtcoff.M.z',
         'environ.M.z', 'getclk.M.z', 'getty.M.z', 'init.M.z', 'layers.M.z', 'ld.M.z',
         'locale.M.z', 'log.M.z', 'mapkey.M.z', 'math.M.z', 'montbl.M.z', 'mscreen.M.z',
         'multiscr.M.z', 'promain.M.z', 'systty.M.z', 'term.M.z', 'termio.M.z', 'termios.M.z',
         'timod.M.z', 'trchan.M.z', 'tty.M.z', 'tz.M.z', 'bitmap.X.z', 'xman.X.z', 'xterm.X.z'
      k.instance_variable_set '@source', IO.readlines("| gzip_old -dc #{k.instance_variable_get '@source_dir'}/#{k.instance_variable_get '@input_filename'} | zcat")
      k.instance_variable_get('@source').define_singleton_method(:lines) { self }
    # also these (GRRR)
    # arrived with magic :Unknown
    # TODO
    #  - acct.ADM, acctsh.ADM, others didn't get See Also ?
    #  - at least accton.ADM did?
    when 'acct.ADM.z', 'accton.ADM.z', 'acctsh.ADM.z', 'addx.ADM.z', 'adfmt.ADM.z', 'auditd.ADM.z',
         'authck.ADM.z', 'backup.ADM.z', 'badtrk.ADM.z', 'chroot.ADM.z',
         'custom.ADM.z', 'ff.ADM.z', 'fsck.ADM.z', 'fsdb.ADM.z', 'fstyp.ADM.z',
         'fwtmp.ADM.z', 'goodpw.ADM.z', 'id.ADM.z', 'idinst.ADM.z', 'ipcs.ADM.z', 'majors.ADM.z',
         'mkdev.ADM.z', 'mmdf.ADM.z', 'mount.ADM.z', 'proto.ADM.z', 'reduce.ADM.z', 'sag.ADM.z',
         'sar.ADM.z', 'setmnt.ADM.z', 'shtdwn.ADM.z', 'sync.ADM.z', 'tcbck.ADM.z', 'uadmin.ADM.z',
         'uucico.ADM.z', 'uulist.ADM.z', 'uutry.ADM.z', 'wall.ADM.z', 'xtt.ADM.z', '300.C.z', '450.C.z',
         'Intro.C.z', 'banner.C.z', 'basename.C.z', 'bc.C.z', 'bdiff.C.z', 'cat.C.z', 'cd.C.z',
         'chmod.C.z', 'chown.C.z', 'clear.C.z', 'comm.C.z', 'copy.C.z', 'cpio.C.z', 'cron.C.z',
         'crontab.C.z', 'csh.C.z', 'cut.C.z', 'dd.C.z', 'devnm.C.z', 'dircmp.C.z', 'dirname.C.z',
         'diskcp.C.z', 'dtype.C.z', 'echo.C.z', 'ed.C.z', 'ex.C.z', 'factor.C.z', 'false.C.z',
         'file.C.z', 'find.C.z', 'finger.C.z', 'fixhdr.C.z', 'format.C.z', 'getopts.C.z', 'gets.C.z',
         'greek.C.z', 'grep.C.z', 'head.C.z', 'hp.C.z', 'id.C.z', 'jterm.C.z', 'jwin.C.z',
         'ksh.C.z', 'last.C.z', 'ln.C.z', 'logname.C.z', 'lp.C.z', 'lpstat.C.z', 'machid.C.z',
         'mail.C.z', 'mesg.C.z', 'mnt.C.z', 'mv.C.z', 'newform.C.z', 'nl.C.z', 'paste.C.z',
         'pax.C.z', 'pr.C.z', 'pwcheck.C.z', 'rcvtrip.C.z', 'remote.C.z', 'rmdir.C.z', 'sddate.C.z',
         'setkey.C.z', 'sh.C.z', 'shl.C.z', 'spell.C.z', 'spline.C.z', 'split.C.z', 'tail.C.z',
         'tapecntl.C.z', 'tar.C.z', 'tee.C.z', 'tset.C.z', 'umask.C.z', 'uname.C.z', 'uniq.C.z',
         'uustat.C.z', 'uuto.C.z', 'uux.C.z', 'vi.C.z', 'vidi.C.z', 'w.C.z', 'what.C.z',
         'who.C.z', 'whodo.C.z', 'xargs.C.z', 'yes.C.z', 'a.out.F.z', 'authcap.F.z', 'clock.F.z',
         'core.F.z', 'filehdr.F.z', 'filesyst.F.z', 'fspec.F.z', 'group.F.z', 'hs.F.z', 'inittab.F.z',
         'limits.F.z', 'linenum.F.z', 'mapchan.F.z', 'mem.F.z', 'mfsys.F.z', 'micnet.F.z',
         'mnttab.F.z', 'nl_type.F.z', 'permiss.F.z', 'plot.F.z', 'pnch.F.z', 'poll.F.z', 'reloc.F.z',
         'sccsfile.F.z', 'scnhdr.F.z', 'scr_dump.F.z', 'sdevice.F.z', 'tables.F.z', 'termcap.F.z',
         'terminfo.F.z', 'top.F.z', 'types.F.z', 'utmp.F.z', 'x.out.F.z', 'xbackup.F.z', 'Intro.HW.z',
         'boot.HW.z', 'cdrom.HW.z', 'cmos.HW.z', 'hd.HW.z', 'machine.HW.z', 'mouse.HW.z', 'ramdisk.HW.z',
         'rtc.HW.z', 'screen.HW.z', 'tape.HW.z', 'xt.HW.z', 'ascii.M.z', 'cvtomf.M.z', 'fcntl.M.z',
         'isverify.M.z', 'jagent.M.z', 'login.M.z', 'mapchan.M.z', 'messages.M.z', 'mestbl.M.z', 'numtbl.M.z',
         'prof.M.z', 'profile.M.z', 'rmb.M.z', 'streamio.M.z', 'sxt.M.z', 'terminfo.M.z', 'timtbl.M.z',
         'tirdwr.M.z', 'values.M.z', 'xtproto.M.z', 'X.X.z', 'mwm.X.z', 'xdm.X.z', 'xedit.X.z'
      k.instance_variable_set '@source', IO.readlines("| gzip_old -dc #{k.instance_variable_get '@source_dir'}/#{k.instance_variable_get '@input_filename'} | zcat")
      k.instance_variable_get('@source').define_singleton_method(:lines) { self }
      k.instance_variable_set '@magic', :Nroff
      require_relative '../../dom/nroff.rb'
      require_relative '../opendesktop.rb'
      k.extend ::Nroff
      k.extend ::OpenDesktop
      k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
      k.instance_variable_set '@related_info_heading', 'See Also'
    when 'assign.CMD.z', 'attrib.CMD.z', 'break.CMD.z', 'chdir.CMD', 'chkdsk.CMD.z',
         'cls.CMD', 'command.CMD.z', 'ctty.CMD.z', 'date.CMD.z', 'del.CMD.z'
      k.instance_variable_set '@output_directory', 'manDOS'
    when 'bdftosnf.X.z', 'ico.X.z', 'mkfontdir.X.z', 'oclock.X.z', 'showsnf.X.z',
         'xdpyinfo.X.z', 'xev.X.z', 'xeyes.X.z', 'xmodmap.X.z', 'xset.X.z', 'xwininfo.X.z'
    #  k.instance_variable_set '@title_detection', %r{^\s{4}(?<manentry>(?<cmd>\S+?)\s\((?<section>[A-Z]+)\))\s+}
      k.instance_variable_set '@related_info_heading', 'SEE ALSO'
    end
  end

end


