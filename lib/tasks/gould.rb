collectionNamespace 'Gould' do
  collectionNamespace 'GDT-UNX' do
    manualNamespace '6.8_er0',
      # TODO man1/adb.1 vs. man1/adb.1.orig etc.
      #      divergences in cat[n] apart from n=9?
      vendor_class: GDT_UNX,
      odir: 'Gould/GDT-UNX/6.8_er0',
      sources: %w[
        man/cat9
        man/man[1-8l]
      ]
    manualNamespace '6.8_er0_nroff',
      # enabled to facilitate comparision of preprocessed vs. source manuals
      vendor_class: GDT_UNX,
      idir: 'gould/gdt-unx/6.8_er0',
      sources: %w[man/cat[1-9l]]
  end
end
