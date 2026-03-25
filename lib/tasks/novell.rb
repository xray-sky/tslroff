# frozen_string_literal: true
#

collection_namespace 'Novell' do
  collection_namespace 'UnixWare' do
    manual_namespace '2.01',
                    vendor_class: UnixWare,
                    odir: 'Novell/UnixWare/2.01',
                    sources: %w[usr/share/man/cat[1-8]]
  end
end
