# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  manual_namespace 'Tru64/ACMSxp_3.2A',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/acm32a', # TODO uses rsml/sml macros
                  odir: 'DEC/unbundled/Tru64/ACMSxp_3.2A',
                  sources: %w[usr/opt/ACMSXPV32A/man/man[138]]

  manual_namespace 'Tru64/BASEstar_Open_Server_3.2',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/bst320',
                  odir: 'DEC/unbundled/Tru64/BASEstar_Open_Server_3.2',
                  sources: %w[
                    usr/opt/BCF220/man/man1
                    usr/opt/bstman320/man/man[13]
                    usr/share/man/man3
                  ]

  manual_namespace 'Ultrix/C_1.0/VAX',
                  vendor_class: Ultrix::V4_2_0, # REVIEW correct?
                  idir: 'dec/ultrix/unbundled/vax_c_1.0',
                  odir: 'DEC/unbundled/Ultrix/C_1.0/VAX',
                  sources: %w[usr/man/man1]

  manual_namespace 'Tru64/C++_6.2',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/cxx620',
                  odir: 'DEC/unbundled/Tru64/C++_6.2',
                  sources: %w[usr/share/doclib/cplusplus/*.htm] do |t| # TODO html support
                    assets_task %w(*.gif *.ps *.pdf), t[:idir], t[:odir], cut_dirs: 4
                    task all: [:assets]
                  end

  manual_namespace 'Tru64/COBOL_2.6',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/dca260',
                  odir: 'DEC/unbundled/Tru64/COBOL_2.6',
                  sources: %w[usr/lib/cmplrs/cobol_260]

  manual_namespace 'Tru64/DCE_3.1',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/dce310', # TODO wth is up with the section 1 pages (others - some are "normal" though - 3rpc, 3sec are)
                  odir: 'DEC/unbundled/Tru64/DCE_3.1',
                  sources: %w[usr/opt/DCE310/man/man[1-8]]

  manual_namespace 'Ultrix/DECnet_3.0/VAX',
                  vendor_class: Ultrix::V4_2_0,
                  idir: 'dec/ultrix/unbundled/decnet_vax_3.0',
                  odir: 'DEC/unbundled/Ultrix/DECnet_3.0/VAX',
                  sources: %w[usr/man/man[1238]]

  manual_namespace 'Ultrix/DECnet_SNA_1.0',
                  vendor_class: Ultrix::V4_2_0, # REVIEW correct?
                  idir: 'dec/ultrix/unbundled/decnetsna_1.0',
                  odir: 'DEC/unbundled/Ultrix/DECnet_SNA_1.0',
                  sources: %w[usr/man/man1]

  manual_namespace 'Digital_UNIX/DECnet_OSI_4.0C',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/dna40c',
                  odir: 'DEC/unbundled/Digital_UNIX/DECnet_OSI_4.0C',
                  sources: %w[usr/opt/DNA403/share/man/man[158]]

  manual_namespace 'Tru64/DECnet-Plus_5.0',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/dna500',
                  odir: 'DEC/unbundled/Tru64/DECnet-Plus_5.0',
                  sources: %w[usr/opt/DNA500/share/man/man[158]]

  manual_namespace 'Digital_UNIX/DECnet_WAN_Support_3.0A',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/xxa30a',
                  odir: 'DEC/unbundled/Digital_UNIX/DECnet_WAN_Support_3.0A',
                  sources: %w[usr/opt/[WX]?A300/share/man/man[123478]]

  manual_namespace 'Tru64/DECnet_WAN_Support_3.1',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/xxa310',
                  odir: 'DEC/unbundled/Tru64/DECnet_WAN_Support_3.1',
                  sources: %w[usr/opt/[WX]?A310/share/man/man[123478]]

  manual_namespace 'Digital_UNIX/DECosap_AP_3.1',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/sap310',
                  odir: 'DEC/unbundled/Digital_UNIX/DECosap_AP_3.1',
                  sources: %w[usr/share/man/man3]

  manual_namespace 'Tru64/Diskless_Driver_2.01',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/ddu201',
                  odir: 'DEC/unbundled/Tru64/Diskless_Driver_2.01',
                  sources: %w[usr/man/man[78]]

  manual_namespace 'OSF1/DSM_Japanese_1.0E',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/jds10e',
                  odir: 'DEC/unbundled/OSF1/DSM_Japanese_1.0E',
                  sources: %w[usr/opt/JDS105/man/man1] # ja_JP page also - but is identical to en_US page

  manual_namespace 'Digital_UNIX/EDI_3.2',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/dedi320',
                  odir: 'DEC/unbundled/Digital_UNIX/EDI_3.2',
                  sources: %w[
                    usr/opt/DEDIAMSGMAN320/usr/man/man8
                    usr/opt/DEDICLTMAN320/usr/man/man[13]
                    usr/opt/DEDISERVMAN320/usr/man/man8
                  ]

  manual_namespace 'Digital_UNIX/Extended_Math_Library_3.4',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/xmd340',
                  odir: 'DEC/unbundled/Digital_UNIX/Extended_Math_Library_3.4',
                  sources: %w[usr/opt/XMDMAN340/man]

  manual_namespace 'OSF1/F-RJE_1.0',
                  vendor_class: OSF1::V3_2c,
                  odir: 'DEC/unbundled/OSF1/F-RJE_1.0',
                  idir: 'dec/du/unbundled/fjr100',
                  # have to use OSF1 to convert deckanji encoding to something we can cope with
                  #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man*]
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man*] # iconv giving ¥ instead of \
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.eucJP/man/man*]
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.ISO-2022-JP/man/man*]
                  sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man*]

  manual_namespace 'Ultrix/FORTRAN_1.0/mips',
                  vendor_class: Ultrix::V4_2_0, # REVIEW correct?
                  idir: 'dec/ultrix/unbundled/fortran_mips_1.0',
                  odir: 'DEC/unbundled/Ultrix/FORTRAN_1.0/mips',
                  sources: %w[usr/man/man[13]]

  manual_namespace 'Tru64/FORTRAN_5.3',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/dfa530',
                  odir: 'DEC/unbundled/Tru64/FORTRAN_5.3',
                  sources: %w[
                    usr/lib/cmplrs/fort*_530/*.man
                    usr/lib/cmplrs/fort*_530/relnotes*
                    usr/opt/XMDMAN360/man/*.3*
                    usr/opt/XMDHTM360/cxml_webpages/*.html
                  ] do |t|
                    assets_task %w(*.gif), t[:idir], t[:odir], cut_dirs: 4
                    task all: [:assets]
                  end

  manual_namespace 'Tru64/FUSE_4.2/en_US',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/fus420',
                  odir: 'DEC/unbundled/Tru64/FUSE_4.2/en_US',
                  sources: %w[usr/opt/FUS420/man/man1]

  manual_namespace 'Tru64/FUSE_4.2/ja_JP', # ja_JP pages also
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/fus420',
                  odir: 'DEC/unbundled/Tru64/FUSE_4.2/ja_JP',
                  sources: %w[usr/opt/FUS420/man/ja_JP.SJIS/man1]

  manual_namespace 'Digital_UNIX/InfoBroker_Server_2.2',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/ibx220',
                  odir: 'DEC/unbundled/Digital_UNIX/InfoBroker_Server_2.2',
                  sources: %w[usr/share/man/man[38]]

  manual_namespace 'Tru64/Micro_Focus_COBOL_4.1B',
                  vendor_class: Tru64::V4_0f,
                  odir: 'DEC/unbundled/Tru64/Micro_Focus_COBOL_4.1B',
                  idir: 'dec/du/unbundled/mfc41b',
                  sources: %w[usr/lib/cmplrs/cob_413]

  manual_namespace 'Digital_UNIX/Multimedia_Services_2.4B',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/mme24b',
                  odir: 'DEC/unbundled/Digital_UNIX/Multimedia_Services_2.4B',
                  sources: %w[usr/opt/MME242/share/man/man[1347]]

  manual_namespace 'Digital_UNIX/MAILbus_400_2.0C',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/mtaa20c',
                  odir: 'DEC/unbundled/Digital_UNIX/MAILbus_400_2.0c',
                  sources: %w[usr/opt/MTAAMAN202/usr/share/man/man3]

  manual_namespace 'Tru64/Open3D_4.96',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/o3d496', # TODO 3gl pages have no section regex match
                  odir: 'DEC/unbundled/Tru64/Open3D_4.96',
                  sources: %w[usr/man/man[13]]

  manual_namespace 'Digital_UNIX/Optical_Storage_Management_1.6',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/osms160',
                  odir: 'DEC/unbundled/Digital_UNIX/Optical_Storage_Management_1.6',
                  sources: %w[usr/man/man[14578]]

  manual_namespace 'Tru64/Pascal_5.7',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/dpo570',
                  odir: 'DEC/unbundled/Tru64/Pascal_5.7',
                  sources: %w[usr/lib/cmplrs/pc_570]

  manual_namespace 'Tru64/Parallel_Software_Environment_1.9',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/pse190',
                  odir: 'DEC/unbundled/Tru64/Parallel_Software_Environment_1.9',
                  sources: %w[usr/opt/PVM190/man/man[13]]

  manual_namespace 'Digital_UNIX/PHIGS_5.1',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/pho510',
                  odir: 'DEC/unbundled/Digital_UNIX/PHIGS_5.1',
                  sources: %w[usr/man/man3]

  manual_namespace 'Digital_UNIX/POLYCENTER_Intrusion_Detector_1.2A',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/ido12a',
                  odir: 'DEC/unbundled/Digital_UNIX/POLYCENTER_Intrusion_Detector_1.2A',
                  sources: %w[usr/opt/IDOA12A/usr/share/man/man[58]]

  manual_namespace 'Digital_UNIX/POLYCENTER_Security_Compliance_Manager_2.5',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/soa250',
                  odir: 'DEC/unbundled/Digital_UNIX/POLYCENTER_Security_Compliance_Manager_2.5',
                  sources: %w[usr/opt/SOA250/man/man8]

  manual_namespace 'Tru64/Powerstorm_4D_5.0B',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/prs50b',
                  odir: 'DEC/unbundled/Tru64/Powerstorm_4D_5.0B',
                  sources: %w[usr/man/man3]

  manual_namespace 'OSF1/PrintServer_5.1',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/lps520',
                  odir: 'DEC/unbundled/OSF1/PrintServer_5.1',
                  sources: %w[usr/opt/LPS/man/*.[18]]

  manual_namespace 'Digital_UNIX/PrintServer_Japanese_5.1',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/jls510',
                  odir: 'DEC/unbundled/Digital_UNIX/PrintServer_Japanese_5.1',
                  #sources: %w[usr/i18n/share/ja_JP.deckanji/man/man[18]]
                  #sources: %w[xlated/usr/i18n/share/ja_JP.UTF-8/man/man[18]]
                  sources: %w[xlated/usr/i18n/share/ja_JP.SJIS/man/man[18]]

  manual_namespace 'OSF1/SNA_3270_Datastream_Programming_Japanese_1.0',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/sjd100',
                  odir: 'DEC/unbundled/OSF1/SNA_3270_Datastream_Programming_Japanese_1.0',
                  #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
                  sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]

  manual_namespace 'OSF1/SNA_Printer_Emulator_Japanese_1.0',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/sjp100',
                  odir: 'DEC/unbundled/OSF1/SNA_Printer_Emulator_Japanese_1.0',
                  #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[18]]
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[18]]
                  sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[18]]

  manual_namespace 'OSF1/SNA_RJE_1.0',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/sjr100',
                  odir: 'DEC/unbundled/OSF1/SNA_RJE_1.0',
                  #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
                  #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
                  sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]

  manual_namespace 'OSF1/SNA_DECwindows_3270_Emulator_Japanese_2.1A',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/snja21a',
                  odir: 'DEC/unbundled/OSF1/SNA_DECwindows_3270_Emulator_Japanese_2.1A',
                  sources: %w[usr/opt/*/usr/i18n/usr/share/man/man[18]]

  manual_namespace 'Digital_UNIX/SNA_APPC_LU6.2_Programming_3.2',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/snp320',
                  odir: 'DEC/unbundled/Digital_UNIX/SNA_APPC_LU6.2_Programming_3.2',
                  sources: %w[usr/share/man/man3]

  manual_namespace 'Tru64/SNA_APPC_LU6.2_Programming_4.0',
                  vendor_class: Tru64::V4_0f,
                  idir: 'dec/du/unbundled/snp400',
                  odir: 'DEC/unbundled/Tru64/SNA_APPC_LU6.2_Programming_4.0',
                  sources: %w[usr/share/man/man3]

  manual_namespace 'Digital_UNIX/SNA_LUA_Programming_1.0',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/snalu100',
                  odir: 'DEC/unbundled/Digital_UNIX/SNA_LUA_Programming_1.0',
                  sources: %w[usr/opt/SNALUA100/usr/man/man3]

  manual_namespace 'Digital_UNIX/SNA_TN3270-C_1.0',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/tnc100',
                  odir: 'DEC/unbundled/Digital_UNIX/SNA_TN3270-C_1.0',
                  sources: %w[usr/tn3270c/manpages]

  manual_namespace 'Ultrix/SQL_1.0/mips',
                  vendor_class: Ultrix::V4_2_0, # REVIEW correct?
                  idir: 'dec/ultrix/unbundled/sql_mips_1.0',
                  odir: 'DEC/unbundled/Ultrix/SQL_1.0/mips',
                  sources: %w[usr/man/man[18]]

  manual_namespace 'Digital_UNIX/StorageWorks_HSZ40_1.1A',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/swa11a',
                  odir: 'DEC/unbundled/Digital_UNIX/StorageWorks_HSZ40_1.1A',
                  sources: %w[usr/opt/SWA11A/usr/share/man/man8]

  manual_namespace 'Digital_UNIX/TeMIP_Framework_3.2A',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/tfr32a',
                  odir: 'DEC/unbundled/Digital_UNIX/TeMIP_Framework_3.2A',
                  sources: %w[usr/*/manp]

  manual_namespace 'OSF1/Watchdog_Autopilot_2.1',
                  vendor_class: OSF1::V3_2c,
                  idir: 'dec/du/unbundled/wdx210',
                  odir: 'DEC/unbundled/OSF1/Watchdog_Autopilot_2.1',
                  sources: %w[usr/share/man/man[58]]

  manual_namespace 'Digital_UNIX/X.500_3.1',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/unbundled/dxd310',
                  odir: 'DEC/unbundled/Digital_UNIX/X.500_3.1',
                  sources: %w[usr/opt/DXDAMAN310/usr/share/man/man3]
end
