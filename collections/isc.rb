# frozen_string_literal: true
#

require_relative 'isc/interactive'

collection_namespace 'ISC' do
  collection_namespace 'Interactive' do
    manual_namespace '2.2',
      vendor_class: Interactive::V2_2,
      odir: 'Kodak/Interactive/2.2',
      sources: %w[
        progman/new/usr/catman/p_man/man[1-5]
        userman/new/usr/catman/u_man/man[178]
      ]
    # may be the same as the Kodak release? from winworldpc
    # not exactly - e.g. intro(1) -- though this is a "duplicate" intro(1) from sds we got from doing [. sds]
    # otherwise they maybe do look the same? TODO what to do about duplicates from sds (kodak too)
    manual_namespace '2.2r3.2',
      vendor_class: Interactive::V2_2,
      idir: 'interactive/unix386_2.2r3.2',
      odir: 'ISC/SystemV:386/2.2r3.2',
      sources: %w[sds .]
  end
end
