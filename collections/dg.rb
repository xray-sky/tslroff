# frozen_string_literal: true
#

require_relative 'dg/dg-ux'

collection_namespace 'DG' do
  require_relative 'dg/tasks/dg-ux'
  require_relative 'dg/tasks/unbundled'
  require_relative 'dg/tasks/thirdparty'
end
