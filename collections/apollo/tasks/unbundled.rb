# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  manual_namespace 'ada_1.0',
    vendor_class: DomainOS,
    os: 'DOMAIN Ada',
    ver: '1.0',
    idir: 'apollo/domain_os/unbundled/ada_1.0',
    odir: 'Apollo/unbundled/ada_1.0',
    sources: %w[
      doc
      bsd4.2/usr/man/man[13]
    ]

  manual_namespace 'cc_4.16',
    vendor_class: DomainOS,
    os: 'DOMAIN C',
    ver: '4.16',
    idir: 'apollo/domain_os/unbundled/cc_4.16',
    odir: 'Apollo/unbundled/cc_4.16',
    sources: %w[
      doc
      sys/help
    ] # TODO + help files missing??
  manual_namespace 'cc_4.65',
    vendor_class: DomainOS,
    os: 'DOMAIN C',
    ver: '4.65',
    idir: 'apollo/domain_os/unbundled/cc_4.65',
    odir: 'Apollo/unbundled/cc_4.65',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'cc_5.5',
    vendor_class: DomainOS,
    os: 'DOMAIN C',
    ver: '5.5',
    idir: 'apollo/domain_os/unbundled/cc_5.5',
    odir: 'Apollo/unbundled/cc_5.5',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'cc_6.6',
    vendor_class: DomainOS,
    os: 'Domain C',
    ver: '6.6',
    idir: 'apollo/domain_os/unbundled/cc_6.6',
    odir: 'Apollo/unbundled/cc_6.6',
    sources: %w[
      doc/apollo
      ri.apollo.cc.v.6.6.m/sys/help
    ] # m/mpx HELP files not identical, but nothing dn10k specific
  manual_namespace 'cc_6.7p',
    vendor_class: DomainOS,
    os: 'Domain/C',
    ver: '6.7P',
    idir: 'apollo/domain_os/unbundled/cc_6.7p',
    odir: 'Apollo/unbundled/cc_6.7p',
    sources: %w[
      doc/apollo
      ri.apollo.cc.v.6.7.p/help
    ] # p/pmx HELP files identical
  manual_namespace 'cc_6.9',
    vendor_class: DomainOS,
    os: 'Domain/C',
    ver: '6.9',
    idir: 'apollo/domain_os/unbundled/domain_c_6.9',
    odir: 'Apollo/unbundled/cc_6.9',
    sources: %w[
      doc/apollo
      ri.apollo.cc.v.6.9.m/help
      ri.apollo.cc.v.6.9.m/bsd4.3/usr/man/cat1
      ri.apollo.cc.v.6.9.m/sys5.3/usr/catman/u_man/man1
    ]

  manual_namespace 'coregfx_sr9.5',
    vendor_class: DomainOS,
    os: 'DOMAIN Core GFX',
    ver: 'SR9.5',
    idir: 'apollo/domain_os/unbundled/coregfx_sr9.5',
    odir: 'Apollo/unbundled/coregfx_sr9.5',
    sources: %w[doc]

  manual_namespace 'dialogue_1.0',
    vendor_class: DomainOS,
    os: 'DOMAIN/Dialogue',
    ver: '1.0',
    idir: 'apollo/domain_os/unbundled/dialogue_1.0',
    odir: 'Apollo/unbundled/dialogue_1.0',
    sources: %w[
      dialogue/doc
      dialoguepr/sys/help
    ]

  manual_namespace 'dpak_2.1',
    vendor_class: DomainOS,
    os: 'DPAK',
    ver: '2.1',
    idir: 'apollo/domain_os/unbundled/dpak_2.1',
    odir: 'Apollo/unbundled/dpak_2.1',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'dpak_3.0',
    vendor_class: DomainOS,
    os: 'DPAK',
    ver: '3.0',
    idir: 'apollo/domain_os/unbundled/dpak_3.0',
    odir: 'Apollo/unbundled/dpak_3.0',
    sources: %w[
      doc/apollo
      ri.apollo.dpak.v.5.0/sys/help
      ri.apollo.dpak.v.3.0/bsd4.3/usr/man/cat1
      ri.apollo.dpak.v.3.0/sys5.3/usr/catman/u_man/man1
    ]

  manual_namespace 'dpci_5.0',
    vendor_class: DomainOS,
    os: 'DPCI',
    ver: '5.0',
    idir: 'apollo/domain_os/unbundled/dpci_5.0',
    odir: 'Apollo/unbundled/dpci_5.0',
    sources: %w[
      doc/apollo
      ri.apollo.dpci.v.5.0/sys/help
    ]

  manual_namespace 'dpcc_3.5',
    vendor_class: DomainOS,
    os: 'DPCC',
    ver: '3.5',
    idir: 'apollo/domain_os/10.3.5',
    odir: 'Apollo/unbundled/dpcc_3.5',
    sources: %w[sys/help/dpcc*.hlp] # TODO + doc/*release_notes

  manual_namespace 'dsee_3.2',
    vendor_class: DomainOS,
    os: 'DSEE',
    ver: '3.2',
    idir: 'apollo/domain_os/unbundled/dsee_3.2',
    odir: 'Apollo/unbundled/dsee_3.2',
    sources: %w[help/*] # TODO + doc/*release_notes
  manual_namespace 'dsee_3.3',
    vendor_class: DomainOS,
    os: 'DSEE',
    ver: '3.3',
    idir: 'apollo/domain_os/unbundled/dsee_3.3',
    odir: 'Apollo/unbundled/dsee_3.3',
    sources: %w[
      help/*
      bsd4.3/usr/man/cat1
      sys5.3/usr/catman/u_man/man1
    ] # TODO + doc/*release_notes

  manual_namespace 'concurrent_ftn_1.0p',
    vendor_class: DomainOS,
    os: 'HP Concurrent FORTRAN',
    ver: '1.0P',
    idir: 'apollo/domain_os/unbundled/concurrent_ftn_1.0p',
    odir: 'Apollo/unbundled/concurrent_ftn_1.0p',
    sources: %w[
      doc/apollo
      ri.apollo.hpcf.v.1.0.p/sys/help
      ri.apollo.hpcf.v.1.0.p/sys5.3/usr/catman/u_man/man1
    ] # TODO + doc/*release_notes
  manual_namespace 'ftn_sr8.1',
    vendor_class: DomainOS,
    os: 'DOMAIN FORTRAN',
    ver: 'SR8.1',
    idir: 'apollo/domain_os/unbundled/ftn_sr8.1/ftn',
    odir: 'Apollo/unbundled/ftn_sr8.1',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'ftn_10.7p',
    vendor_class: DomainOS,
    os: 'Domain FORTRAN',
    ver: '10.7P',
    idir: 'apollo/domain_os/unbundled/ftn_10.7p',
    odir: 'Apollo/unbundled/ftn_10.7p',
    sources: %w[
      doc/apollo
      ri.apollo.ftn.v.10.7.p/help
    ]
  manual_namespace 'ftn_10.9',
    vendor_class: DomainOS,
    os: 'Domain FORTRAN',
    ver: '10.9',
    idir: 'apollo/domain_os/unbundled/f77_10.9',
    odir: 'Apollo/unbundled/ftn_10.9',
    sources: %w[
      doc/apollo
      ri.apollo.ftn.v.10.9.m/help
      ri.apollo.ftn.v.10.9.m/bsd4.3/usr/man/cat1
      ri.apollo.ftn.v.10.9.m/sys5.3/usr/catman/u_man/man1
    ]

  manual_namespace 'gmr3d_3.1',
    vendor_class: DomainOS,
    os: 'Domain GMR3D',
    ver: '3.1',
    idir: 'apollo/domain_os/unbundled/gmr3d_2.7', # REVIEW ??
    odir: 'Apollo/unbundled/gmr3d_3.1',
    sources: %w[doc/apollo]

  manual_namespace 'gpio_sr9.6.1',
    vendor_class: DomainOS,
    os: 'GPI/O',
    ver: 'SR9.6.1',
    idir: 'apollo/domain_os/unbundled/gpio_9.6.1',
    odir: 'Apollo/unbundled/gpio_sr9.6.1',
    sources: %w[
      doc
      sys/help
    ]

  manual_namespace 'lisp_2.0', # DOMAIN LISP
    vendor_class: DomainOS,
    os: 'DOMAIN LISP',
    ver: '2.0',
    idir: 'apollo/domain_os/unbundled/lisp_2.0',
    odir: 'Apollo/unbundled/lisp_2.0',
    sources: %w[doc] # TODO help files?
  manual_namespace 'lisp_4.0', # Common LISP
    vendor_class: DomainOS,
    os: 'Domain/Common LISP',
    ver: '4.0',
    idir: 'apollo/domain_os/unbundled/comlisp_4.0',
    odir: 'Apollo/unbundled/comlisp_4.0',
    sources: %w[
      doc/apollo
      ri.apollo.lisp.v.4.0/sys/help
      ri.apollo.lisp.v.4.0/bsd4.3/usr/man/cat1
      ri.apollo.lisp.v.4.0/sys5.3/usr/catman/u_man/man1
    ] # REVIEW these are all three the same, what is the extent to which I care?

  manual_namespace 'nfs_1.0',
    vendor_class: DomainOS,
    os: 'DOMAIN NFS',
    ver: '1.0',
    idir: 'apollo/domain_os/unbundled/nfs_1.0',
    odir: 'Apollo/unbundled/nfs_1.0',
    sources: %w[
      doc
      bsd4.2/usr/man/man[58]
    ]
  manual_namespace 'nfs_2.3',
    vendor_class: DomainOS,
    os: 'Domain NFS',
    ver: '2.3',
    idir: 'apollo/domain_os/unbundled/nfs_2.3',
    odir: 'Apollo/unbundled/nfs_2.3',
    sources: %w[
      doc/apollo
      ri.apollo.nfs.v.2.3/bsd4.3/usr/man/cat[58]
      ri.apollo.nfs.v.2.3/sys5.3/usr/catman/?_man/man[14]
    ] # SR10.2+

  manual_namespace 'pascal_7.1',
    vendor_class: DomainOS,
    os: 'DOMAIN Pascal',
    ver: '7.1',
    idir: 'apollo/domain_os/unbundled/pascal_7.1',
    odir: 'Apollo/unbundled/pascal_7.1',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'pascal_7.54',
    vendor_class: DomainOS,
    os: 'Domain Pascal',
    ver: '7.54',
    idir: 'apollo/domain_os/unbundled/pascal_7.54',
    odir: 'Apollo/unbundled/pascal_7.54',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'pascal_8.8', # REVIEW what version _is_ this??
    vendor_class: DomainOS,
    os: 'Domain Pascal',
    ver: '8.8',
    idir: 'apollo/domain_os/10.3.5',
    odir: 'Apollo/unbundled/pascal_8.8',
    sources: %w[sys/help/pas.hlp] # TODO + doc/*release_notes

  manual_namespace 'tcp_2.1',
    vendor_class: DomainOS,
    os: 'Domain TCP/IP',
    ver: '2.1',
    idir: 'apollo/domain_os/unbundled/tcp_2.1',
    odir: 'Apollo/unbundled/tcp_2.1',
    sources: %w[doc]
  manual_namespace 'tcp_3.0',
    vendor_class: DomainOS,
    os: 'Domain TCP/IP',
    ver: '3.0',
    idir: 'apollo/domain_os/unbundled/tcp_3.0',
    odir: 'Apollo/unbundled/tcp_3.0',
    sources: %w[
      doc
      sys/help
    ]
  manual_namespace 'tcp_3.1',
    vendor_class: DomainOS,
    os: 'Domain TCP/IP',
    ver: '3.1',
    idir: 'apollo/domain_os/unbundled/tcp_3.1',
    odir: 'Apollo/unbundled/tcp_3.1',
    sources: %w[
      doc
      sys/help
    ]

  manual_namespace 'tcpbsd_3.0',
    vendor_class: DomainOS,
    os: 'Domain/IX TCP BSD4.2',
    ver: '3.0',
    idir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.0',
    odir: 'Apollo/unbundled/tcpbsd4.2_3.0',
    sources: %w[doc] # TODO help files??
  manual_namespace 'tcpbsd_3.1',
    vendor_class: DomainOS,
    os: 'Domain/IX TCPBSD4.2',
    ver: '3.1',
    idir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.1',
    odir: 'Apollo/unbundled/tcpbsd4.2_3.1',
    sources: %w[
      doc
      bsd4.2/usr/man/man[18]
    ]

  manual_namespace 'vue_1.0',
    vendor_class: DomainOS,
    os: 'HP VUE ',
    ver: '1.0',
    idir: 'apollo/domain_os/unbundled/vue_1.0',
    odir: 'Apollo/unbundled/vue_1.0',
    sources: %w[
      doc/apollo
      ri.apollo.hpvue.v.1.0/bsd4.3/usr/man/cat[157]
      ri.apollo.hpvue.v.1.0.p/sys5.3/usr/catman/?_man/man[145]
    ] # REVIEW no m68k sys5 files??
end
