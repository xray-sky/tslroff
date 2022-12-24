# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.2.1R Platform Overrides
#
# TODO
#

module NEWS_os_4_2_1R_en_US

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'index.3', 'index.3f7768'
      k.instance_variable_set '@manual_entry', '_index'
    # TODO when we resolve the baseline/font issue with \u, \d, and \s
    # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
    # also there's the issue of doing rewrites in .so for gamma.3m
    #when 'lgamma.3m'
    #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
    when 'chgrp.1'
      # incorrectly recognized as nroff source as the first character is ' '
      k.instance_variable_get('@source').lines[0].sub!(/^ /, '')
      require_relative '../../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      # processing doesn't require .so, .AT, etc., so they don't need saving
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_TH, k.method(:TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :TH, k.method(:_TH)
    when 'prof.1'
      # incorrectly recognized as nroff source as the first character is 'p'
      k.instance_variable_get('@source').lines[0].sub!(/^p/, '.')
      require_relative '../../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      # processing doesn't require .so, .AT, etc., so they don't need saving
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_TH, k.method(:TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :TH, k.method(:_TH)
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => "NEWS-OS Programmer's Manual",
      ']W' => "7th Edition",
      :footer => "NEWS-OS\t\\s-2Release 4.2.1R\\s+2"
    })
  end

end

