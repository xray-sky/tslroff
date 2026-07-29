# frozen_string_literal: true
#

require_relative 'dell/svr4'
require_relative 'dell/modules/svr4_2.2'

collection_namespace 'Dell' do
  collection_namespace 'SVR4' do
    manual_namespace 'Issue2.2',
      vendor_class: Dell_SVR4::Issue_2_2,
      contributor: 'winworldpc.com',
      os: 'Dell System V Release 4',
      ver: 'Issue 2.2',
      idir: 'dell/svr4_iss2.2',
      odir: 'Dell/SVR4/Issue2.2',
      sources: %w[
        usr/share/man/cat[1-8]
        usr/share/manx/cat[1-8]
      ]
  end
end
