# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#

module Aegis
  module Utils

    def retarget_symlink
      #link_dir = Pathname.new @source.dir
      #target_dir = Pathname.new File.dirname(@symlink)
      #real_target = File.realpath("#{@source.dir}/#{@input_filename}")

      case @symlink
      # mann/, mana/, ../usr/softbench/man/, ../usr/X11/man/
      # disregard links to these directories, if we end up getting them as args
      # they'll be handled separately
      when %r{man[an]$}, %r{usr/(?:softbench|X11)/man}
        return nil
      # sys/help/syscalls/ => ./calls/ -- TODO: sys/help/syscalls got expanded as a directory, rather than detected as a symlink
      when 'calls', './calls'
        return { link: 'syscalls', target: @symlink }
      # sys/help/calls/* => usr/apollo/mana/*
      # also cover broken link oddity, sys/help/calls/gpr_$inq_cp.hlp -> ../../../usr/apollo/mana/gpr_inq_cp.a
      when %r{usr/apollo(?:/man)?/mana/([_a-z0-9]+)\.a$}
        return { link: @manual_entry, target: "../../mana/#{Regexp.last_match[1]}.html" }
      # oddity - sys/help/protection/protected_subsystems.hlp -> /protected_subs.hlp
      when '/protected_subs.hlp' # TODO: this didn't happen?
        # protected_subsystems.hlp: No such file or directory @ rb_sysopen - sys/help/protection/protected_subsystems.hlp
        # so... I'm doing something to make it fail, before we get here? yes: Source.new(file) follows the link, and that's where the exception happens.
        # TODO: need to rewrite prior to source_init, apparently.
        return { link: 'protected_subsystems.html', target: 'protected_subs.html' }
      # TODO: (?)
      # oddity - sys/help/calls/gpr_$inq_cp.hlp -> ../../../usr/apollo/mana/gpr_inq_cp.a
      #          (is usr/apollo/man/mana/gpr...) --- need to rewrite prior to source_init.
      # oddity - sys5.3/usr/catman/u_man/man5/xterm.5 -> ../../../../../usr/X11/man/cat7/xterm.7
      #   $ find . -name 'xterm.*' -ls
      #   4447743      152 -r--r--r--    1 bear             staff               77690 Nov 20  1993 ./usr/X11/man/cat1/xterm.1
      #   4447753       32 -r--r--r--    1 bear             staff               15911 Nov 20  1993 ./usr/X11/man/cat7/xterm.7
      #   4446433        8 lrwxr-xr-x    1 bear             staff                  39 May 30  1991 ./sys5/usr/catman/u_man/man5/xterm.5 -> ../../../../../usr/X11/man/cat7/xterm.7
      #   4446424        8 lrwxr-xr-x    1 bear             staff                  41 May 23  1992 ./sys5/usr/catman/u_man/man1/xterm.1 -> ./../../../../../usr/X11/man/cat1/xterm.1
      #   4443288        8 lrwxr-xr-x    1 bear             staff                  38 May 23  1992 ./bsd4.3/usr/man/cat1/xterm.1 -> ./../../../../usr/X11/man/cat1/xterm.1
      #   4444557        8 lrwxr-xr-x    1 bear             staff                  38 May 30  1991 ./bsd4.3/usr/man/cat7/xterm.7 -> ./../../../../usr/X11/man/cat7/xterm.7
      end
      super
    end

  end
end
