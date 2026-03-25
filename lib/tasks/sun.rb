# frozen_string_literal: true
#

collection_namespace 'Sun' do
  require_relative 'sun/sunos'
  require_relative 'sun/thirdparty'
  require_relative 'sun/unbundled'

  collection_namespace 'Interactive' do
    manual_namespace '3.2r4.1',
                    idir: 'sun/interactive/3.2r4.1',
                    sources: %w[
                      man/mann
                      man/u_man/man[1-8]
                    ]
  end
end
