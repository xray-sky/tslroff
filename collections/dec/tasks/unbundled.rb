# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  collection_namespace 'MicroVMS' do
    manual_namespace 'DECNet_Endnode_4.4',
      vendor_class: MicroVMS,
      os: 'DECNet Endnode',
      ver: '4.4',
      idir: 'dec/microvms/products/decnet_endnode_4.4',
      odir: 'DEC/unbundled/MicroVMS/DECNet_Endnode_4.4',
      sources: %w[
        net/a
      ]

    manual_namespace 'VWS_3.1',
      vendor_class: MicroVMS,
      os: 'VWS',
      ver: '3.1',
      idir: 'dec/microvms/products/vws31',
      odir: 'DEC/unbundled/MicroVMS/VWS_3.1',
      sources: %w[
        fisher/hcuis/hcuis030.release_notes
        syshlp/uishelp.hlp
      ]

    manual_namespace 'VWS_3.2',
      vendor_class: MicroVMS,
      os: 'VWS',
      ver: '3.2',
      idir: 'dec/microvms/products/vws32',
      odir: 'DEC/unbundled/MicroVMS/VWS_3.2',
      sources: %w[
        kits/hcuis
        kits/a/
      ]

    manual_namespace 'VWS_3.3',
      vendor_class: MicroVMS,
      os: 'VWS',
      ver: '3.3',
      idir: 'dec/microvms/products/vws33',
      odir: 'DEC/unbundled/MicroVMS/VWS_3.3',
      sources: %w[
        kit/src
        syshlp
        vws033/sight_a
      ]
  end

  collection_namespace 'VMS' do
    manual_namespace 'C_2.3',
      vendor_class: VMS,
      os: 'VAX C',
      ver: '2.3',
      idir: 'dec/vms/products/c23',
      odir: 'DEC/unbundled/VMS/C_2.3',
      sources: %w[c/capture/maint]

    manual_namespace 'C_3.0',
      vendor_class: VMS,
      os: 'VAX C',
      ver: '3.0',
      idir: 'dec/vms/products/c30',
      odir: 'DEC/unbundled/VMS/C_3.0',
      sources: %w[c/capture/de*]

    manual_namespace 'C_3.2',
      vendor_class: VMS,
      os: 'VAX C',
      ver: '3.2',
      idir: 'dec/vms/products/c32',
      odir: 'DEC/unbundled/VMS/C_3.2',
      sources: %w[hovey/temp]

    manual_namespace 'CDD+_4.1A',
      vendor_class: VMS,
      os: 'CDD/plus',
      ver: '4.1A',
      idir: 'dec/vms/products/cdd+41a',
      odir: 'DEC/unbundled/VMS/CDD+_4.1A',
      sources: %w[legerlotz/sdc-v41a/[a-e]]

    manual_namespace 'CMS_2.2',
      vendor_class: VMS,
      os: 'VAX DEC/CMS',
      ver: '2.2',
      idir: 'dec/vms/products/cms22',
      odir: 'DEC/unbundled/VMS/CMS_2.2',
      sources: %w[cms]

    manual_namespace 'CMS_3.0',
      vendor_class: VMS,
      os: 'VAX DEC/CMS',
      ver: '3.0',
      idir: 'dec/vms/products/cms30',
      odir: 'DEC/unbundled/VMS/CMS_3.0',
      sources: %w[install/cms/a]

    manual_namespace 'CMS_3.2',
      vendor_class: VMS,
      os: 'VAX DEC/CMS',
      ver: '3.2',
      idir: 'dec/vms/products/cms32',
      odir: 'DEC/unbundled/VMS/CMS_3.2',
      sources: %w[cms/build/v032-00/kit_components/[ab]]

    manual_namespace 'COBOL_5.0',
      vendor_class: VMS,
      os: 'VAX COBOL',
      ver: '5.0',
      idir: 'dec/vms/products/cobol50',
      odir: 'DEC/unbundled/VMS/COBOL_5.0',
      sources: %w[monteleone/v5/kit]

    manual_namespace 'DECNet_Endnode_4.5B',
      vendor_class: VMS,
      os: 'DECNet Endnode',
      ver: '4.5B',
      idir: 'dec/vms/products/decnet45b_endnode',
      odir: 'DEC/unbundled/VMS/DECNet_Endnode_4.5B',
      sources: %w[net/a]

    manual_namespace 'DECNet_SNA_Gateway_2.0',
      vendor_class: VMS,
      os: 'DECNet SNA Gateway',
      ver: '2.0',
      idir: 'dec/vms/products/decnet-sna_gw20',
      odir: 'DEC/unbundled/VMS/DECNet_SNA_Gateway_2.0',
      sources: %w[alice/snagm]

    manual_namespace 'FORTRAN_4.6',
      vendor_class: VMS,
      os: 'VAX FORTRAN',
      ver: '4.6',
      idir: 'dec/vms/products/ftn46',
      odir: 'DEC/unbundled/VMS/FORTRAN_4.6',
      sources: %w[walter/kit/fhlp]

    manual_namespace 'FORTRAN_4.7',
      vendor_class: VMS,
      os: 'VAX FORTRAN',
      ver: '4.7',
      idir: 'dec/vms/products/ftn47',
      odir: 'DEC/unbundled/VMS/FORTRAN_4.7',
      sources: %w[f4v4/kit/fhlp]

    manual_namespace 'FORTRAN_5.2',
      vendor_class: VMS,
      os: 'VAX FORTRAN',
      ver: '5.2',
      idir: 'dec/vms/products/ftn52',
      odir: 'DEC/unbundled/VMS/FORTRAN_5.2',
      sources: %w[fort/v5/kit/*]

    manual_namespace 'FORTRAN_5.4',
      vendor_class: VMS,
      os: 'VAX FORTRAN',
      ver: '5.4',
      idir: 'dec/vms/products/ftn54',
      odir: 'DEC/unbundled/VMS/FORTRAN_5.4',
      sources: %w[fort/v5/kit/v5_4]

    manual_namespace 'LISP_2.0',
      vendor_class: VMS,
      os: 'VAX LISP',
      ver: '2.0',
      idir: 'dec/vms/products/lisp20',
      odir: 'DEC/unbundled/VMS/LISP_2.0',
      sources: %w[lisp/kitbuild/work]

    manual_namespace 'LISP_3.0A',
      vendor_class: VMS,
      os: 'VAX LISP',
      ver: '3.0A',
      idir: 'dec/vms/products/lisp30a',
      odir: 'DEC/unbundled/VMS/LISP_3.0A',
      sources: %w[foster/work/[ab]]

    manual_namespace 'LISP_3.1',
      vendor_class: VMS,
      os: 'VAX LISP',
      ver: '3.1',
      idir: 'dec/vms/products/lisp31',
      odir: 'DEC/unbundled/VMS/LISP_3.1',
      sources: %w[foster/work/[ab]]

    manual_namespace 'LSE_3.0',
      vendor_class: VMS,
      os: 'Language-Sensitive Editor',
      ver: '3.0',
      idir: 'dec/vms/products/lse30',
      odir: 'DEC/unbundled/VMS/LSE_3.0',
      sources: %w[kit/[ab]]

    manual_namespace 'Motif_1.1_DW',
      vendor_class: VMS,
      os: 'VMS DECwindows Motif',
      ver: '1.1',
      idir: 'dec/vms/products/motif11dw',
      odir: 'DEC/unbundled/VMS/DECwindows_Motif_1.1',
      sources: %w[syshlp]

    manual_namespace 'Motif_1.1_OSF',
      vendor_class: VMS,
      os: 'DECwindows Motif Dev Kit',
      ver: '1.1',
      idir: 'dec/vms/products/motif11osf',
      odir: 'DEC/unbundled/VMS/OSF_Motif_1.1',
      sources: %w[gmf/kits/motif/v11/[ae]]

    # TODO txtlib not extracted?
    manual_namespace 'Pascal_3.8',
      vendor_class: VMS,
      os: 'VAX Pascal',
      ver: '3.8',
      idir: 'dec/vms/products/pas38',
      odir: 'DEC/unbundled/VMS/Pascal_3.8',
      sources: %w[
        pascal/v38kit/pas3*
        williams/pascal/v34kit/finalkit/pas3star
        williams/pascal/v37kit/pas3kit
      ]

    # TODO release notes - line printer? line endings? bold with cr/no lf ?
    # some other product release notes like this too (check for double-spaced)
    manual_namespace 'Pascal_4.0',
      vendor_class: VMS,
      os: 'VAX Pascal',
      ver: '4.0',
      idir: 'dec/vms/products/pas40',
      odir: 'DEC/unbundled/VMS/Pascal_4.0',
      sources: %w[pascal/v40kit/saveset_[ab]_files]

    manual_namespace 'PCSA_Server_2.1',
      vendor_class: VMS,
      os: 'VAX/VMS Services for MS-DOS',
      ver: '2.1',
      idir: 'dec/vms/products/pcsa_vms_srv21',
      odir: 'DEC/unbundled/VMS/PCSA_Server_2.1',
      sources: %w[operator/pcsa021]

    manual_namespace 'RDB_3.1A',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '3.1A',
      idir: 'dec/vms/products/rdb31a',
      odir: 'DEC/unbundled/VMS/RDB_3.1A',
      sources: %w[kitdir/rdbvmsdev031/[abd]]

    manual_namespace 'RDB_4.0',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '4.0',
      idir: 'dec/vms/products/rdb40',
      odir: 'DEC/unbundled/VMS/RDB_4.0',
      sources: %w[kitdir/rdbvmsdev040/[abd]]

    manual_namespace 'RDB_4.0B',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '4.0B',
      idir: 'dec/vms/products/rdb40b',
      odir: 'DEC/unbundled/VMS/RDB_4.0B',
      sources: %w[kitdir/rdbvmsd_mupb040/[abd]]

    manual_namespace 'RDB_4.1_M',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '4.1 Multinode',
      idir: 'dec/vms/products/rdb41a_multinode',
      odir: 'DEC/unbundled/VMS/RDB_4.1_multinode',
      sources: %w[kitdir/rdbvmsmupamv041/[abd]]

    manual_namespace 'RDB_4.1A',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '4.1A Standalone',
      idir: 'dec/vms/products/rdb41a_standalone',
      odir: 'DEC/unbundled/VMS/RDB_4.1A',
      sources: %w[kitdir/rdbvmsmupa041/[abd]]

    manual_namespace 'RDB_4.2',
      vendor_class: VMS,
      os: 'Rdb/VMS',
      ver: '4.2 Standalone',
      idir: 'dec/vms/products/rdb42_standalone',
      odir: 'DEC/unbundled/VMS/RDB_4.2',
      sources: %w[kitdir/rdbvms042/[abd]]

    manual_namespace 'SQLdev_2.0',
      vendor_class: VMS,
      os: 'VAX SQL',
      ver: '2.0',
      idir: 'dec/vms/products/sqldev20',
      odir: 'DEC/unbundled/VMS/SQL_2.0',
      sources: %w[kitdir/sqlprg020/[ab]]

    manual_namespace 'UCX_1.2',
      vendor_class: VMS,
      os: 'VMS/Ultrix Connection',
      ver: '1.2',
      idir: 'dec/vms/products/ucx12',
      odir: 'DEC/unbundled/VMS/UCX_1.2',
      sources: %w[ucx/v12/bl15/kit/[ab]]

    # TODO FIXME causes rake to loop???
    manual_namespace 'UCX_1.3',
      vendor_class: VMS,
      os: 'VMS/Ultrix Connection',
      ver: '1.3',
      idir: 'dec/vms/products/ucx13',
      odir: 'DEC/unbundled/VMS/UCX_1.3',
      sources: %w[ucx/v13/bl13/*kit/[ab]]

    manual_namespace 'VWS_4.0A',
      vendor_class: VMS,
      os: 'VMS Workstation Software',
      ver: '4.0A Update',
      idir: 'dec/vms/products/vws40a_upd',
      odir: 'DEC/unbundled/VMS/VWS_4.0A_Update',
      sources: %w[vws040/pvax]

    manual_namespace 'VWS_4.1',
      vendor_class: VMS,
      os: 'VMS Workstation Software',
      ver: '4.1',
      idir: 'dec/vms/products/vws41',
      odir: 'DEC/unbundled/VMS/VWS_4.1',
      sources: %w[
        kit/*release_notes
        kit/tmp
        public/vwsdecw010/kit
      ]

    # TODO oddly formfeeding in release nodes
    manual_namespace 'WAN_Drivers_1.1A',
      vendor_class: VMS,
      os: 'WAN Device Drivers',
      ver: '1.1A',
      idir: 'dec/vms/products/wandd11a',
      odir: 'DEC/unbundled/VMS/WAN_Drivers_1.1A',
      sources: %w[obj/kit/sync/a]
  end

  collection_namespace 'Digital_UNIX' do
    manual_namespace 'DECnet_OSI_4.0C',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'DECnet OSI',
      ver: '4.0C',
      idir: 'dec/du/unbundled/dna40c',
      odir: 'DEC/unbundled/Digital_UNIX/DECnet_OSI_4.0C',
      sources: %w[usr/opt/DNA403/share/man/man[158]]

    manual_namespace 'DECnet_WAN_Support_3.0A',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'DECnet WAN Support',
      ver: '3.0A',
      idir: 'dec/du/unbundled/xxa30a',
      odir: 'DEC/unbundled/Digital_UNIX/DECnet_WAN_Support_3.0A',
      sources: %w[usr/opt/[WX]?A300/share/man/man[123478]]

    manual_namespace 'DECosap_AP_3.1',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'DECosap/AP',
      ver: '3.1',
      idir: 'dec/du/unbundled/sap310',
      odir: 'DEC/unbundled/Digital_UNIX/DECosap_AP_3.1',
      sources: %w[usr/share/man/man3]

    manual_namespace 'EDI_3.2',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'DEC/EDI',
      ver: '3.2',
      idir: 'dec/du/unbundled/dedi320',
      odir: 'DEC/unbundled/Digital_UNIX/EDI_3.2',
      sources: %w[
        usr/opt/DEDIAMSGMAN320/usr/man/man8
        usr/opt/DEDICLTMAN320/usr/man/man[13]
        usr/opt/DEDISERVMAN320/usr/man/man8
      ]

    manual_namespace 'Extended_Math_Library_3.4',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'Extended Math Library',
      ver: '3.4',
      idir: 'dec/du/unbundled/xmd340',
      odir: 'DEC/unbundled/Digital_UNIX/Extended_Math_Library_3.4',
      sources: %w[usr/opt/XMDMAN340/man]

    manual_namespace 'InfoBroker_Server_2.2',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'InfoBroker Server',
      ver: '2.2',
      idir: 'dec/du/unbundled/ibx220',
      odir: 'DEC/unbundled/Digital_UNIX/InfoBroker_Server_2.2',
      sources: %w[usr/share/man/man[38]]

    manual_namespace 'Multimedia_Services_2.4B',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'Multimedia Services',
      ver: '2.4B',
      idir: 'dec/du/unbundled/mme24b',
      odir: 'DEC/unbundled/Digital_UNIX/Multimedia_Services_2.4B',
      sources: %w[usr/opt/MME242/share/man/man[1347]]

    manual_namespace 'MAILbus_400_2.0C',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'MAILbus 400',
      ver: '2.0C',
      idir: 'dec/du/unbundled/mtaa20c',
      odir: 'DEC/unbundled/Digital_UNIX/MAILbus_400_2.0c',
      sources: %w[usr/opt/MTAAMAN202/usr/share/man/man3]

    manual_namespace 'Optical_Storage_Management_1.6',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'Optical Storage Management',
      ver: '1.6',
      idir: 'dec/du/unbundled/osms160',
      odir: 'DEC/unbundled/Digital_UNIX/Optical_Storage_Management_1.6',
      sources: %w[usr/man/man[14578]]

    manual_namespace 'PHIGS_5.1',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'PHIGS',
      ver: '5.1',
      idir: 'dec/du/unbundled/pho510',
      odir: 'DEC/unbundled/Digital_UNIX/PHIGS_5.1',
      sources: %w[usr/man/man3]

    manual_namespace 'POLYCENTER_Intrusion_Detector_1.2A',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'POLYCENTER Intrusion Detector',
      ver: '1.2A',
      idir: 'dec/du/unbundled/ido12a',
      odir: 'DEC/unbundled/Digital_UNIX/POLYCENTER_Intrusion_Detector_1.2A',
      sources: %w[usr/opt/IDOA12A/usr/share/man/man[58]]

    manual_namespace 'POLYCENTER_Security_Compliance_Manager_2.5',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'POLYCENTER Security Compliance Manager',
      ver: '2.5',
      idir: 'dec/du/unbundled/soa250',
      odir: 'DEC/unbundled/Digital_UNIX/POLYCENTER_Security_Compliance_Manager_2.5',
      sources: %w[usr/opt/SOA250/man/man8]

    manual_namespace 'PrintServer_Japanese_5.1',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'PrintServer Japanese',
      ver: '5.1',
      idir: 'dec/du/unbundled/jls510',
      odir: 'DEC/unbundled/Digital_UNIX/PrintServer_Japanese_5.1',
      #sources: %w[usr/i18n/share/ja_JP.deckanji/man/man[18]]
      #sources: %w[xlated/usr/i18n/share/ja_JP.UTF-8/man/man[18]]
      sources: %w[xlated/usr/i18n/share/ja_JP.SJIS/man/man[18]]

    manual_namespace 'SNA_APPC_LU6.2_Programming_3.2',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'SNA APPC LU6.2',
      ver: '3.2',
      idir: 'dec/du/unbundled/snp320',
      odir: 'DEC/unbundled/Digital_UNIX/SNA_APPC_LU6.2_Programming_3.2',
      sources: %w[usr/share/man/man3]

    manual_namespace 'SNA_LUA_Programming_1.0',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'SNA LUA',
      ver: '1.0',
      idir: 'dec/du/unbundled/snalu100',
      odir: 'DEC/unbundled/Digital_UNIX/SNA_LUA_Programming_1.0',
      sources: %w[usr/opt/SNALUA100/usr/man/man3]

    manual_namespace 'SNA_TN3270-C_1.0',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'SNA TN3270-C',
      ver: '1.0',
      idir: 'dec/du/unbundled/tnc100',
      odir: 'DEC/unbundled/Digital_UNIX/SNA_TN3270-C_1.0',
      sources: %w[usr/tn3270c/manpages]

    manual_namespace 'StorageWorks_HSZ40_1.1A',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'StorageWorks HSZ40',
      ver: '1.1A',
      idir: 'dec/du/unbundled/swa11a',
      odir: 'DEC/unbundled/Digital_UNIX/StorageWorks_HSZ40_1.1A',
      sources: %w[usr/opt/SWA11A/usr/share/man/man8]

    manual_namespace 'TeMIP_Framework_3.2A',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'TeMIP Framework',
      ver: '3.2A',
      idir: 'dec/du/unbundled/tfr32a',
      odir: 'DEC/unbundled/Digital_UNIX/TeMIP_Framework_3.2A',
      sources: %w[usr/*/manp]

    manual_namespace 'X.500_3.1',
      vendor_class: Digital_UNIX::V4_0d,
      os: 'X.500',
      ver: '3.1',
      idir: 'dec/du/unbundled/dxd310',
      odir: 'DEC/unbundled/Digital_UNIX/X.500_3.1',
      sources: %w[usr/opt/DXDAMAN310/usr/share/man/man3]
  end

  collection_namespace 'OSF/1' do
    manual_namespace 'DSM_Japanese_1.0E',
      vendor_class: OSF1::V3_2c,
      os: 'DSM Japanese',
      ver: '1.0E',
      idir: 'dec/du/unbundled/jds10e',
      odir: 'DEC/unbundled/OSF:1/DSM_Japanese_1.0E',
      sources: %w[usr/opt/JDS105/man/man1] # ja_JP page also - but is identical to en_US page

    manual_namespace 'F-RJE_1.0',
      vendor_class: OSF1::V3_2c,
      os: 'F-RJE',
      ver: '1.0',
      odir: 'DEC/unbundled/OSF:1/F-RJE_1.0',
      idir: 'dec/du/unbundled/fjr100',
      # have to use OSF1 to convert deckanji encoding to something we can cope with
      #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man*]
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man*] # iconv giving ¥ instead of \
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.eucJP/man/man*]
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.ISO-2022-JP/man/man*]
      sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man*]

    manual_namespace 'PrintServer_5.1',
      vendor_class: OSF1::V3_2c,
      os: 'PrintServer',
      ver: '5.1',
      idir: 'dec/du/unbundled/lps520',
      odir: 'DEC/unbundled/OSF:1/PrintServer_5.1',
      sources: %w[usr/opt/LPS/man/*.[18]]

    manual_namespace 'SNA_3270_Datastream_Programming_Japanese_1.0',
      vendor_class: OSF1::V3_2c,
      os: 'SNA 3270 Datastream Japanese',
      ver: '1.0',
      idir: 'dec/du/unbundled/sjd100',
      odir: 'DEC/unbundled/OSF:1/SNA_3270_Datastream_Programming_Japanese_1.0',
      #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
      sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]

    manual_namespace 'SNA_Printer_Emulator_Japanese_1.0',
      vendor_class: OSF1::V3_2c,
      os: 'SNA Printer Emulator Japanese',
      ver: '1.0',
      idir: 'dec/du/unbundled/sjp100',
      odir: 'DEC/unbundled/OSF:1/SNA_Printer_Emulator_Japanese_1.0',
      #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[18]]
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[18]]
      sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[18]]

    manual_namespace 'SNA_RJE_1.0',
      vendor_class: OSF1::V3_2c,
      os: 'SNA RJE',
      ver: '1.0',
      idir: 'dec/du/unbundled/sjr100',
      odir: 'DEC/unbundled/OSF:1/SNA_RJE_1.0',
      #sources: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
      #sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
      sources: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]

    manual_namespace 'SNA_DECwindows_3270_Emulator_Japanese_2.1A',
      vendor_class: OSF1::V3_2c,
      os: 'SNA DECwindows 3270 Emulator Japanese',
      ver: '2.1A',
      idir: 'dec/du/unbundled/snja21a',
      odir: 'DEC/unbundled/OSF:1/SNA_DECwindows_3270_Emulator_Japanese_2.1A',
      sources: %w[usr/opt/*/usr/i18n/usr/share/man/man[18]]

    manual_namespace 'Watchdog_Autopilot_2.1',
      vendor_class: OSF1::V3_2c,
      os: 'Watchdog Autopilot',
      ver: '2.1',
      idir: 'dec/du/unbundled/wdx210',
      odir: 'DEC/unbundled/OSF:1/Watchdog_Autopilot_2.1',
      sources: %w[usr/share/man/man[58]]
  end

  collection_namespace 'Tru64' do
    manual_namespace 'ACMSxp_3.2A',
      vendor_class: Tru64::V4_0f,
      os: 'ACMSxp',
      ver: '3.2A',
      idir: 'dec/du/unbundled/acm32a', # TODO uses rsml/sml macros
      odir: 'DEC/unbundled/Tru64/ACMSxp_3.2A',
      sources: %w[usr/opt/ACMSXPV32A/man/man[138]]

    manual_namespace 'BASEstar_Open_Server_3.2',
      vendor_class: Tru64::V4_0f,
      os: 'BASEstar Open Server',
      ver: '3.2',
      idir: 'dec/du/unbundled/bst320',
      odir: 'DEC/unbundled/Tru64/BASEstar_Open_Server_3.2',
      sources: %w[
        usr/opt/BCF220/man/man1
        usr/opt/bstman320/man/man[13]
        usr/share/man/man3
      ]

    manual_namespace 'C++_6.2',
      vendor_class: Tru64::V4_0f,
      entry_page: 'index.html',
      os: 'C++',
      ver: '6.2',
      idir: 'dec/du/unbundled/cxx620',
      odir: 'DEC/unbundled/Tru64/C++_6.2',
      sources: %w[usr/share/doclib/cplusplus/*.htm] do |t|
        assets_task %w(*.gif *.ps *.pdf), t[:idir], t[:odir], cut_dirs: 4
        task all: [:assets]
      end

    manual_namespace 'COBOL_2.6',
      vendor_class: Tru64::V4_0f,
      os: 'COBOL',
      ver: '2.6',
      idir: 'dec/du/unbundled/dca260',
      odir: 'DEC/unbundled/Tru64/COBOL_2.6',
      sources: %w[usr/lib/cmplrs/cobol_260]

    manual_namespace 'DCE_3.1',
      vendor_class: Tru64::V4_0f,
      os: 'DCE',
      ver: '3.1',
      idir: 'dec/du/unbundled/dce310', # TODO wth is up with the section 1 pages (others - some are "normal" though - 3rpc, 3sec are)
      odir: 'DEC/unbundled/Tru64/DCE_3.1',
      sources: %w[usr/opt/DCE310/man/man[1-8]]

    manual_namespace 'DECnet-Plus_5.0',
      vendor_class: Tru64::V4_0f,
      os: 'DECnet-Plus',
      ver: '5.0',
      idir: 'dec/du/unbundled/dna500',
      odir: 'DEC/unbundled/Tru64/DECnet-Plus_5.0',
      sources: %w[usr/opt/DNA500/share/man/man[158]]

    manual_namespace 'DECnet_WAN_Support_3.1',
      vendor_class: Tru64::V4_0f,
      os: 'DECnet WAN Support',
      ver: '3.1',
      idir: 'dec/du/unbundled/xxa310',
      odir: 'DEC/unbundled/Tru64/DECnet_WAN_Support_3.1',
      sources: %w[usr/opt/[WX]?A310/share/man/man[123478]]

    manual_namespace 'Diskless_Driver_2.01',
      vendor_class: Tru64::V4_0f,
      os: 'Diskless Driver',
      ver: '2.01',
      idir: 'dec/du/unbundled/ddu201',
      odir: 'DEC/unbundled/Tru64/Diskless_Driver_2.01',
      sources: %w[usr/man/man[78]]

    manual_namespace 'FORTRAN_5.3',
      vendor_class: Tru64::V4_0f,
      os: 'FORTRAN',
      ver: '5.3',
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

    manual_namespace 'FUSE_4.2/en_US',
      vendor_class: Tru64::V4_0f,
      os: 'FUSE',
      ver: '4.2',
      idir: 'dec/du/unbundled/fus420',
      odir: 'DEC/unbundled/Tru64/FUSE_4.2/en_US',
      sources: %w[usr/opt/FUS420/man/man1]

    manual_namespace 'FUSE_4.2/ja_JP', # ja_JP pages also
      vendor_class: Tru64::V4_0f,
      os: 'FUSE',
      ver: '4.2',
      idir: 'dec/du/unbundled/fus420',
      odir: 'DEC/unbundled/Tru64/FUSE_4.2/ja_JP',
      sources: %w[usr/opt/FUS420/man/ja_JP.SJIS/man1]

    manual_namespace 'Micro_Focus_COBOL_4.1B',
      vendor_class: Tru64::V4_0f,
      os: 'Micro Focus COBOL',
      ver: '4.1B',
      idir: 'dec/du/unbundled/mfc41b',
      odir: 'DEC/unbundled/Tru64/Micro_Focus_COBOL_4.1B',
      sources: %w[usr/lib/cmplrs/cob_413]

    manual_namespace 'Open3D_4.96',
      vendor_class: Tru64::V4_0f,
      os: 'Open3D',
      ver: '4.96',
      idir: 'dec/du/unbundled/o3d496', # TODO 3gl pages have no section regex match
      odir: 'DEC/unbundled/Tru64/Open3D_4.96',
      sources: %w[usr/man/man[13]]

    manual_namespace 'Pascal_5.7',
      vendor_class: Tru64::V4_0f,
      os: 'Pascal',
      ver: '5.7',
      idir: 'dec/du/unbundled/dpo570',
      odir: 'DEC/unbundled/Tru64/Pascal_5.7',
      sources: %w[usr/lib/cmplrs/pc_570]

    manual_namespace 'Parallel_Software_Environment_1.9',
      vendor_class: Tru64::V4_0f,
      os: 'Parallel Software Environment',
      ver: '1.9',
      idir: 'dec/du/unbundled/pse190',
      odir: 'DEC/unbundled/Tru64/Parallel_Software_Environment_1.9',
      sources: %w[usr/opt/PVM190/man/man[13]]

    manual_namespace 'Powerstorm_4D_5.0B',
      vendor_class: Tru64::V4_0f,
      os: 'Powerstorm 4D',
      ver: '5.0B',
      idir: 'dec/du/unbundled/prs50b',
      odir: 'DEC/unbundled/Tru64/Powerstorm_4D_5.0B',
      sources: %w[usr/man/man3]

    manual_namespace 'SNA_APPC_LU6.2_Programming_4.0',
      vendor_class: Tru64::V4_0f,
      os: 'SNA APPC LU6.2',
      ver: '4.0',
      idir: 'dec/du/unbundled/snp400',
      odir: 'DEC/unbundled/Tru64/SNA_APPC_LU6.2_Programming_4.0',
      sources: %w[usr/share/man/man3]
  end

  collection_namespace 'Ultrix' do
    manual_namespace 'C_1.0/VAX',
      vendor_class: Ultrix::V4_2_0, # REVIEW correct?
      os: 'Ultrix C',
      ver: '1.0 VAX',
      idir: 'dec/ultrix/unbundled/vax_c_1.0',
      odir: 'DEC/unbundled/Ultrix/C_1.0/VAX',
      sources: %w[usr/man/man1]

    manual_namespace 'DECnet_3.0/VAX',
      vendor_class: Ultrix::V4_2_0,
      os: 'Ultrix DECnet',
      ver: '3.0 VAX',
      idir: 'dec/ultrix/unbundled/decnet_vax_3.0',
      odir: 'DEC/unbundled/Ultrix/DECnet_3.0/VAX',
      sources: %w[usr/man/man[1238]]

    manual_namespace 'DECnet_SNA_1.0',
      vendor_class: Ultrix::V4_2_0, # REVIEW correct?
      os: 'DECnet SNA',
      ver: '1.0',
      idir: 'dec/ultrix/unbundled/decnetsna_1.0',
      odir: 'DEC/unbundled/Ultrix/DECnet_SNA_1.0',
      sources: %w[usr/man/man1]

    manual_namespace 'FORTRAN_1.0/mips',
      vendor_class: Ultrix::V4_2_0, # REVIEW correct?
      os: 'Ultrix FORTRAN',
      ver: '1.0 RISC',
      idir: 'dec/ultrix/unbundled/fortran_mips_1.0',
      odir: 'DEC/unbundled/Ultrix/FORTRAN_1.0/mips',
      sources: %w[usr/man/man[13]]

    manual_namespace 'SQL_1.0/mips',
      vendor_class: Ultrix::V4_2_0, # REVIEW correct?
      os: 'Ultrix SQL',
      ver: '1.0 RISC',
      idir: 'dec/ultrix/unbundled/sql_mips_1.0',
      odir: 'DEC/unbundled/Ultrix/SQL_1.0/mips',
      sources: %w[usr/man/man[18]]

  end
end
