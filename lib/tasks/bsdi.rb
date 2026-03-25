# frozen_string_literal: true
#

collection_namespace 'BSDI' do
  collection_namespace 'BSD386' do
    manual_namespace '1.0',
                    odir: 'BSDI/BSD386/1.0',
                    sources: %w[
                      share/man/cat[1-8]
                      contrib/man/cat[158]
                      man/cat[135]
                    ]  # TODO additional stuff in share/doc
  end
end
