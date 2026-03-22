collectionNamespace 'Acorn' do
  collectionNamespace 'RISCiX' do
    manualNamespace '1.2',
      # REVIEW were the math functions moved to man0 to 'disable' them?
      # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
      vendor_class: RISCiX::V1_2,
      odir: 'Acorn/RISCiX/1.2',
      sources: %w[
        share/man/man0/*.3m
        share/man/man[1-8]
      ]
  end
end
