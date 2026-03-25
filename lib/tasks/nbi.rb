# frozen_string_literal: true
#

collection_namespace 'NBI' do
  collection_namespace '4.2BSD' do
    # TODO these were not extracted cleanly. they're almost but not quite tar files - there's garbage in many files
    manual_namespace '3.04v10.B',
                    vendor_class: NBI_4_2BSD,
                    odir: 'NBI/4.2BSD/3.04v10.B',
                    sources: %w[man/man[1-8]]
  end
end
