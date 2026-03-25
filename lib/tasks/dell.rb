# frozen_string_literal: true
#

collection_namespace 'Dell' do
  collection_namespace 'SVR4' do
    manual_namespace 'Issue2.2',
                    idir: 'dell/svr4_iss2.2',
                    odir: 'Dell/SVR4/Issue2.2',
                    sources: %w[
                      usr/share/man/cat[1-8]
                      usr/share/manx/cat[1-8]
                    ]
  end
end
