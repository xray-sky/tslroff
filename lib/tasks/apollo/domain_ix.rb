# frozen_string_literal: true
#

collection_namespace 'AUX' do
  # TODO usr/man/docs
  manual_namespace 'SR8.0',
                  vendor_class: AUX::SR8_0,
                  idir: 'apollo/domain_os/8.0',
                  odir: 'Apollo/AUX/SR8.0',
                  sources: %w[aux/usr/man/man[1-8]]

  # REVIEW this is just the release notes
  manual_namespace 'SR8.1_update',
                  vendor_class: AUX::SR8_1,
                  idir: 'apollo/domain_os/8.1_upd',
                  odir: 'Apollo/AUX/SR8.1_update',
                  sources: %w[aux/doc]
end

collection_namespace 'Domain/IX' do
  manual_namespace 'SR9.0',
                  vendor_class: DomainIX::SR9_0,
                  idir: 'apollo/domain_os/9.0',
                  odir: 'Apollo/Domain:IX/SR9.0',
                  sources: %w[
                    bsd4.2/usr/man/man[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                  ]

  manual_namespace 'SR9.2.3',
                  vendor_class: DomainIX::SR9_2_3,
                  idir: 'apollo/domain_os/9.2.3',
                  odir: 'Apollo/Domain:IX/SR9.2.3',
                  sources: %w[
                    bsd4.2/usr/man/man[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                  ]

  # REVIEW bsd cat/man mostly identical, but not entirely?
  manual_namespace 'SR9.5',
                  vendor_class: DomainIX::SR9_5,
                  idir: 'apollo/domain_os/9.5',
                  odir: 'Apollo/Domain:IX/SR9.5',
                  sources: %w[
                    bsd4.2/usr/man/cat[1-8]
                    bsd4.2/usr/man/man[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                  ]
end
