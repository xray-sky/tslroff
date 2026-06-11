# frozen_string_literal: true
#

collection_namespace 'OpenDesktop' do
  manual_namespace '1.0.0y',
    vendor_class: OpenDesktop::V1_0_0y,
    idir: 'sco/odt/1.0.0y',
    odir: 'SCO/OpenDesktop/1.0.0y',
    sources: %w[usr/man/cat.*]

  manual_namespace '1.1.0',
    vendor_class: OpenDesktop::V1_1_0,
    idir: 'sco/odt/1.1.0',
    odir: 'SCO/OpenDesktop/1.1.0',
    sources: %w[usr/man/cat.*]

  manual_namespace '1.1.1g',
    vendor_class: OpenDesktop::V1_1_1g,
    idir: 'sco/odt/1.1.1-update-g',
    odir: 'SCO/OpenDesktop/1.1.1g',
    sources: %w[usr/man/cat.*]

  manual_namespace 'X11R4-EFS-4.1.1b',
    vendor_class: OpenDesktop,
    idir: 'sco/odt/x11r4-efs-r4.1.1b',
    odir: 'SCO/OpenDesktop/X11R4-EFS-4.1.1b',
    sources: %w[usr/man/cat.*]

  manual_namespace '2.0.0a',
    vendor_class: OpenDesktop,
    idir: 'sco/odt/2.0.0a',
    odir: 'SCO/OpenDesktop/2.0.0a',
    sources: %w[man/cat.*]

  manual_namespace '3.0.0',
    vendor_class: OpenDesktop,
    idir: 'sco/odt/3.0.0',
    odir: 'SCO/OpenDesktop/3.0.0',
    sources: %w[man/cat.*]
end
