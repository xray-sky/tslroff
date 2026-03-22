collectionNamespace 'Atari' do
  collectionNamespace 'SysV' do
    # TODO sort out differences & local changes. are these separate releases??
    manualNamespace '1.1-06',
      vendor_class: Atari_SysV,
      idir: 'atari/system_v/1.1-06',
      odir: 'Atari/SystemV/1.1-06',
      sources: %w[
          share/man/cat[1-8]
          share/man/man[13]
        ]
    manualNamespace 'ue12',
      vendor_class: Atari_SysV,
      idir: 'atari/system_v/ue12',
      odir: 'Atari/SystemV/ue12',
      sources: %w[share/man/cat[1-8]]
  end
end
