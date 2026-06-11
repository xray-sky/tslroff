# frozen_string_literal: true
#

require_relative 'acorn/riscix'

collection_namespace 'Acorn' do
  collection_namespace 'RISCiX' do
    # REVIEW were the math functions moved to man0 to 'disable' them?
    # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
    manual_namespace '1.2',
      vendor_class: RISCiX::V1_2,
      os: 'RISC iX',
      odir: 'Acorn/RISCiX/1.2',
      sources: %w[
        usr/share/man/man0/*.3m
        usr/share/man/man[1-8]
      ]
  end
end
