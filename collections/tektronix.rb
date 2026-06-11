# frozen_string_literal: true
#

require_relative 'tektronix/utek'

collection_namespace 'Tektronix' do
  collection_namespace 'UTek' do
    manual_namespace '6130-W2.3',
      vendor_class: UTek::W2_3_6130,
      ver: 'W2.3',
      idir: 'tek/utek/6130/w2.3_2.3e',
      odir: 'Tektronix/UTek/6130-W2.3',
      sources: %w[
        man/cat[1-8]
        man/man1
      ]

    manual_namespace '4319-3.0',
      vendor_class: UTek,
      ver: '3.0',
      idir: 'tek/utek/4319/3.0',
      odir: 'Tektronix/UTek/4319-3.0',
      sources: %w[man/cat[1-8]]

    manual_namespace '4319-4.0',
      vendor_class: UTek,
      ver: '4.0',
      idir: 'tek/utek/4319/4.0',
      odir: 'Tektronix/UTek/4319-4.0',
      sources: %w[man/cat[1-8]]
  end
end
