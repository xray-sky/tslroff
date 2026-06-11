# frozen_string_literal: true
#

require_relative 'mwc/coherent'

collection_namespace 'MWC' do
  collection_namespace 'Coherent' do
    manual_namespace '3.1.0',
      vendor_class: Coherent,
      odir: 'MWC/Coherent/3.1.0',
      sources: %w[
        man/ALL
        man/COHERENT
        man/MULTI
      ]
  end
end
