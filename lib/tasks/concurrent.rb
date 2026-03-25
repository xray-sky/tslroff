collectionNamespace 'Concurrent' do
  collectionNamespace 'CX/UX' do
    manualNamespace '6.20',
      # there are more catman pages than man -
      # this processes all catman pages then
      # overwrites any present in man with
      # typesetter quality (this relies on rake
      # FileList sort order)
      vendor_class: CX_UX::V6_20,
      idir: 'concurrent/cx-ux/6.20',
      odir: 'Concurrent/CX:UX/6.20',
      sources: %w[
        usr/catman/?_man/man[1-8]
        usr/man/?_man/man[1-8]
      ]
  end
end
