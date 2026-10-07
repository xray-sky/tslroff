# frozen_string_literal: true
#

require_relative 'natsemi/genix'

collection_namespace 'NatSemi' do
  collection_namespace 'GENIX' do
    manual_namespace '4.1A',
      vendor_class: GENIX,
      contributor: 'bitsavers.org',
      odir: 'NatSemi/GENIX/4.1A',
      sources: %w[usr/man/cat[1-8]]

  end
end
