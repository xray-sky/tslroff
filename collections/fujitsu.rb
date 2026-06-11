# frozen_string_literal: true
#
# Siemens-Nixdorf SINIX <= 5.43
# Fujitsu-Siemens Reliant UNIX >= 5.44
#

require_relative 'fujitsu/reliant_unix'

collection_namespace 'Fujitsu' do
  collection_namespace 'Reliant_UNIX' do
    manual_namespace '5.44c4/de',
      vendor_class: Reliant_UNIX,
      os: 'Reliant UNIX',
      ver: '5.44c4',
      idir: 'siemens/sinix/5.44c4',
      odir: 'Fujitsu/Reliant_UNIX/5.44c4/de_DE',
      sources: %w[
        *man*/reloc/?DMAN_D/BSX/bsd_compat/g[1-8]*
        *man*/reloc/?DMAN_D/*/g[1-8]*
        */r*/usr/share/man/mrd/De_DE.646/catman/*/g[1-8]*
        */r*/usr/share/man/mrd/De_DE.646/catman/SInus/SARM/g8
      ]

    manual_namespace '5.44c4/en',
      vendor_class: Reliant_UNIX,
      os: 'Reliant UNIX',
      ver: '5.44c4',
      idir: 'siemens/sinix/5.44c4',
      odir: 'Fujitsu/Reliant_UNIX/5.44c4/en_US',
      sources: %w[
        *man*/reloc/?DMAN_E/BSX/bsd_compat/g[1-8]*
        *man*/reloc/?DMAN_E/*/g[1-8]*
        */r*/usr/share/man/mrd/En_US.ASCII/catman/*/g[1-8]*
        */r*/usr/share/man/mrd/En_US.ASCII/catman/SInus/SARM/g8
      ]

  end
end
