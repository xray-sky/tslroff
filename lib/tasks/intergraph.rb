# frozen_string_literal: true
#

collection_namespace 'Intergraph' do
  collection_namespace 'CLIX' do
    manual_namespace '3.1r7.6.22',
                    vendor_class: CLIX::V3_1r7_6_22,
                    odir: 'Intergraph/CLIX/3.1r7.6.22',
                    sources: %w[catman/man[0-8]]

    manual_namespace '3.1r7.6.28',
                    vendor_class: CLIX::V3_1r7_6_28,
                    odir: 'Intergraph/CLIX/3.1r7.6.28',
                    sources: %w[
                      sysvdoc/catman/man[0-8]
                      forms_s/catman
                    ]
  end
end
