# frozen_string_literal: true
#

collection_namespace 'thirdparty' do
  manual_namespace 'AMT/DAP_4.1S',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/amt_dap_4.1s',
                  odir: 'Sun/thirdparty/AMT/DAP_4.1S',
                  sources: %w[sunany/dapany/rtshelp]

  manual_namespace 'ArborText/Publisher_3.1.1',
                  vendor_class: SunOS::V3_2,
                  idir: 'sun/sunos/thirdparty/arbortext_publisher_3.1.1',
                  odir: 'Sun/thirdparty/ArborText/Publisher_3.1.1',
                  sources: %w[
                    file.1/lpr/man
                    file.1/man
                  ]
  # TODO no Solaris 2.4 doc or macros yet
  manual_namespace 'ArborText/Adept_Publisher_5.0.2',
                  vendor_class: SunOS::V5_4,
                  idir: 'sun/sunos/thirdparty/arbortext_adept_5.0.2',
                  odir: 'Sun/thirdparty/ArborText/Adept_Publisher_5.0.2',
                  sources: %w[man]

  manual_namespace 'Artificial_Horizons/Aviator_1.8',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/aviator_1.8',
                  odir: 'Sun/thirdparty/Artificial_Horizons/Aviator_1.8',
                  sources: %w[
                    aviator.1.8/a??/man
                    aviator.1.8/man/*.[56]
                  ]

  # TODO nroff plain text; non-standard manual format
  manual_namespace 'Cadre/Teamwork_4.0.2',
                  vendor_class: SunOS::V5_1,
                  idir: 'sun/sunos/thirdparty/cadre_teamwork_4.0.2',
                  odir: 'Sun/thirdparty/Cadre/Teamwork_4.0.2',
                  sources: %w[cadre/help]

  # TODO no Solaris 2.1 doc or macros yet
  manual_namespace 'Centerline/TestCenter_1.0.2_beta1.0',
                  vendor_class: SunOS::V5_1,
                  idir: 'sun/sunos/thirdparty/centerline_testcenter_1.0.2_b1.0',
                  odir: 'Sun/thirdparty/Centerline/TestCenter_1.0.2_beta1.0',
                  sources: %w[CenterLine/man/man[15]]

  # TODO no Solaris 2.2 doc or macros yet
  manual_namespace 'Centerline/ViewCenter_2.5.0',
                  vendor_class: SunOS::V5_2,
                  idir: 'sun/sunos/thirdparty/centerline_viewcenter_2.5.0',
                  odir: 'Sun/thirdparty/Centerline/ViewCenter_2.5.0',
                  sources: %w[CenterLine/man.19930811/man/man[15]]

  manual_namespace 'HP/NPI_A.02.00',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/hp_npi_a.02.00',
                  odir: 'Sun/thirdparty/HP/Network-Peripheral-Interface_A.02.00',
                  sources: %w[usr/lib/hpnp/sun-man/man[158]]

  manual_namespace 'Interphase/NC400_1.4.2',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/interphase_nc400_1.4.2',
                  odir: 'Sun/thirdparty/Interphase/NC400_1.4.2',
                  sources: %w[man/OMNI/man[148]]

  manual_namespace 'Illustra/Datablade_1.1',
                  vendor_class: SunOS::V5_5_1, # ...probably?
                  idir: 'sun/sunos/thirdparty/illustra_datablade_1.1',
                  odir: 'Sun/thirdparty/Illustra/Datablade_1.1',
                  sources: %w[dbdk/man/manl]

  manual_namespace 'IXI/Motif_1.1_X11R4',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/thirdparty/ixi_motif_1.1',
                  odir: 'Sun/thirdparty/IXI/Motif_1.1_X11R4',
                  sources: %w[usr/man/man[3n]]

  manual_namespace 'IXI/Motif_Developer_Pack_1.2.2a',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/thirdparty/ixi_motif_devpack_1.2.2a',
                  odir: 'Sun/thirdparty/IXI/Motif_Developer_Pack_1.2.2a',
                  sources: %w[man/man[135]]

  manual_namespace 'Legato/PrestoServe_1.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/thirdparty/legato_prestoserve_1.1',
                  odir: 'Sun/thirdparty/Legato/PrestoServe_1.1',
                  sources: %w[*.[0-9]*]

  manual_namespace 'Lotus/1-2-3_1.0',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/thirdparty/lotus_123_1.0',
                  odir: 'Sun/thirdparty/Lotus/1-2-3_1.0',
                  sources: %w[lotus/man/man1]

  # TODO no Solaris 2.2 doc or macros yet
  manual_namespace 'Lucid/C_2.2',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/lucid_c_2.2',
                  odir: 'Sun/thirdparty/Lucid/C_2.2',
                  sources: %w[man/man1]

  manual_namespace 'Lucid/C++_3.0beta',
                  vendor_class: SunOS::V5_2,
                  idir: 'sun/sunos/thirdparty/lucid_c++_3.0b',
                  odir: 'Sun/thirdparty/Lucid/C++_3.0beta',
                  sources: %w[man/man[13]]

  # TODO all kinds of stuff in here, it (probably) needs sorted/organized into subdirs
  #      TeX sources of Lucid Emacs manual in lemacs.new/man/
  #      postscript source in iv-3.1/iv/src/man/refman > make refman.PS
  manual_namespace 'Lucid/Energize_2.1',
                  vendor_class: SunOS::V4_0,
                  idir: 'sun/sunos/thirdparty/lucid_energize_2.1',
                  odir: 'Sun/thirdparty/Lucid/Energize_2.1',
                  sources: %w[
                    etc.new/examples/man/man[13]
                    etc.new/tutorial/man/man3
                    flexlm.new/man/man[15]
                    lcc.new/man/man[13]
                    man.new/man/man[1358]
                    ostore.new/man/man[18]
                    iv-3.1/iv/installed/man/mann
                    iv-3.1/iv/man/faq/faq.out
                    iv-3.1/iv/man/commands/*.n
                    iv-3.1/iv/man/Dispatch/*.n
                    iv-3.1/iv/man/Interviews/*.n
                    iv-3.1/iv/man/Unidraw/*.n
                  ]

  manual_namespace 'MicroFocus/COBOL_3.2',
                  vendor_class: SunOS::V5_3,
                  idir: 'sun/sunos/thirdparty/microfocus_cobol_3.2',
                  odir: 'Sun/thirdparty/MicroFocus/COBOL_3.2',
                  sources: %w[docs/*.1]

  manual_namespace 'Netscape/Enterprise_Server_3.5.1',
                  vendor_class: SunOS::V5_5,
                  idir: 'sun/sunos/thirdparty/netscape_ent_3.5.1',
                  odir: 'Sun/thirdparty/Netscape/Enterprise_Server_3.5.1',
                  sources: %w[manual/*]

  # TODO HTML manual; check for output file collisions
  manual_namespace 'Netscape/FastTrack_Directory_Server_3.1',
                  vendor_class: SunOS::V5_4,
                  idir: 'sun/sunos/thirdparty/netscape_dirsrv_3.1',
                  odir: 'Sun/thirdparty/Netscape/FastTrack_Directory_Server_3.1',
                  sources: %w[
                    directory/manual/*
                    directory/fasttrack_3.0.1/manual/*
                    directory/ldapsdk/docs
                  ]

  manual_namespace 'Oracle/6.0.33.1',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/oracle_6.0.33.1',
                  odir: 'Sun/thirdparty/Oracle/6.0.33.1',
                  sources: %w[*/man]

  manual_namespace 'Quintus/Prolog_3.2',
                  vendor_class: SunOS::V5_1, # REVIEW correct ver?
                  idir: 'sun/sunos/thirdparty/quintus_prolog_3.2',
                  odir: 'Sun/thirdparty/Quintus/Prolog_3.2',
                  sources: %w[generic/q3.2/man/man1] # TODO helplib?

  # TODO local string.defs (see: NeWS_1.1)
  manual_namespace 'Parallax/PNeWS_3.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/parallax_pnews_3.0',
                  odir: 'Sun/thirdparty/Parallax/PNeWS_3.0',
                  sources: %w[
                    plx.4
                    man/sc.1
                    man/man[136]
                  ]

  manual_namespace 'Pixar/High_Speed_Interface_1.1',
                  vendor_class: SunOS::V4_1_4,
                  idir: 'pixar/hsi-sun3/1.1',
                  odir: 'Sun/thirdparty/Pixar/High_Speed_Interface_1.1',
                  sources: %w[hsi/man/man[1-8]]

  # TODO nroff for terminal (short screen, 24 or 25 line page length)
  manual_namespace 'Sybase/DB_Library_C_4.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/sybase_db_library_c_4.0',
                  odir: 'Sun/thirdparty/Sybase/DB_Library_C_4.0',
                  sources: %w[doc]
  manual_namespace 'Sybase/SQL_Server_4.0',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/sybase_sql_server_4.0',
                  odir: 'Sun/thirdparty/Sybase/SQL_Server_4.0',
                  sources: %w[doc]

  manual_namespace 'SAS/C_370_5.50.12',
                  vendor_class: SunOS::V4_1,
                  idir: 'sun/sunos/thirdparty/sas_c_370_5.50.12',
                  odir: 'Sun/thirdparty/SAS/C_370_5.50.12',
                  sources: %w[man1]

  # TODO .TH footer (not a revision date)
  manual_namespace 'Transarc/AFS_3.2',
                  vendor_class: SunOS::V4_1_4,
                  idir: 'sun/sunos/thirdparty/transarc_afs_3.2',
                  odir: 'Sun/thirdparty/Transarc/AFS_3.2',
                  sources: %w[man/man1]
end
