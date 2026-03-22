collectionNamespace 'Concurrent' do
  collectionNamespace 'CX/UX' do
    manualNamespace '6.20',
      vendor_class: CX_UX::V6_20,
      odir: 'Concurrent/CX-UX/6.20',
      sources: %w[
        usr/catman/?_man/man[1-8]
        usr/man/?_man/man[1-8]
      ]
  end
end
