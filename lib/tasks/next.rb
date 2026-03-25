# frozen_string_literal: true
#

collection_namespace 'NeXT' do
  collection_namespace 'NEXTSTEP' do
    manual_namespace '1.0',
                    vendor_class: NEXTSTEP,
                    odir: 'NeXT/NEXTSTEP/1.0',
                    sources: %w[NextLibrary/Documentation/Unix/ManPages/man[1-8]]

    manual_namespace '3.3',
                    vendor_class: NEXTSTEP,
                    odir: 'NeXT/NEXTSTEP/3.3',
                    sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

    manual_namespace '4.0pr1',
                    vendor_class: NEXTSTEP,
                    odir: 'NeXT/NEXTSTEP/4.0pr1',
                    sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]
  end

  collection_namespace 'OPENSTEP' do
    manual_namespace '4.2',
                    vendor_class: OPENSTEP,
                    odir: 'NeXT/OPENSTEP/4.2',
                    sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]
  end
end
