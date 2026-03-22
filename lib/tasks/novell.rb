collectionNamespace 'Novell' do
  collectionNamespace 'UnixWare' do
    manualNamespace '2.01',
      vendor_class: UnixWare,
      odir: 'Novell/UnixWare/2.01',
      sources: %w[usr/share/man/cat[1-8]]
  end
end
