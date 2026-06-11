# frozen_string_literal: true
#

require_relative 'atari/sysv'

collection_namespace 'Atari' do
  collection_namespace 'SysV' do
    osname = 'Atari System V'
    # TODO sort out differences & local changes. are these separate releases??
    manual_namespace '1.1-06',
      vendor_class: Atari_SysV,
      os: osname,
      idir: 'atari/system_v/1.1-06',
      odir: 'Atari/SystemV/1.1-06',
      sources: %w[
        share/man/cat[1-8]
        share/man/man[13]
      ]

    manual_namespace 'ue12',
      vendor_class: Atari_SysV,
      os: osname,
      idir: 'atari/system_v/ue12',
      odir: 'Atari/SystemV/ue12',
      sources: %w[share/man/cat[1-8]]
  end
end
