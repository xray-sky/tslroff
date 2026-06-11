# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
#

module VMS
  class Source < Source

    def initialize(file, **kwargs, &block)
      case File.basename file
      when /\.[ht]lb$/ then raise ManualIsBlacklisted, 'is packed library'
      #when /\.txt$/, /\.release_notes$/ then raise ManualIsBlacklisted, 'unpacked text library (TODO)'
      #when 'dbg$dwhelp.hlp', 'ddif$view.hlp', /^decw\$/, 'macro$dwci.hlp',
      #     'cms$dw_help.hlp', 'fortran$dwci.hlp', 'lisp$decwindows.hlp', 'pascal$dwci.hlp',
      #     'keyutil.hlp' #LogiCraft 386ware
      #  raise ManualIsBlacklisted, 'TODO DDIF? (=include, =Title)'
      when 'config.hlp', 'menu.hlp', # LogiCraft 386ware
           'keypad.hlp', 'pcxtkeys.hlp', 'queues.hlp', 'secaudit.hlp' # Sybase Data Workbench
        raise ManualIsBlacklisted, 'not VMS HELP Library format'
      end if file

      kwargs[:encoding] = Encoding::ISO_8859_1

      # TODO one size does not fit all - this fixes e.g. CMS_2.2 but breaks UCX_1.3 rpc notes (which is not plain text though!)
      # block passing also causes UCX_1.3 to loop, not really sure why
      #super(file, **kwargs) { |f| File.read(f, external_encoding: kwargs[:encoding], internal_encoding: Encoding::UTF_8).gsub("\r\n", "\r").split("\n").collect { |l| "#{l}\n" } }
      super(file, **kwargs, &block)
    end

  end
end

