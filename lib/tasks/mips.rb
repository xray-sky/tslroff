collectionNamespace 'mips' do
  collectionNamespace 'unbundled' do
    manualNamespace 'RISCwindows_4.00',
      vendor_class: RISC_os,
      idir: 'mips/risc-os/unbundled/riscwindows/4.00',
      odir: 'mips/unbundled/RISCwindows_4.00',
      sources: %w[usr/RISCwindows4.0/man/cat/man[13]]
  end

  collectionNamespace 'RISC/os' do
    manualNamespace '4.52',
      vendor_class: RISC_os::V4_52,
      odir: 'mips/RISC-os/4.52',
      sources: %w[man/catman/?_man/*man[1-8]]
    manualNamespace '5.01',
      vendor_class: RISC_os::V5_01,
      odir: 'mips/RISC-os/5.01',
      sources: %w[share/man/catman/?_man/*man[1-8]]
  end
end
