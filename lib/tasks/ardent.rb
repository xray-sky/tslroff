collectionNamespace 'Ardent' do
  collectionNamespace 'SysV' do
    manualNamespace 'R3.0',
      vendor_class: Ardent_SysV::R3_0,
      idir: 'ardent/sysv/3.0',
      odir: 'Ardent/SystemV/R3.0',
      sources: %w[
          man/man[1-8]
          man/bsd/man[1-3]
        ]
    manualNamespace 'R4.1',
      vendor_class: Ardent_SysV::R4_1,
      idir: 'ardent/sysv/4.1',
      odir: 'Ardent/SystemV/R4.1',
      sources: %w[
          man[1-8]
          bsd/man[1-3]
        ]
    manualNamespace 'R4.2',
      vendor_class: Ardent_SysV::R4_2,
      idir: 'ardent/sysv/4.2',
      odir: 'Ardent/SystemV/R4.2',
      sources: %w[
          man[1-8]
          bsd/man[1-3]
        ]
  end
end
