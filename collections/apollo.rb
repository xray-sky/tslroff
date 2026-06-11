# frozen_string_literal: true
#

require_relative 'apollo/domain_os'

collection_namespace 'Apollo' do
  require_relative 'apollo/tasks/aegis'
  require_relative 'apollo/tasks/domain_ix'
  require_relative 'apollo/tasks/domain_os'
  require_relative 'apollo/tasks/unbundled'
end
