# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  collection_namespace 'DG/UX' do
    manual_namespace 'FTAM_3.20',
      vendor_class: DG_UX::V4_30, # REVIEW may not really be V4_30 but the nroff indent matches so section detection works
      os: 'DG/UX FTAM',
      ver: '3.20',
      idir: 'dg/unbundled/dgux/ftam_3.20',
      odir: 'DG/unbundled/DG:UX/FTAM_3.20/',
      sources: %w[catman/ftam_man/man1]

    manual_namespace 'MicroFocus_COBOL_3.1.39',
      vendor_class: DG_UX::V4_30, # REVIEW is 5.4.2 but the nroff indent matches so section detection works
      os: 'Micro Focus COBOL',
      ver: '3.1.39',
      idir: 'dg/unbundled/dgux/mfcobol_3.11',
      odir: 'DG/unbundled/DG:UX/MicroFocus_COBOL_3.1.39/',
      sources: %w[docs]

    manual_namespace 'MicroFocus_COBOL_3.2.20',
      vendor_class: DG_UX::V4_30, # REVIEW is 5.4.3 but the nroff indent matches so section detection works
      os: 'Micro Focus COBOL',
      ver: '3.2.20',
      idir: 'dg/unbundled/dgux/mfcobol_3.2',
      odir: 'DG/unbundled/DG:UX/MicroFocus_COBOL_3.2.20/',
      sources: %w[docs]

    manual_namespace 'MicroFocus_COBOL_4.0.5',
      vendor_class: DG_UX::V4_30, # REVIEW is 5.4R3.10 but the nroff indent matches so section detection works
      os: 'Micro Focus COBOL',
      ver: '4.0.5',
      idir: 'dg/unbundled/dgux/mfcobol_4.0',
      odir: 'DG/unbundled/DG:UX/MicroFocus_COBOL_4.0.5/',
      sources: %w[docs]

    manual_namespace 'X.400_3.20',
      vendor_class: DG_UX::V4_30, # REVIEW may not really be V4_30 but the nroff indent matches so section detection works
      os: 'DG/UX X.400',
      ver: '3.20',
      idir: 'dg/unbundled/dgux/x.400_3.20',
      odir: 'DG/unbundled/DG:UX/X.400_3.20/',
      sources: %w[catman/man1]
  end
end
