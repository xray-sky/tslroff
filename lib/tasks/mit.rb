collectionNamespace 'MIT' do
  collectionNamespace 'X10' do
    manualNamespace 'R4',
      idir: 'mit/x10/r4',
      #odir: 'MIT/X10R4',
      sources: %w[doc/mann]
  end

  collectionNamespace 'X11' do
    manualNamespace 'R4',
      idir: 'mit/x11/r4',
      #odir: 'MIT/X11R4',
      sources: %w[man/man[3n]]
  end
end
