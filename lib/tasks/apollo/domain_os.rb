# frozen_string_literal: true
#

collection_namespace 'Domain/OS' do
  # REVIEW extra content (install, dex, systest, etc.), multiple releases
  manual_namespace 'SR10.0',
                  vendor_class: DomainOS::SR10_0,
                  idir: 'apollo/domain_os/10.0',
                  odir: 'Apollo/Domain:OS/SR10.0',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  manual_namespace 'SR10.1',
                  vendor_class: DomainOS::SR10_1,
                  idir: 'apollo/domain_os/10.1',
                  odir: 'Apollo/Domain:OS/SR10.1',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  manual_namespace 'SR10.1_PSK4',
                  vendor_class: DomainOS::SR10_1,
                  idir: 'apollo/domain_os/10.1_psk4',
                  odir: 'Apollo/Domain:OS/SR10.1_PSK4',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  manual_namespace 'SR10.2',
                  vendor_class: DomainOS::SR10_2,
                  idir: 'apollo/domain_os/10.2',
                  odir: 'Apollo/Domain:OS/SR10.2',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  manual_namespace 'SR10.3',
                  vendor_class: DomainOS::SR10_3,
                  idir: 'apollo/domain_os/10.3',
                  odir: 'Apollo/Domain:OS/SR10.3',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  # TODO (what though?) unbundled products for sure (lisp)
  manual_namespace 'SR10.3.5',
                  vendor_class: DomainOS::SR10_3_5,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/Domain:OS/SR10.3.5',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/X11/man/cat*
                  ]

  # TODO (what though?) unbundled products for sure (lisp)
  manual_namespace 'SR10.4',
                  vendor_class: DomainOS::SR10_4,
                  idir: 'apollo/domain_os/10.4',
                  odir: 'Apollo/Domain:OS/SR10.4',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/softbench/man/man*
                    usr/X11/man/cat*
                  ]

  # TODO (what though?) unbundled products probably (pascal, fortran, etc.)
  manual_namespace 'SR10.4.1',
                  vendor_class: DomainOS::SR10_4_1,
                  idir: 'apollo/domain_os/10.4.1',
                  odir: 'Apollo/Domain:OS/SR10.4.1',
                  sources: %w[
                    sys/help/*
                    bsd4.3/usr/man/cat[1-8]
                    sys5/usr/catman/?_man/man[1-8]
                    usr/apollo/man/mana
                    usr/new/mann
                    usr/softbench/man/man*
                    usr/X11/man/cat*
                  ]
end
