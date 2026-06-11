# frozen_string_literal: true
#

require_relative 'bsdi/bsd386'

collection_namespace 'BSDI' do
  collection_namespace 'BSD/386' do
    manual_namespace '1.0',
      vendor_class: BSD386,
      idir: 'bsdi/bsd386/1.0',
      odir: 'BSDI/BSD:386/1.0',
      sources: %w[
        share/man/cat[1-8]
        contrib/man/cat[158]
        man/cat[135]
      ]  # TODO additional stuff in share/doc
  end
end
