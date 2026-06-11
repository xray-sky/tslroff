# frozen_string_literal: true
#

require_relative 'sgi/gl'
require_relative 'sgi/irix'

collection_namespace 'SGI' do
  collection_namespace 'libiris' do
    manual_namespace 'R1c',
      vendor_class: BSD::V4_3,
      idir: 'sgi/iris-lib/R1c',
      odir: 'SGI/libiris/R1c',
      sources: %w[
        man/man[13]
      ]
  end

  require_relative 'sgi/tasks/gl'
  require_relative 'sgi/tasks/irix'
  require_relative 'sgi/tasks/thirdparty'

end
