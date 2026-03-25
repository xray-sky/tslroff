# frozen_string_literal: true
#

collection_namespace 'Concurrent' do
  collection_namespace 'CX/UX' do
    # there are more catman pages than man -
    # this processes all catman pages then
    # overwrites any present in man with
    # typesetter quality (this relies on rake
    # FileList sort order)
    manual_namespace '6.20',
                    vendor_class: CX_UX::V6_20,
                    idir: 'concurrent/cx-ux/6.20',
                    odir: 'Concurrent/CX:UX/6.20',
                    sources: %w[
                      usr/catman/?_man/man[1-8]
                      usr/man/?_man/man[1-8]
                    ]
  end
end
