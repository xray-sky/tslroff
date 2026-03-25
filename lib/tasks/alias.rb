collectionNamespace 'Alias' do
  collectionNamespace '1' do
    manualNamespace 'v2.1',
      # REVIEW were the math functions moved to man0 to 'disable' them?
      # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
      vendor_class: GL2::W3_6,
      idir: 'alias/1/2.1',
      odir: 'Alias/Alias:1/v2.1',
      sources: %w[ iris ]
  end
end
