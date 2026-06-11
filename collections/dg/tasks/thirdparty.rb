# frozen_string_literal: true
#

collection_namespace 'thirdparty' do
  collection_namespace 'DG/UX' do
    manual_namespace 'MicroFocus/COBOL_App_Server_4.1',
      vendor_class: DG_UX::V4_30, # REVIEW may not really be V4_30 but the nroff indent matches so section detection works
      os: 'Micro Focus COBOL Application Server',
      ver: '4.1',
      idir: 'dg/thirdparty/dgux/mfcobol_appsvr_4.1',
      odir: 'DG/thirdparty/DG:UX/MicroFocus/COBOL_Application_Server_4.1.10/',
      sources: %w[cobtmp/docs]

    manual_namespace 'MicroFocus/Object_COBOL_4.1',
      vendor_class: DG_UX::V4_30, # REVIEW may not really be V4_30 but the nroff indent matches so section detection works
      os: 'Micro Focus Object COBOL',
      ver: '4.1',
      idir: 'dg/thirdparty/dgux/mf_objcobol_4.1',
      odir: 'DG/thirdparty/DG:UX/MicroFocus/Object_COBOL_4.1.10/',
      sources: %w[cobtmp/docs]

    manual_namespace 'UX/RPM_4.11',
      vendor_class: DG_UX::V4_30, # REVIEW may not really be V4_30 but the nroff indent matches so section detection works
      os: 'UX/RPM',
      ver: '4.11',
      idir: 'dg/thirdparty/dgux/uxrpm_4.11',
      odir: 'DG/thirdparty/DG:UX/UX:RPM_3.10/', # REVIEW tape says 4.11, man says 3.10
      sources: %w[
        rpm/man
        rpm/help*
      ]
  end
end
