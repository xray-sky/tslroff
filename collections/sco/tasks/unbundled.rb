# frozen_string_literal: true
#

collection_namespace 'unbundled' do
  manual_namespace 'LLI_3.1.0j',
    vendor_class: OpenDesktop,
    os: 'Link Layer Interface',
    ver: '3.1.0j',
    idir: 'sco/unbundled/lli-r3.1.0j',
    odir: 'SCO/unbundled/LLI_3.1.0j',
    sources: %w[usr/man/cat.*]

  manual_namespace 'ODT_SDS_1.0.0d',
    vendor_class: OpenDesktop,
    os: 'OpenDesktop Software Development System',
    ver: '1.0.0d',
    idir: 'sco/unbundled/odt-sds-1.0.0d',
    odir: 'SCO/unbundled/ODT_SDS_1.0.0d',
    sources: %w[man/cat.*]

  manual_namespace 'ODT_SDS_3.0.0',
    vendor_class: OpenDesktop,
    os: 'OpenDesktop Software Development System',
    ver: '3.0.0',
    idir: 'sco/unbundled/odt-sds-3.0.0',
    odir: 'SCO/unbundled/ODT_SDS_3.0.0',
    sources: %w[man/cat.*]

  manual_namespace 'SystemV/386_SDS_3.2.2b',
    vendor_class: OpenDesktop,
    os: 'System V/386 Software Development System',
    ver: '3.2.2b',
    idir: 'sco/unbundled/sysvds-3.2.2b',
    odir: 'SCO/unbundled/SystemV:386_SDS_3.2.2b',
    sources: %w[man/cat.*]

  manual_namespace 'TCPIP_1.2.0i',
    vendor_class: OpenDesktop,
    os: 'TCP/IP',
    ver: '1.2.0.i',
    idir: 'sco/unbundled/tcpip-1.2.0i',
    odir: 'SCO/unbundled/TCPIP_1.2.0i',
    sources: %w[usr/man/cat.*]
end
