# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  manual_namespace 'ada_1.0',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/ada_1.0',
                  odir: 'Apollo/unbundled/ada_1.0',
                  sources: %w[bsd4.2/usr/man/man[13]] # TODO + doc/*release_notes
  manual_namespace 'cc_4.6',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/cc_4.6',
                  odir: 'Apollo/unbundled/cc_4.6',
                  sources: %w[sys/help] # TODO + doc/*release_notes
  manual_namespace 'cc_5.5',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/cc_5.5',
                  odir: 'Apollo/unbundled/cc_5.5',
                  sources: %w[sys/help] # TODO + doc/*release_notes
  manual_namespace 'cc_6.9',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/unbundled/cc_6.9',
                  sources: %w[sys/help/cc.hlp] # TODO + doc/*release_notes
  manual_namespace 'dpcc_3.5',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/unbundled/dpcc_3.5',
                  sources: %w[sys/help/dpcc*.hlp] # TODO + doc/*release_notes
  manual_namespace 'dsee_3.2',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/dsee_3.2',
                  odir: 'Apollo/unbundled/dsee_3.2',
                  sources: %w[help/*] # TODO + doc/*release_notes
  manual_namespace 'dsee_3.3',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/dsee_3.3',
                  odir: 'Apollo/unbundled/dsee_3.3',
                  sources: %w[
                    help/*
                    bsd4.3/usr/man/cat1
                    sys5.3/usr/catman/u_man/man1
                  ] # TODO + doc/*release_notes
  manual_namespace 'ftn_10.9',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/unbundled/ftn_10.9',
                  sources: %w[sys/help/ftn.hlp] # TODO + doc/*release_notes
  manual_namespace 'lisp_2.0', # DOMAIN LISP
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/lisp_2.0',
                  odir: 'Apollo/unbundled/lisp_2.0',
                  sources: %w[doc] # TODO release_notes
  manual_namespace 'lisp_4.0', # Common LISP
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/unbundled/lisp_4.0',
                  sources: %w[sys/help/*lisp.hlp] # REVIEW these are all three the same, what is the extent to which I care?
  manual_namespace 'nfs_1.0',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/nfs_1.0',
                  odir: 'Apollo/unbundled/nfs_1.0',
                  sources: %w[bsd4.2/usr/man/man[58]] # TODO + doc/*release_notes ; REVIEW cat[58] also present
  manual_namespace 'pascal_7.54',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/pascal_7.54',
                  odir: 'Apollo/unbundled/pascal_7.54',
                  sources: %w[sys/help] # TODO + doc/*release_notes
  manual_namespace 'pascal_8.8', # REVIEW what version _is_ this??
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/10.3.5',
                  odir: 'Apollo/unbundled/pascal_8.8',
                  sources: %w[sys/help/pas.hlp] # TODO + doc/*release_notes
  manual_namespace 'tcpbsd_3.0',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.0',
                  odir: 'Apollo/unbundled/tcpbsd4.2_3.0',
                  sources: %w[doc] # TODO release_notes
  manual_namespace 'tcpbsd_3.1',
                  vendor_class: DomainOS,
                  idir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.1',
                  odir: 'Apollo/unbundled/tcpbsd_3.1',
                  sources: %w[bsd4.2/usr/man/man[18]] # TODO + doc/*release_notes
end
