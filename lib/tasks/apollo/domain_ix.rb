collectionNamespace 'AUX' do
  manualNamespace 'SR8.0',
    # TODO usr/man/docs
    vendor_class: DomainIX::SR8_0,
    idir: 'apollo/domain_os/8.0',
    odir: 'Apollo/AUX/SR8.0',
    sources: %w[ aux/usr/man/man[1-8] ]
  manualNamespace 'SR8.1_update',
    # REVIEW this is just the release notes
    vendor_class: DomainIX::SR8_1,
    idir: 'apollo/domain_os/8.1_upd',
    odir: 'Apollo/AUX/SR8.1_update',
    sources: %w[ aux/doc ]
end

collectionNamespace 'DomainIX' do
  manualNamespace 'SR9.0',
    vendor_class: DomainIX::SR9_0,
    idir: 'apollo/domain_os/9.0',
    odir: 'Apollo/DomainIX/SR9.0',
    sources: %w[
        bsd4.2/usr/man/man[1-8]
        sys5/usr/catman/?_man/man[1-8]
      ]
  manualNamespace 'SR9.2.3',
    vendor_class: DomainIX::SR9_2_3,
    idir: 'apollo/domain_os/9.2.3',
    odir: 'Apollo/DomainIX/SR9.2.3',
    sources: %w[
        bsd4.2/usr/man/man[1-8]
        sys5/usr/catman/?_man/man[1-8]
      ]
  manualNamespace 'SR9.5',
    vendor_class: DomainIX::SR9_5,
    idir: 'apollo/domain_os/9.5',
    odir: 'Apollo/DomainIX/SR9.5',
    # REVIEW bsd cat/man mostly identical, but not entirely?
    sources: %w[
        bsd4.2/usr/man/cat[1-8]
        bsd4.2/usr/man/man[1-8]
        sys5/usr/catman/?_man/man[1-8]
      ]
end
