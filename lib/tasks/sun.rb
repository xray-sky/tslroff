collectionNamespace 'Sun' do
  collectionNamespace 'Interactive' do
    manualNamespace '3.2r4.1',
      idir: 'sun/interactive/3.2r4.1',
      sources: %w[
          man/mann
          man/u_man/man[1-8]
        ]
  end

  require_relative 'sun/sunos'
  require_relative 'sun/thirdparty'
  require_relative 'sun/unbundled'

end
