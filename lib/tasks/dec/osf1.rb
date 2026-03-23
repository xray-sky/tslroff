collectionNamespace 'OSF1' do
  # DEC OSF/1 SILVER Baselevel 4 (Rev. 36) for MIPS from tenox - prerelease for mips TODO tmac.an
  manualNamespace 'SILVER_Baselevel_4_rev36',
    vendor_class: OSF1,
    idir: 'dec/osf1/silver4_r36_mips',
    odir: 'DEC/OSF1/SILVER_Baselevel_4_rev36',
    sources: %w[usr/share/man/man[1-8]]
  # DEC OSF/1 V1.0 (TIN) for MIPS from tenox - TODO tmac.an
  manualNamespace '1.0/mips',
    vendor_class: OSF1,
    idir: 'dec/osf1/1.0_tin_mips',
    odir: 'DEC/OSF1/1.0/mips',
    sources: %w[usr/share/man/man[1-8]]
  # DEC OSF/1 X2.0-8 (Rev. 155) for MIPS from tenox - TODO tmac.an
  manualNamespace 'X2.0-8/mips',
    vendor_class: OSF1,
    idir: 'dec/osf1/2.0-8_mips',
    odir: 'DEC/OSF1/X2.0-8/mips',
    sources: %w[usr/share/man/man[1-8]]
  manualNamespace '3.0',
    vendor_class: OSF1::V3_2c,  # identical apart from (c) date
    odir: 'DEC/OSF1/3.0',
    sources: %w[share/man/man[1-8]]
end

collectionNamespace 'Digital_UNIX' do
  manualNamespace '3.2c',
    vendor_class: OSF1::V3_2c,
    idir: 'dec/du/3.2c',
    odir: 'DEC/Digital_UNIX/3.2c',
    sources: %w[
      usr/share/man/man[1-8]
      usr/dt/share/man/man[1-6]
      usr/opt/XR6320/X11R6/man/man[3n]
    ]
  manualNamespace '4.0d',
    vendor_class: Digital_UNIX::V4_0d,
    idir: 'dec/du/4.0d',
    odir: 'DEC/Digital_UNIX/4.0d',
    sources: %w[
      usr/share/man/man[1-8]
      usr/dt/share/man/man[1-5]*
    ]
end

collectionNamespace 'Tru64' do
  manualNamespace '4.0f',
    vendor_class: Tru64,
    odir: 'DEC/Tru64/4.0f',
    sources: %w[
      usr/share/man/man[1-8]
      usr/dt/share/man/man[1-5]*
    ]
  manualNamespace '5.0a',
    vendor_class: Tru64,
    odir: 'DEC/Tru64/5.0a',
    sources: %w[
      usr/share/man/man[1-9]
      usr/dt/share/man/man[1-6]*
    ]
  manualNamespace '5.1b',
    vendor_class: Tru64,
    odir: 'DEC/Tru64/5.1b',
    sources: %w[
      usr/share/man/man[1-9]
      usr/dt/share/man/man[1-5]
    ]
end
