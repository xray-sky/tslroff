collectionNamespace 'BSDI' do
  collectionNamespace 'BSD386' do
    manualNamespace '1.0',
      odir: 'BSDI/BSD386/1.0',
      sources: %w[
        share/man/cat[1-8]
        contrib/man/cat[158]
        man/cat[135]
      ]  # TODO additional stuff in share/doc
  end
end
