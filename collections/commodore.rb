# frozen_string_literal: true
#

require_relative 'commodore/amix'

collection_namespace 'Commodore' do
  collection_namespace 'AMIX' do
    osname = 'Amiga System V Release 4'
    manual_namespace '1.1',
      vendor_class: AMIX,
      os: osname,
      ver: 'Version 1.1',
      odir: 'Commodore/AMIX/1.1',
      sources: %w[share/catman/g[1-8]?]

    manual_namespace '2.0',
      vendor_class: AMIX,
      os: osname,
      ver: 'Version 2.0',
      odir: 'Commodore/AMIX/2.0',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]

    manual_namespace '2.01',
      vendor_class: AMIX,
      os: osname,
      ver: 'Version 2.01',
      odir: 'Commodore/AMIX/2.01',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]

    manual_namespace '2.03',
      vendor_class: AMIX,
      os: osname,
      ver: 'Version 2.03',
      odir: 'Commodore/AMIX/2.03',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]
    manual_namespace '2.1',
      vendor_class: AMIX,
      os: osname,
      ver: 'Version 2.1',
      odir: 'Commodore/AMIX/2.1',
      idir: 'commodore/amix/2.10',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]
  end
end
