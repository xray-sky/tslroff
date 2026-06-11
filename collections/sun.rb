# frozen_string_literal: true
#

collection_namespace 'Sun' do
  require_relative 'sun/tasks/sunos'
  require_relative 'sun/tasks/thirdparty'
  require_relative 'sun/tasks/unbundled'

  collection_namespace 'Interactive' do
    manual_namespace '3.2r4.1',
      vendor_class: Interactive::V3_2r4_1,
      odir: 'Sun/Interactive/3.2r4.1',
      sources: %w[
        man/mann
        man/u_man/man[1-8]
      ]
  end

  collection_namespace 'Unisoft' do
    manual_namespace 'V7',
      vendor_class: UNIX::V7, # REVIEW seems to be the same as standard V7
      odir: 'Sun/Unisoft/V7',
      sources: %w[man/man[1-8]]
  end # TODO man/as, man/misc release notes
end
