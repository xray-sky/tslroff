# frozen_string_literal: true
#

require_relative 'concurrent/cx-ux'

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

  collection_namespace 'MAXION/OS' do
    manual_namespace '1.2var17',
      vendor_class: CX_UX::V6_20,
      idir: 'concurrent/maxion/1.2v17',
      odir: 'Concurrent/MaxionOS/Y2k_1.2_variant17',
      sources: %w[
        ecc/reloc/usr/share/man/cat1
        edb/reloc/opt/epc/edb/man/man1
        epctools/reloc/usr/share/man/cat1
        vmaxos/root/usr/share/man/zcat[17]
      ]
  end
end
