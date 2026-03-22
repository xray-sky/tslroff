collectionNamespace 'unbundled' do
  manualNamespace 'ATM_2.0',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/atm_2.0',
    odir: 'Sun/unbundled/ATM_2.0',
    sources: %w[SUNWatm/man/man[13479]*]
  manualNamespace 'C_1.0',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/c_1.0',
    odir: 'Sun/unbundled/C_1.0',
    sources: %w[man/man[1358]]
  manualNamespace 'C++_2.0',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/c++_2.0',
    odir: 'Sun/unbundled/C++_2.0',
    sources: %w[CC/man/man[13]]
  # same as CDE 1.0.2 on Desktop 1.1
  manualNamespace 'CDE_1.0.1',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/cde_1.0',
    odir: 'Sun/unbundled/CDE_1.0.1',
    sources: %w[dt/share/man/man[1-6]*]
  manualNamespace 'DiskSuite_4.0',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/disksuite_4.0',
    odir: 'Sun/unbundled/DiskSuite_4.0',
    sources: %w[usr/opt/SUNWmd/man/man[147]*]
  manualNamespace 'DOS_Windows_1.0',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/dos_windows_1.0',
    odir: 'Sun/unbundled/DOS_Windows_1.0',
    sources: %w[man]
  manualNamespace 'FORTRAN_1.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/fortran_1.1',
    odir: 'Sun/unbundled/FORTRAN_1.1',
    sources: %w[share/man/man[13]]
  manualNamespace 'FORTRAN_1.2',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/fortran_1.2',
    odir: 'Sun/unbundled/FORTRAN_1.2',
    sources: %w[share/man/man[13]]
  manualNamespace 'FORTRAN_1.3.1',
    vendor_class: SunOS::V4_1,
    idir: 'sun/sunos/unbundled/fortran_1.3.1',
    odir: 'Sun/unbundled/FORTRAN_1.3.1',
    sources: %w[man/man[1358]]
  manualNamespace 'FORTRAN_1.4',
    vendor_class: SunOS::V4_1,
    idir: 'sun/sunos/unbundled/fortran_1.4',
    odir: 'Sun/unbundled/FORTRAN_1.4',
    sources: %w[man/man[135]]
  manualNamespace 'Motif_SDK_1.2.2',
    vendor_class: SunOS::V5_2,
    idir: 'sun/sunos/unbundled/motif_1.2.2_sdk',
    odir: 'Sun/unbundled/Motif_SDK_1.2.2',
    sources: %w[SUNWmfdoc/man/man[135]]
  # TODO local string.defs, header.mex
  manualNamespace 'NeWS_1.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/news_1.1',
    odir: 'Sun/unbundled/NeWS_1.1',
    sources: %w[man/man[136]]
  manualNamespace 'ODBC_2.11',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/odbc_2.11',
    odir: 'Sun/unbundled/ODBC_2.11',
    sources: %w[man/man4]
  manualNamespace 'OpenWindows_1.0_PreFCS',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/openwindows_1.0_pre_fcs',
    odir: 'Sun/unbundled/OpenWindows_1.0_PreFCS',
    sources: %w[man/man[136n]]
  manualNamespace 'OpenWindows_1.1_Developer_Guide',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/openwindows_1.1_dev_guide',
    odir: 'Sun/unbundled/OpenWindows_1.1_Developer_Guide',
    sources: %w[man/man1]
  manualNamespace 'OpenWindows_V2',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/openwindows_v2',
    odir: 'Sun/unbundled/OpenWindows_V2',
    sources: %w[man/man[136n]]
  manualNamespace 'Pascal_1.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/pascal_1.1',
    odir: 'Sun/unbundled/Pascal_1.1',
    sources: %w[man/man1]
  manualNamespace 'Pascal_2.0',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/pascal_2.0',
    odir: 'Sun/unbundled/Pascal_2.0',
    sources: %w[man/man1]
  manualNamespace 'Pascal_2.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/pascal_2.1',
    odir: 'Sun/unbundled/Pascal_2.1',
    sources: %w[man/man[15]]
  # TODO local tmac.an with .ds j (\nj=1 ? CADAM : NO_CADAM) for CADAM specific text
  # escape.3 refs conditional; escape_-3.3 and escape_-13.3 are entirely conditional on it
  # section 3P+ for PHIGS+
  manualNamespace 'PHIGS_1.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/phigs_1.1',
    odir: 'Sun/unbundled/PHIGS_1.1',
    sources: %w[man/phigs1.1/man[37]]
  # V3N1 x86
  manualNamespace 'ProWorks_3.0.1',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/proworks_3.0.1',
    odir: 'Sun/unbundled/ProWorks_3.0.1',
    sources: %w[
      SUNWspro/*/man/man[1345]*
      SUNWspro/FSF/sbtags/man/man1
      SUNWste/license_tools/man/man1
    ]
  manualNamespace 'SBus_Printer_Card_1.0',
    vendor_class: SunOS::V4_1,
    idir: 'sun/sunos/unbundled/sbus_printer_card_1.0',
    odir: 'Sun/unbundled/SBus_Printer_Card_1.0',
    sources: %w[man]
  manualNamespace 'Solaris_2.4_x86_SDK',
    vendor_class: SunOS::V5_4,
    idir: 'sun/sunos/unbundled/solaris_2.4_x86_sdk',
    odir: 'Sun/unbundled/Solaris_2.4_x86_SDK',
    sources: %w[
      dt/man/man[135]
      SUNWgmfu/share/man/man1
      SUNWguide/demo/gnt/man/man1
      SUNWguide/share/man/man1
      SUNWits/Graphics-sw/x?l/man/man3
      SUNWmfwm/man/man1
    ]
  manualNamespace 'Solstice_Backup_4.1.2/Solaris',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
    odir: 'Sun/unbundled/Solstice_Backup_4.1.2/Solaris',
    sources: %w[share/man/man[358]]
  # REVIEW different from Solaris manual?
  manualNamespace 'Solstice_Backup_4.1.2/SunOS',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
    odir: 'Sun/unbundled/Solstice_Backup_4.1.2/SunOS',
    sources: %w[SunOS/man]
  # V5N1 SPARC Solaris 2.x # TODO Solaris 1.x
  manualNamespace 'WorkShop_3.0.1',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/workshop_3.0',
    odir: 'Sun/unbundled/WorkShop_3.0.1',
    sources: %w[
      SUNWspro/*/man/man[134]*
      SUNWspro/contrib/*/man/man1
      SUNWste/license_tools/man/man1
    ]
  # V6N1 SPARC
  manualNamespace 'WorkShop_5.0',
    vendor_class: SunOS::V5_6,
    idir: 'sun/sunos/unbundled/workshop_5.0',
    odir: 'Sun/unbundled/WorkShop_5.0',
    sources: %w[
      SUNW*/*/man/man[134]*
      SUNWspro/contrib/XEmacs20.4/man/man1
      SUNWste/license_tools/man/man1
    ]
  manualNamespace 'TOPS_2.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/tops_2.1',
    odir: 'Sun/unbundled/TOPS_2.1',
    sources: %w[.]
  manualNamespace 'TranSCRIPT_2.1',
    vendor_class: SunOS::V4_0,
    idir: 'sun/sunos/unbundled/transcript_2.1',
    odir: 'Sun/unbundled/TranSCRIPT_2.1',
    sources: %w[man]
  manualNamespace 'TranSCRIPT_2.1.1',
    vendor_class: SunOS::V4_1,
    idir: 'sun/sunos/unbundled/transcript_2.1.1',
    odir: 'Sun/unbundled/TranSCRIPT_2.1.1',
    sources: %w[man]
  manualNamespace 'WABI_2.0',
    vendor_class: SunOS::V5_4,
    idir: 'sun/sunos/unbundled/wabi_2.0',
    odir: 'Sun/unbundled/WABI_2.0',
    sources: %w[SUNWwabi/man/man1]
  manualNamespace 'WABI_2.1',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/wabi_2.1',
    odir: 'Sun/unbundled/WABI_2.1',
    sources: %w[SUNWwabi/man/man1]
  manualNamespace 'WABI_2.2',
    vendor_class: SunOS::V5_5,
    idir: 'sun/sunos/unbundled/wabi_2.2',
    odir: 'Sun/unbundled/WABI_2.2',
    sources: %w[SUNWwabi/man/man1]
end
