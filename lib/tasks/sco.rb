collectionNamespace 'SCO' do
  collectionNamespace 'unbundled' do
    manualNamespace 'LLI_3.1.0j',
      vendor_class: OpenDesktop,
      idir: 'sco/unbundled/lli-r3.1.0j',
      odir: 'SCO/unbundled/LLI_3.1.0j',
      sources: %w[usr/man/cat.*]
    manualNamespace 'TCPIP_1.2.0i',
      vendor_class: OpenDesktop,
      idir: 'sco/unbundled/tcpip-1.2.0i',
      odir: 'SCO/unbundled/TCPIP_1.2.0i',
      sources: %w[usr/man/cat.*]
  end

  collectionNamespace 'OpenDesktop' do
    manualNamespace '1.0.0y',
      vendor_class: OpenDesktop::V1_0_0y,
      idir: 'sco/odt/1.0.0y',
      odir: 'SCO/OpenDesktop/1.0.0y',
      sources: %w[usr/man/cat.*]
    manualNamespace '1.1.0',
      vendor_class: OpenDesktop::V1_1_0,
      idir: 'sco/odt/1.1.0',
      odir: 'SCO/OpenDesktop/1.1.0',
      sources: %w[usr/man/cat.*]
    manualNamespace '1.1.1g',
      vendor_class: OpenDesktop::V1_1_1g,
      idir: 'sco/odt/1.1.1-update-g',
      odir: 'SCO/OpenDesktop/1.1.1g',
      sources: %w[usr/man/cat.*]
    manualNamespace 'X11R4-EFS-4.1.1b',
      vendor_class: OpenDesktop,
      idir: 'sco/odt/x11r4-efs-r4.1.1b',
      odir: 'SCO/OpenDesktop/X11R4-EFS-4.1.1b',
      sources: %w[usr/man/cat.*]
    manualNamespace '3.0.0',
      vendor_class: OpenDesktop,
      idir: 'sco/odt/3.0.0',
      odir: 'SCO/OpenDesktop/3.0.0',
      sources: %w[man/cat.*]
  end

  collectionNamespace 'Xenix' do
    manualNamespace '2.3.4',
      vendor_class: Xenix,
      odir: 'SCO/Xenix/2.3.4',
      sources: %w[
        usr/man/cat.*
      ]
    manualNamespace '2.3.4g',
      vendor_class: Xenix,
      odir: 'SCO/Xenix/2.3.4g',
      sources: %w[
        man/cat.*
      ]
  end
end
