# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  manual_namespace '4.1.1GFX_Rev2',
                  vendor_class: SunOS::V4_1_1,
                  idir: 'sun/sunos/unbundled/4.1.1_gfx_rev2_sun4c',
                  odir: 'Sun/unbundled/4.1.1GFX_Rev2/sun4c',
                  sources: %w[4.1.1-GFX.ENG/_text/man/man[48]*]

  manual_namespace 'ATM_2.0',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/atm_2.0',
                  odir: 'Sun/unbundled/ATM_2.0',
                  sources: %w[SUNWatm/man/man[13479]*]

  manual_namespace 'BQE_1.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/be_qe_1.1',
                  odir: 'Sun/unbundled/BQE_1.1',
                  sources: %w[BQE/usr/man/man4]

  manual_namespace 'C_1.0',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/c_1.0',
                  odir: 'Sun/unbundled/C_1.0',
                  sources: %w[man/man[1358]]

  manual_namespace 'C_1.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/c_1.1+sparcworks',
                  odir: 'Sun/unbundled/C_1.1',
                  sources: %w[cc_compiler/SC1.0/man/man[135]]

  manual_namespace 'C++_2.0',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/c++_2.0',
                  odir: 'Sun/unbundled/C++_2.0',
                  sources: %w[CC/man/man[13]]

  # same as CDE 1.0.2 on Desktop 1.1
  manual_namespace 'CDE_1.0.1',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/cde_1.0',
                  odir: 'Sun/unbundled/CDE_1.0.1',
                  sources: %w[dt/share/man/man[1-6]*]

  manual_namespace 'DiskSuite_1.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/disksuite_1.0',
                  odir: 'Sun/unbundled/DiskSuite_1.0',
                  sources: %w[1.0_DiskSuite/sun4/man/man[23458]]

  manual_namespace 'DiskSuite_4.0',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/disksuite_4.0',
                  odir: 'Sun/unbundled/DiskSuite_4.0',
                  sources: %w[usr/opt/SUNWmd/man/man[147]*]

  manual_namespace 'DOS_Windows_1.0',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/dos_windows_1.0',
                  odir: 'Sun/unbundled/DOS_Windows_1.0',
                  sources: %w[man]

  manual_namespace 'FORTRAN_1.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/fortran_1.1',
                  odir: 'Sun/unbundled/FORTRAN_1.1',
                  sources: %w[share/man/man[13]]

  manual_namespace 'FORTRAN_1.2',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/fortran_1.2',
                  odir: 'Sun/unbundled/FORTRAN_1.2',
                  sources: %w[share/man/man[13]]

  manual_namespace 'FORTRAN_1.3.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/fortran_1.3.1',
                  odir: 'Sun/unbundled/FORTRAN_1.3.1',
                  sources: %w[man/man[1358]]

  manual_namespace 'FORTRAN_1.4',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/fortran_1.4',
                  odir: 'Sun/unbundled/FORTRAN_1.4',
                  sources: %w[man/man[135]]

  manual_namespace 'Motif_SDK_1.2.2',
                  vendor_class: SunOS::V5_2,
                  idir: 'sun/sunos/unbundled/motif_1.2.2_sdk',
                  odir: 'Sun/unbundled/Motif_SDK_1.2.2',
                  sources: %w[SUNWmfdoc/man/man[135]]

  manual_namespace 'Network_Coprocessor_1.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/net_coprocessor_1.0',
                  odir: 'Sun/unbundled/Network_Coprocessor_1.0',
                  sources: %w[Snc/usr/man/man[48]]

  # TODO local string.defs, header.mex
  manual_namespace 'NeWS_1.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/news_1.1',
                  odir: 'Sun/unbundled/NeWS_1.1',
                  sources: %w[man/man[136]]

  manual_namespace 'ODBC_2.11',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/odbc_2.11',
                  odir: 'Sun/unbundled/ODBC_2.11',
                  sources: %w[man/man4]

  manual_namespace 'OpenWindows_1.0_PreFCS',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/openwindows_1.0_pre_fcs',
                  odir: 'Sun/unbundled/OpenWindows_1.0_PreFCS',
                  sources: %w[man/man[136n]]

  manual_namespace 'OpenWindows_1.1_Developer_Guide',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/openwindows_1.1_dev_guide',
                  odir: 'Sun/unbundled/OpenWindows_1.1_Developer_Guide',
                  sources: %w[man/man1]

  manual_namespace 'OpenWindows_V2',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/openwindows_v2',
                  odir: 'Sun/unbundled/OpenWindows_V2',
                  sources: %w[man/man[136n]]

  # TODO compare +XGL 2.0 RTE
  manual_namespace 'OpenWindows_V3',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/openwindows_v2',
                  odir: 'Sun/unbundled/OpenWindows_V3',
                  sources: %w[OpenWindows/sun4/share/man/man[135678]]

  manual_namespace 'Pascal_1.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/pascal_1.1',
                  odir: 'Sun/unbundled/Pascal_1.1',
                  sources: %w[man/man1]

  manual_namespace 'Pascal_2.0',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/pascal_2.0',
                  odir: 'Sun/unbundled/Pascal_2.0',
                  sources: %w[man/man1]

  manual_namespace 'Pascal_2.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/pascal_2.1',
                  odir: 'Sun/unbundled/Pascal_2.1',
                  sources: %w[man/man[15]]

  # TODO local tmac.an with .ds j (\nj=1 ? CADAM : NO_CADAM) for CADAM specific text
  # escape.3 refs conditional; escape_-3.3 and escape_-13.3 are entirely conditional on it
  # section 3P+ for PHIGS+
  manual_namespace 'PHIGS_1.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/phigs_1.1',
                  odir: 'Sun/unbundled/PHIGS_1.1',
                  sources: %w[man/phigs1.1/man[37]]

  # V3N1 x86
  manual_namespace 'ProWorks_3.0.1',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/proworks_3.0.1',
                  odir: 'Sun/unbundled/ProWorks_3.0.1',
                  sources: %w[
                    SUNWspro/*/man/man[1345]*
                    SUNWspro/FSF/sbtags/man/man1
                    SUNWste/license_tools/man/man1
                  ]

  manual_namespace 'SBus_Printer_Card_1.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/sbus_printer_card_1.0',
                  odir: 'Sun/unbundled/SBus_Printer_Card_1.0',
                  sources: %w[man]

  manual_namespace 'SBus_Serial_Parallel_1.2',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/serial_parallel_1.2',
                  odir: 'Sun/unbundled/SBus_Serial_Parallel_1.2',
                  sources: %w[STC/bin/man/man4]

  manual_namespace 'SBus_Serial_Parallel_2.0',
                  vendor_class: SunOS::V5_1,
                  idir: 'sun/sunos/unbundled/serial_parallel_2.0',
                  odir: 'Sun/unbundled/SBus_Serial_Parallel_2.0',
                  sources: %w[STC/bin/man/man4]

  manual_namespace 'Solaris_2.4_x86_SDK',
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

  manual_namespace 'Solstice_Backup_4.1.2/Solaris',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
                  odir: 'Sun/unbundled/Solstice_Backup_4.1.2/Solaris',
                  sources: %w[share/man/man[358]]

  # REVIEW different from Solaris manual?
  manual_namespace 'Solstice_Backup_4.1.2/SunOS',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
                  odir: 'Sun/unbundled/Solstice_Backup_4.1.2/SunOS',
                  sources: %w[SunOS/man]

  collection_namespace 'SPARCworks_2.0.1' do
    manual_namespace 'SunOS_4',
                    vendor_class: SunOS::V4_1,
                    idir: 'sun/sunos/unbundled/sparcworks_2.0.1/solaris1',
                    odir: 'Sun/unbundled/SPARCworks_2.0.1/sunos4',
                    sources: %w[
                      S*/*/man/man[1345]
                      T*/*/*/man/man[1345]
                    ]

    manual_namespace 'SunOS_5',
                    vendor_class: SunOS::V5_1,
                    idir: 'sun/sunos/unbundled/sparcworks_2.0.1/solaris1',
                    odir: 'Sun/unbundled/SPARCworks_2.0.1/sunos5',
                    sources: %w[
                      SPRO*/reloc/$BASEDIR/*/$PRODVERS/man/man[135]
                      SPRO*/reloc/*/*/man/man[15]
                    ]
  end

  manual_namespace 'SunLink_TRI_SBus_2.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/sunlink_tri_s_2.1',
                  odir: 'Sun/unbundled/SunLink_TRI_SBus_2.1',
                  sources: %w[sunlink/tr/man/man4]

  manual_namespace 'SunLink_TRI_SBus_3.0.1',
                  vendor_class: SunOS::V5_1,
                  idir: 'sun/sunos/unbundled/sunlink_tri_s_3.0.1',
                  odir: 'Sun/unbundled/SunLink_TRI_SBus_3.0.1',
                  sources: %w[sunlink/tr/man/man7]

  manual_namespace 'TOPS_2.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/tops_2.1',
                  odir: 'Sun/unbundled/TOPS_2.1',
                  sources: %w[.]

  manual_namespace 'TranSCRIPT_2.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/unbundled/transcript_2.1',
                  odir: 'Sun/unbundled/TranSCRIPT_2.1',
                  sources: %w[man]

  manual_namespace 'TranSCRIPT_2.1.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/unbundled/transcript_2.1.1',
                  odir: 'Sun/unbundled/TranSCRIPT_2.1.1',
                  sources: %w[man]

  manual_namespace 'WABI_2.0',
                  vendor_class: SunOS::V5_4,
                  idir: 'sun/sunos/unbundled/wabi_2.0',
                  odir: 'Sun/unbundled/WABI_2.0',
                  sources: %w[SUNWwabi/man/man1]

  manual_namespace 'WABI_2.1',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/wabi_2.1',
                  odir: 'Sun/unbundled/WABI_2.1',
                  sources: %w[SUNWwabi/man/man1]

  manual_namespace 'WABI_2.2',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/unbundled/wabi_2.2',
                  odir: 'Sun/unbundled/WABI_2.2',
                  sources: %w[SUNWwabi/man/man1]

  # V5N1 SPARC
  collection_namespace 'WorkShop_3.0.1' do
    manual_namespace 'SunOS_4',
                    vendor_class: SunOS::V4_1,
                    idir: 'sun/sunos/unbundled/workshop_solaris1_v5n1',
                    odir: 'Sun/unbundled/WorkShop_3.0.1/sunos4',
                    sources: %w[
                      [ST]*/*/man/man[1345l]
                      SW3.0.1_sbfsf/FSF/sbtags/man/man1
                    ]

    manual_namespace 'SunOS_5',
                    vendor_class: SunOS::V5_5,
                    idir: 'sun/sunos/unbundled/workshop_3.0',
                    odir: 'Sun/unbundled/WorkShop_3.0.1/sunos5',
                    sources: %w[
                      SUNWspro/*/man/man[134]*
                      SUNWspro/contrib/*/man/man1
                      SUNWste/license_tools/man/man1
                    ]
  end

  # V6N1 SPARC
  manual_namespace 'WorkShop_5.0',
                  vendor_class: SunOS::V5_6,
                  idir: 'sun/sunos/unbundled/workshop_5.0',
                  odir: 'Sun/unbundled/WorkShop_5.0',
                  sources: %w[
                    SUNW*/*/man/man[134]*
                    SUNWspro/contrib/XEmacs20.4/man/man1
                    SUNWste/license_tools/man/man1
                  ]
end
