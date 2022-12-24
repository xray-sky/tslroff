# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunSoft Interactive UNIX v3.2r4.1 Platform Overrides
#
# TODO
#

module Interactive_3_2r4_1

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'file'
      raise ManualIsBlacklisted, 'is shell script'
    when /intro\.nfs\.(\d)/ # easier to just override these than mess with the regex
      k.instance_variable_set '@manual_entry', 'intro.nfs'
      k.instance_variable_set '@manual_section', Regexp.last_match[1]
    when 'i596.7'
      # misidentified as nroff
      k.instance_variable_get('@source').lines[0].insert(0, '.\\"')
      require_relative '../../dom/troff.rb'
      # save a ref to our :init_ds and :TH methods, before they get smashed by the extend
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_init_nr, k.method(:init_nr)
      k.define_singleton_method :_init_ta, k.method(:init_ta)
      k.define_singleton_method :_init_TH, k.method(:init_TH)
      k.define_singleton_method :_TH, k.method(:TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :init_nr, k.method(:_init_nr)
      k.define_singleton_method :init_ta, k.method(:_init_ta)
      k.define_singleton_method :init_TH, k.method(:_init_TH)
      k.define_singleton_method :TH, k.method(:_TH)
    end
  end

end
