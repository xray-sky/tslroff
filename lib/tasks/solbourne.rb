collectionNamespace 'Solbourne' do
  collectionNamespace 'OS-MP' do
    manualNamespace '4.1A',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/4.1A',
      odir: 'Solbourne/OS-MP/4.1A',
      sources: %w[share/man/man[1-8]]
    manualNamespace '4.1A3',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/4.1A3',
      odir: 'Solbourne/OS-MP/4.1A3',
      sources: %w[share/man/man[1-8]]
    manualNamespace '4.1C',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/4.1C',
      odir: 'Solbourne/OS-MP/4.1C',
      sources: %w[share/man/man[1-8]]
    manualNamespace 'OpenWindows_3.0',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/unbundled/ow3.0',
      odir: 'Solbourne/unbundled/OpenWindows_3.0',
      sources: %w[man[1-8]]
    # REVIEW is actually X11R5 ?? from pete/X.3.Q150
    manualNamespace 'X11R3',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/unbundled/x11r3',
      odir: 'Solbourne/unbundled/X11R3',
      sources: %w[man[13]]
    manualNamespace 'X11R5',
      vendor_class: OS_MP,
      idir: 'solbourne/os-mp/unbundled/x11r5',
      odir: 'Solbourne/unbundled/X11R5',
      sources: %w[man[13]]
  end
end
