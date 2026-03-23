collectionNamespace 'Aegis' do
  manualNamespace 'SR7.B',
    vendor_class: Aegis::SR7_B,
    idir: 'apollo/domain_os/7.b',
    odir: 'Apollo/Aegis/SR7.B',
    sources: %w[sys/help/*]
  manualNamespace 'SR8.0',
    vendor_class: Aegis::SR8_0,
    idir: 'apollo/domain_os/8.0',
    odir: 'Apollo/Aegis/SR8.0',
    sources: %w[sys/help/*]
  manualNamespace 'SR8.1_update',
    vendor_class: Aegis::SR8_1,
    idir: 'apollo/domain_os/8.1_upd',
    odir: 'Apollo/Aegis/SR8.1_update',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.0',
    vendor_class: Aegis::SR9_0,
    idir: 'apollo/domain_os/9.0',
    odir: 'Apollo/Aegis/SR9.0',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.0.020',
    vendor_class: Aegis::SR9_0,
    # REVIEW this is just the release notes
    idir: 'apollo/domain_os/9.0.020/sr9.0.020/',
    odir: 'Apollo/Aegis/SR9.0.020',
    sources: %w[ doc ]
  manualNamespace 'SR9.5.1',
    vendor_class: Aegis::SR9_5,
    idir: 'apollo/domain_os/9.5.1',
    odir: 'Apollo/Aegis/SR9.5.1',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.6',
    # TODO (what though?) unbundled products for sure (lisp)
    vendor_class: Aegis::SR9_6,
    idir: 'apollo/domain_os/9.6',
    odir: 'Apollo/Aegis/SR9.6',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.7',
    vendor_class: Aegis::SR9_7,
    idir: 'apollo/domain_os/9.7',
    odir: 'Apollo/Aegis/SR9.7',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.7.1',
    vendor_class: Aegis::SR9_7_1,
    idir: 'apollo/domain_os/9.7.1',
    odir: 'Apollo/Aegis/SR9.7.1',
    sources: %w[sys/help/*]
  manualNamespace 'SR9.7.5',
    # TODO (what though?) unbundled products for sure (lisp)
    vendor_class: Aegis::SR9_7_5,
    idir: 'apollo/domain_os/9.7.5',
    odir: 'Apollo/Aegis/SR9.7.5',
    sources: %w[sys/help/*]
end
