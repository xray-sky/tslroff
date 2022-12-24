# encoding: US-ASCII
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
#

module RISCiX_1_2

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'sticky.8'
      # misidentified as nroff
      k.instance_variable_get('@source').lines[0].insert(0, '.\\"')
      require_relative '../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_init_tr, k.method(:init_tr)
      k.define_singleton_method :_init_PD, k.method(:init_PD)
      k.define_singleton_method :_TH, k.method(:TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :init_tr, k.method(:_init_tr)
      k.define_singleton_method :init_PD, k.method(:_init_PD)
      k.define_singleton_method :TH, k.method(:_TH)
    end
  end

end
