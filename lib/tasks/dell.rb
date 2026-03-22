collectionNamespace 'Dell' do
  collectionNamespace 'SVR4' do
    manualNamespace 'Issue2.2',
      idir: 'dell/svr4_iss2.2',
      odir: 'Dell/SVR4/Issue2.2',
      sources: %w[
          usr/share/man/cat[1-8]
          usr/share/manx/cat[1-8]
        ]
  end
end
