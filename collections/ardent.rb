# frozen_string_literal: true
#

require_relative 'ardent/sysv'

collection_namespace 'Ardent' do
  collection_namespace 'SysV' do
    manual_namespace 'R3.0',
      vendor_class: Ardent_SysV::R3_0,
      os: 'Stardent',
      ver: '3.0 System Software',
      idir: 'ardent/sysv/3.0',
      odir: 'Ardent/SystemV/R3.0',
      sources: %w[
        man/man[1-8]
        man/bsd/man[1-3]
      ]

    manual_namespace 'R4.1',
      vendor_class: Ardent_SysV::R4_1,
      os: 'Kubota Pacific',
      ver: '4.1 System Software',
      idir: 'ardent/sysv/4.1',
      odir: 'Ardent/SystemV/R4.1',
      sources: %w[
        man[1-8]
        bsd/man[1-3]
      ]

    manual_namespace 'R4.2',
      vendor_class: Ardent_SysV::R4_2,
      os: 'Kubota Pacific',
      ver: '4.2 System Software',
      idir: 'ardent/sysv/4.2',
      odir: 'Ardent/SystemV/R4.2',
      sources: %w[
        man[1-8]
        bsd/man[1-3]
      ]
  end
end
