# frozen_string_literal: true
#

require_relative 'motorola/sysv'

collection_namespace 'Motorola' do
  collection_namespace 'SystemV' do
    collection_namespace '88k' do
      manual_namespace 'MultiPersonal_C832.22',
        vendor_class: Motorola_SysV,
        os: 'MultiPersonal System',
        ver: 'R32V2',
        idir: 'motorola/sysv-88k/multipersonal_r32v2',
        odir: 'Motorola/SVR3/88k/MultiPersonal_System_C832.22',
        sources: %w[usr/catman/*_man/man*]

      manual_namespace 'UZ88.01',
        vendor_class: Motorola_SysV,
        os: 'Motorola System V 88k',
        ver: 'Release 3.2 Version 1.2C',
        idir: 'motorola/sysv-88k/r3.2v1.2c_bos_obj',
        odir: 'Motorola/SVR3/88k/R3.1_V2.1C_UZ88.01',
        sources: %w[usr/catman/?_man/man*]

      manual_namespace 'FH40.42',
        vendor_class: Motorola_SysV,
        os: 'Motorola System V 88k',
        ver: 'Release 4 Version 4.2',
        idir: 'motorola/sysv-88k/R4/FH40.42',
        odir: 'Motorola/SVR4/88k/FH40.42',
        sources: %w[usr/src/man/man[1-7]]

      manual_namespace 'FH40.43',
        vendor_class: Motorola_SysV,
        os: 'Motorola System V 88k',
        ver: 'Release 4 Version 4.3',
        idir: 'motorola/sysv-88k/R4/FH40.43',
        odir: 'Motorola/SVR4/88k/FH40.43',
        sources: %w[
          usr/src/man/man[1-7]
          usr/src/ddi_man/man[1-5]
        ]
    end
  end

  collection_namespace 'unbundled' do
    collection_namespace 'Commercial_Network_Extension' do
      manual_namespace 'NV01.02',
        vendor_class: Motorola_SysV,
        os: 'Commercial Networking Extensions',
        ver: '1.02',
        idir: 'motorola/unbundled/commercial_net_ext_nv01.02',
        odir: 'Motorola/unbundled/Commercial_Networking_Extensions_NV01.02',
        sources: %w[
          usr/catman/?_man/man[147]*
          usr/catman/packages/?_man/man[147]*
        ]
    end

    collection_namespace 'DeltaWindows' do
      manual_namespace 'XV40.43',
        vendor_class: Motorola_SysV,
        os: 'DeltaWindows',
        ver: '1.3.3 Release 4 Version 4.3',
        idir: 'motorola/unbundled/deltawindows_1.3.3',
        odir: 'Motorola/unbundled/DeltaWindows_X11_1.3.3_XV40.43',
        sources: %w[usr/src/graphics/*/*man/man[13]*]
    end

    collection_namespace 'Motif' do
      manual_namespace 'XV40.43',
        vendor_class: Motorola_SysV,
        os: 'DeltaWindows Motif',
        ver: '1.3.1 Release 4 Version 4.2',
        idir: 'motorola/unbundled/deltawindows_motif_1.3.1',
        odir: 'Motorola/unbundled/DeltaWindows_Motif_1.3.1_XV40.42',
        sources: %w[usr/src/graphics/osf/man/man[13]*]
    end

    collection_namespace 'NSE' do
      manual_namespace 'NT32.32',
        vendor_class: Motorola_SysV,
        os: 'Network Services Extension',
        ver: 'Release 3.2 Version 3.2',
        idir: 'motorola/unbundled/nse_nt32.32',
        odir: 'Motorola/unbundled/Network_Services_Extension_NT32.32',
        sources: %w[usr/catman/?_man/man[14]*]
    end
  end

  collection_namespace 'thirdparty' do
    collection_namespace 'NCD' do
      manual_namespace 'NCDware_3.1',
        vendor_class: Motorola_SysV,
        os: 'SVR4 88k NCDware',
        ver: '3.1',
        idir: 'motorola/thirdparty/ncdware_3.1',
        odir: 'Motorola/thirdparty/NCD/NCDware_3.1_R40_M88k',
        sources: %w[NCD/root.?/usr/share/ncd_man/cat*]
    end
  end
end
