# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os 5.01 Platform Overrides
#
# needs case sensitive (not just case preserving) filesystem for output - symlink ELOOP without
#   Mail.bsd.html -> mail.bsd.html
#   TSET.html -> tset.html
#
# TODO:
#

module RISC_os_5_01

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when /prom.1m$/ # these are symlinks to the 1prom entries
      k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.prom.1m$/, '')
      k.define_singleton_method :retarget_symlink, k.method(:retarget_symlink_prom)
    when /1prom$/
      k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.1prom$/, '')
    when 'newsetup.1', 'newsgroups.1', 'patch.1', 'Pnews.1', 'Rnmail.1'
      # have section as 'entry(1 LOCAL)'
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:\s(?<systype>\S+?))?\))}
    when 'tty.4' # there are two
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>4(?:spp)?)(?:-(?<systype>\S+?)|" " " ")?\))\s.+?\s\k<manentry>$}
    when 'proto.1'
      raise ManualIsBlacklisted, 'prototype entry (not real)'
    end
  end

  def page_title
    super.sub(/\S+$/, 'UMIPS RISC/os 5.01')
  end

  # writes link into new directory; otherwise, same as Manual::retarget_symlink
  def retarget_symlink_prom
    link_dir = Pathname.new @source_dir
    target_dir = Pathname.new File.dirname(@symlink)
    real_target = File.realpath("#{@source_dir}/#{@input_filename}")

    if (link_dir + target_dir) == link_dir and File.file?(real_target)
      target_entry = Manual.new(real_target, @platform, @version)
      return { link: "../man1m/#{@manual_entry}.html",
               target: "../man1prom/#{target_entry.manual_entry}.html" }
    end
    warn "encountered unsupported link type, #{@source_dir}/#{@input_filename} => #{@symlink}"
  end

end
