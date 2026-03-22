collectionNamespace 'GL1' do
  manualNamespace 'W2.1',
    vendor_class: GL2::W2_1,
    odir: 'SGI/GL1/W2.1',
    sources: %w[
      man/?_man/man[1-8]
    ]
  manualNamespace 'W2.3',
    vendor_class: GL2::W2_3,
    odir: 'SGI/GL1/W2.3',
    sources: %w[
      man/?_man/man[1-8]
      options/usr/man/?_man/man[1-8]
    ]
end

collectionNamespace 'GL2' do
  manualNamespace 'W2.3',
    vendor_class: GL2::W2_3,
    odir: 'SGI/GL2/W2.3',
    sources: %w[
      usr/man/?_man/man[1-8]
    ]
  manualNamespace 'W2.4',
    # REVIEW incomplete? (probably not. 1099 entries vs. 1067 for W2.3
    # TODO vendor class
    vendor_class: GL2::W2_4,
    idir: 'sgi/gl2/w2.4_fe_upd',
    odir: 'SGI/GL2/W2.4',
    sources: %w[
      usr/man/?_man/man[1-8]
    ]
  manualNamespace 'W2.5',
    # TODO these are installed dates, not release dates. they came from the SAQ IRIS.
    vendor_class: GL2::W2_5,
    odir: 'SGI/GL2/W2.5',
    sources: %w[
      man/?_man/man[1-8]
    ]
  manualNamespace 'W2.5r1',
    # REVIEW incomplete? options (missing fortran), update only (1183 entries though)
    vendor_class: GL2::W2_5r1,
    odir: 'SGI/GL2/W2.5r1',
    sources: %w[
      update_only/usr/man/?_man/man[1-8]
      options/usr/man/?_man/man[1-8]
    ]
  manualNamespace 'W3.3.1',
    # REVIEW provenance?
    # TODO vendor class
    vendor_class: GL2::W3_3_1,
    odir: 'SGI/GL2/W3.3.1',
    sources: %w[
      usr/man/?_man/man[1-8]
    ]
  manualNamespace 'W3.5r1',
    # TODO these are installed dates, not release dates. they came from the SAQ IRIS.
    vendor_class: GL2::W3_5r1,
    odir: 'SGI/GL2/W3.5r1',
    sources: %w[
      man/?_man/man[1-8]
    ]
  manualNamespace 'W3.6',
    vendor_class: GL2::W3_6,
    odir: 'SGI/GL2/W3.6',
    sources: %w[
      usr/man/?_man/man[1-8]
      options/usr/man/?_man/man[1-8]
    ]
end
