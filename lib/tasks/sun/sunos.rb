collectionNamespace 'SunOS' do
  manualNamespace '0.3',
    vendor_class: SunOS::V0_3,
    odir: 'Sun/SunOS/0.3',
    sources: %w[man/man[1-8]]
  manualNamespace '0.4',
    vendor_class: SunOS::V0_4,
    odir: 'Sun/SunOS/0.4',
    sources: %w[man/man[1-8]]

  manualNamespace '1.0',
    vendor_class: SunOS::V1_0,
    odir: 'Sun/SunOS/1.0',
    sources: %w[man/man[1-8]]
  manualNamespace '1.1',
    vendor_class: SunOS::V1_1,
    odir: 'Sun/SunOS/1.1',
    sources: %w[man/man[1-8]]
  manualNamespace '1.4U',
    vendor_class: SunOS::V1_4U,
    idir: 'sun/sunos/1.4U',
    odir: 'Sun/SunOS/1.4U',
    sources: %w[man/man[1-8]]

  manualNamespace '2.0',
    vendor_class: SunOS::V2_0,
    odir: 'Sun/SunOS/2.0',
    sources: %w[man/man[1-8]]
  manualNamespace '2.2U',
    vendor_class: SunOS::V2_2U,
    idir: 'sun/sunos/2.2-update',
    odir: 'Sun/SunOS/2.2U',
    sources: %w[usr/man/man[1-8]]
  manualNamespace '2.3U',
    vendor_class: SunOS::V2_3U,
    idir: 'sun/sunos/2.3-update',
    odir: 'Sun/SunOS/2.3U',
    sources: %w[usr/man/man[1-8]]

  manualNamespace '3.0',
    vendor_class: SunOS::V3_0,
    odir: 'Sun/SunOS/3.0',
    sources: %w[man/man[1-8]]
  manualNamespace '3.2/68010',
    vendor_class: SunOS::V3_2,
    idir: 'sun/sunos/3.2',
    odir: 'Sun/SunOS/3.2/sun2',
    sources: %w[68010/man/man[1-8]]
  manualNamespace '3.2/68020',
    vendor_class: SunOS::V3_2,
    idir: 'sun/sunos/3.2',
    odir: 'Sun/SunOS/3.2/sun3',
    sources: %w[68020*/man/man[1-8]]
  manualNamespace '3.2/SYS4',
    vendor_class: SunOS::V3_2,
    idir: 'sun/sunos/3.2',
    odir: 'Sun/SunOS/3.2/sun4',
    sources: %w[SYS4-3.2/man/man[1-8]]
  manualNamespace '3.4',
    vendor_class: SunOS::V3_4,
    odir: 'Sun/SunOS/3.4',
    sources: %w[man/man[1-8]]
  manualNamespace '3.5',
    vendor_class: SunOS::V3_5,
    odir: 'Sun/SunOS/3.5',
    sources: %w[man/man[1-8]]

  manualNamespace '4.0',
    vendor_class: SunOS::V4_0,
    odir: 'Sun/SunOS/4.0',
    sources: %w[share/man/man[1-8]]
  manualNamespace '4.0.2',
    vendor_class: SunOS::V4_0,  # literally identical
    odir: 'Sun/SunOS/4.0.2',
    sources: %w[share/man/man[1-8]]
  manualNamespace '4.0.3/sun3',
    vendor_class: SunOS::V4_0,  # literally identical
    idir: 'sun/sunos/4.0.3',
    odir: 'Sun/SunOS/4.0.3/sun3',
    sources: %w[68020/share/man/man[1-8]]
  # 35 more pages than sun3? REVIEW other differences?
  manualNamespace '4.0.3/sun4',
    vendor_class: SunOS::V4_0,  # literally identical
    idir: 'sun/sunos/4.0.3',
    odir: 'Sun/SunOS/4.0.3/sun4',
    sources: %w[sun4/share/man/man[1-8]]
  manualNamespace '4.1.1',
    vendor_class: SunOS::V4_1_1,
    idir: 'Sun/SunOS/4.1.1',
    sources: %w[
      share/man/man[1-8]
      openwin/share/man/man[136n]
    ]
  manualNamespace '4.1.2',
    vendor_class: SunOS::V4_1_2,
    odir: 'Sun/SunOS/4.1.2',
    sources: %w[
      share/man/man[1-8]
      openwin/share/man/man[136n]
    ]
  # 4.1.3 (Solaris 1.1 SunSoft Version B, 704-3545-10) - all other 4.1.3mumble Domestic manuals are identical to 4.1.3_U1
  # TODO reveal the secret of how it's different
  manualNamespace '4.1.3B',
    vendor_class: SunOS::V4_1_3,
    idir: 'sun/sunos/4.1.3_sunsoft_revB',
    odir: 'Sun/SunOS/4.1.3B',
    sources: %w[
      share/man/man[1-8]
      openwin/share/man/man[1-8]
    ]
  # All identical: 4.1.3 SunSoft Ver A, 4.1.3 SunSoft Ver C, 4.1.3_U1, and 4.1.3_U1 SunSoft Ver B (704-3662)
  # TODO 4.1.3_U1 SunSoft Ver B (704-4037) has International/EUC amendments - not identical, though also en_US
  manualNamespace '4.1.3_U1',
    vendor_class: SunOS::V4_1_3,
    idir: 'sun/sunos/4.1.3u1',
    odir: 'Sun/SunOS/4.1.3_U1',
    sources: %w[
      share/man/man[1-8]
      openwin/share/man/man[1-8]
    ]
  manualNamespace '4.1.4',
    vendor_class: SunOS::V4_1_4,
    odir: 'Sun/SunOS/4.1.4',
    sources: %w[
      share/man/man[1-8]
      openwin/share/man/man[1-8]
    ]

  # TODO reveal the secrets of how SPARC and x86 are different, if beyond drivers in man7
  #      I guess that's just an intellectual exercise as they can't be merged
  #        - e.g. substantial differences in matherr(3m)
  manualNamespace '5.1/SPARC',
    vendor_class: SunOS::V5_1,
    idir: 'sun/sunos/5.1',
    odir: 'Sun/SunOS/5.1/SPARC',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-8]
      usr/demo/SOUND/man/man3
    ]
  manualNamespace '5.1/x86',
    vendor_class: SunOS::V5_1,
    idir: 'sun/sunos/5.1_x86',
    odir: 'Sun/SunOS/5.1/x86',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-8]
      usr/demo/SOUND/man/man3
    ]
  manualNamespace '5.2',
    vendor_class: SunOS::V5_2,
    odir: 'Sun/SunOS/5.2',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-8]*
      usr/demo/SOUND/man/man3
    ]
  manualNamespace '5.3',
    vendor_class: SunOS::V5_3,
    odir: 'Sun/SunOS/5.3',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-8]*
      usr/demo/SOUND/man/man3
      SUNWits/Graphics-sw/xil/man/man3
    ]
  # TODO hw395_upd
  manualNamespace '5.4', # HW 3/95
    vendor_class: SunOS::V5_4,
    idir: 'sun/sunos/5.4_hw395',
    odir: 'Sun/SunOS/5.4',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-8]*
      dt/man/man1
      usr/demo/SOUND/man/man3
      SUNWits/Graphics-sw/xil/man/man[13]
      SUNWrtvc/man/man1
    ]
  # TODO 5.5_upd
  manualNamespace '5.5/SPARC',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/5.5',
    odir: 'Sun/SunOS/5.5/SPARC',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-7]*
      usr/openwin/share/man/man[16]
      usr/demo/SOUND/man/man3
      SUNWits/Graphics-sw/xil/man/man[13]
    ]
  # TODO it is different from SPARC, but how? doesn't have XIL package... doesn't look like that is the only diff?
  manualNamespace '5.5/x86',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/5.5_x86',
    odir: 'Sun/SunOS/5.5/x86',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-7]*
      usr/openwin/share/man/man[16]
      usr/demo/SOUND/man/man3
    ]
  # TODO re-extract from media
  manualNamespace '5.5.1',
    vendor_class: SunOS::V5_5_1,
    odir: 'Sun/SunOS/5.5.1',
    sources: %w[share/man/man[1-9]*]
  manualNamespace '5.6', #
    # TODO compare x86
    vendor_class: SunOS::V5_6,
    idir: 'sun/sunos/5.6_hw598',
    odir: 'Sun/SunOS/5.6',
    sources: %w[
      share/man/man[1-9]*
      openwin/share/man/man[1-7]*
      usr/openwin/share/man/man[167]
      usr/demo/SOUND/man/man3
      SUNWrtvc/man/man[13]
    ]
  # this manual does weird absolute positioning instead of .IP/.TP
  manualNamespace '5.10',
    vendor_class: SunOS::V5_10,
    idir: 'sun/sunos/5.10',
    #odir: 'Sun/SunOS/5.10'
    sources: %w[
      share/man/man[1-9]*
      share/man/sman[1-9]*/*.[1-9]*
    ]
end
