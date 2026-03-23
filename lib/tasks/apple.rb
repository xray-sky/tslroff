collectionNamespace 'Apple' do
  collectionNamespace 'A/UX' do # A/UX
    manualNamespace '0.7',
      vendor_class: A_UX::V0_7,
      idir: 'apple/aux/0.7',
      odir: 'Apple/A-UX/0.7',
      sources: %w[catman/?_man/man[1-8]]
    manualNamespace '2.0',
      vendor_class: A_UX::V2_0,
      idir: 'apple/aux/2.0',
      odir: 'Apple/A-UX/2.0',
      sources: %w[catman/?_man/man[1-8]]
    manualNamespace '3.0.1',
      vendor_class: A_UX::V3_0_1,
      idir: 'apple/aux/3.0.1',
      odir: 'Apple/A-UX/3.0.1',
      sources: %w[catman/?_man/man[1-8]]
  end

  collectionNamespace 'Rhapsody' do
    # requires Groff support
    manualNamespace '5.0',
      idir: 'apple/rhapsody/dr1',
      odir: 'Apple/Rhapsody/5.0',
      sources: %w[man/man[1-8]]
    manualNamespace '5.1',
      idir: 'apple/rhapsody/dr2',
      odir: 'Apple/Rhapsody/5.1',
      sources: %w[usr/share/man/man[1-8l]]
    manualNamespace '5.3',
      # REVIEW are there more man pages (e.g. for sections 2 & 3) in the dev pkgs?
      idir: 'apple/rhapsody/5.3',
      odir: 'Apple/Rhapsody/5.3',
      sources: %w[man/man[145678n]]
    manualNamespace '5.5',
      idir: 'apple/rhapsody/5.5',
      odir: 'Apple/Rhapsody/5.5',
      sources: %w[man/man[145678n]]
  end
end
