# frozen_string_literal: true
#

collection_namespace 'SGI' do
  require_relative 'sgi/gl'
  require_relative 'sgi/irix'
  require_relative 'sgi/thirdparty'

  collection_namespace 'libiris' do
    manual_namespace 'R1c',
                    vendor_class: BSD::V4_3_VAX_MIT,
                    idir: 'sgi/iris-lib/R1c',
                    odir: 'SGI/libiris/R1c',
                    sources: %w[
                      man/man[13]
                    ]
  end
end
