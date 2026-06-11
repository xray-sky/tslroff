# frozen_string_literal: true
#

require_relative 'sco/opendesktop'
require_relative 'sco/xenix'

collection_namespace 'SCO' do
  require_relative 'sco/tasks/xenix'
  require_relative 'sco/tasks/sysv_386'
  require_relative 'sco/tasks/opendesktop'
  require_relative 'sco/tasks/unbundled'
  require_relative 'sco/tasks/thirdparty'

  collection_namespace 'SystemV/386' do
    manual_namespace '3.2v2.0n',
      vendor_class: OpenDesktop::V1_1_0,
      idir: 'sco/systemv/3.2v2.0n',
      odir: 'SCO/SystemV:386/3.2v2.0n',
      sources: %w[man/cat.*]
  end
end
