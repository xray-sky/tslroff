collectionNamespace 'Motorola' do
  collectionNamespace 'SystemV' do
    manualNamespace 'MC88000/FH40.42',
      vendor_class: Motorola_SysV,
      idir: 'motorola/sysv-88k/R4/FH40.42',
      odir: 'Motorola/SystemV/mc88000/R4/FH40.42',
      sources: %w[usr/src/man/man[1-7]]
    manualNamespace 'MC88000/FH40.43',
      vendor_class: Motorola_SysV,
      idir: 'motorola/sysv-88k/R4/FH40.43',
      odir: 'Motorola/SystemV/mc88000/R4/FH40.43',
      sources: %w[
        usr/src/man/man[1-7]
        usr/src/ddi_man/man[1-5]
      ]
  end
end
