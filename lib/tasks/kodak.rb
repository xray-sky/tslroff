collectionNamespace 'Kodak' do
  collectionNamespace 'Interactive' do
    manualNamespace '2.2',
      vendor_class: Interactive::V2_2,
      odir: 'Kodak/Interactive/2.2',
      sources: %w[
        progman/new/usr/catman/p_man/man[1-5]
        userman/new/usr/catman/u_man/man[178]
      ]
  end
end
