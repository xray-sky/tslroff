# frozen_string_literal: true
#

require_relative 'nbi/4.2bsd'

collection_namespace 'NBI' do
  collection_namespace '4.2BSD' do
    manual_namespace '3.04v10.B',
      vendor_class: NBI_4_2BSD,
      idir: 'nbi/4.2bsd/3.04v10.b',
      odir: 'ISI/4.2BSD/3.04v10.B',
      sources: %w[man/man[1-8]]
  end
  collection_namespace 'Duplix' do
    manual_namespace '4.1',
      vendor_class: Duplix::V5_0,
      idir: 'nbi/duplix/4.1',
      odir: 'ISI/Duplix/4.1',
      sources: %w[man/man[1-8]]
    manual_namespace '5.0',
      vendor_class: Duplix::V5_0,
      idir: 'nbi/duplix/5.0',
      odir: 'ISI/Duplix/5.0',
      sources: %w[man/man[1-8]]
  end
end
