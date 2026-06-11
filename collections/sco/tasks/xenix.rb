# frozen_string_literal: true
#

collection_namespace 'Xenix' do
  manual_namespace '2.3.4',
    vendor_class: Xenix,
    odir: 'SCO/Xenix/2.3.4',
    sources: %w[usr/man/cat.*]

  manual_namespace '2.3.4g',
    vendor_class: Xenix,
    odir: 'SCO/Xenix/2.3.4g',
    sources: %w[man/cat.*]
end
