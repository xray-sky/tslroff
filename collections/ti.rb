# frozen_string_literal: true
#

collection_namespace 'TI' do
  collection_namespace 'UNIX_V6' do
    manual_namespace '1.3.1',
      vendor_class: UNIX::V6,
      os: 'UNIX 6th Edition',
      ver: '1.3.1',
      idir: 'ti/v6unix-1.3.1/user',
      odir: 'TI/V6/1.3.1',
      sources: %w[
        man/man0/basinf.0
        man/man0/intro.0
        man/man[1-8]
      ]
  end
end
