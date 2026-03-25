collectionNamespace 'DG' do
  collectionNamespace 'DG/UX' do
    manualNamespace '4.30',
      vendor_class: DG_UX::V4_30,
      idir: 'dg/dgux/4.30',
      odir: 'DG/DG:UX/4.30',
      sources: %w[catman/?_man/man[0-8]]
    manualNamespace '4.31',
      vendor_class: DG_UX::V4_31,
      idir: 'dg/dgux/4.31',
      odir: 'DG/DG:UX/4.31',
      sources: %w[catman/?_man/man[0-8]]
    manualNamespace '5.4.2A',
      vendor_class: DG_UX,
      idir: 'dg/dgux/5.4.2A',
      odir: 'DG/DG:UX/5.4.2A',
      sources: %w[
        catman/?_man/man[0-8]
        catman/lg.1.z
      ]
    manualNamespace '5.4.2T',
      vendor_class: DG_UX,
      idir: 'dg/dgux/5.4.2T',
      odir: 'DG/DG:UX/5.4.2T',
      sources: %w[catman/?_man/man[1-8]]
    manualNamespace '5.4R2.01',
      vendor_class: DG_UX,
      idir: 'dg/dgux/5.4R2.01',
      odir: 'DG/DG:UX/5.4R2.01',
      sources: %w[
        catman/?_man/man[0-8]
        catman/man[358]
      ]
    manualNamespace '5.4R2.01p8',
      vendor_class: DG_UX,
      idir: 'dg/dgux/5.4R2.01p8',
      odir: 'DG/DG:UX/5.4R2.01p8',
      sources: %w[catman/?_man/man[147]]
    manualNamespace '5.4R3.00',
      vendor_class: DG_UX,
      idir: 'dg/dgux/5.4R3.00',
      odir: 'DG/DG:UX/5.4R3.00',
      sources: %w[
        catman/?_man/man[0-8]
        catman/man[1358]
      ]
    manualNamespace 'R4.11',
      vendor_class: DG_UX::R4_11,
      idir: 'dg/dgux/R4.11',
      odir: 'DG/DG:UX/R4.11',
      sources: %w[
        catman/?_man/man[0-8]
        catman/man[358]
        catman/sdk_man/man[1-6]
      ]
    manualNamespace 'R4.11MU05',
      vendor_class: DG_UX::R4_11,
      idir: 'dg/dgux/R4.11MU05',
      odir: 'DG/DG:UX/R4.11MU05',
      sources: %w[
        catman/?_man/man[0-8]
        catman/man[358]
        catman/sdk_man/man[1-6]
      ]
  end
end
