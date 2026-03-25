# frozen_string_literal: true
#

collection_namespace 'Motorola' do
  collection_namespace 'SystemV' do
    collection_namespace '88k' do
      manual_namespace 'FH40.42',
                      vendor_class: Motorola_SysV,
                      idir: 'motorola/sysv-88k/R4/FH40.42',
                      odir: 'Motorola/SVR4/88k/FH40.42',
                      sources: %w[usr/src/man/man[1-7]]

      manual_namespace 'FH40.43',
                      vendor_class: Motorola_SysV,
                      idir: 'motorola/sysv-88k/R4/FH40.43',
                      odir: 'Motorola/SVR4/88k/FH40.43',
                      sources: %w[
                        usr/src/man/man[1-7]
                        usr/src/ddi_man/man[1-5]
                      ]
    end
  end
end
