collectionNamespace 'Commodore' do
  collectionNamespace 'AMIX' do
    manualNamespace '1.1',
      vendor_class: AMIX,
      odir: 'Commodore/AMIX/1.1',
      sources: %w[share/catman/g[1-8]?]

    manualNamespace '2.0',
      vendor_class: AMIX,
      odir: 'Commodore/AMIX/2.00',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]

    manualNamespace '2.01',
      vendor_class: AMIX,
      odir: 'Commodore/AMIX/2.01',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]

    manualNamespace '2.03',
      vendor_class: AMIX,
      odir: 'Commodore/AMIX/2.03',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]
    manualNamespace '2.1',
      vendor_class: AMIX,
      odir: 'Commodore/AMIX/2.1',
      idir: 'commodore/amix/2.10',
      sources: %w[
        usr/share/catman/[1-8]?
        usr/share/man/[1-8]?
      ]
  end
end
