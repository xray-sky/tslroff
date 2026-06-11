# frozen_string_literal: true
#

collection_namespace 'SystemV/386' do
  osname = 'System V/386'
  manual_namespace '3.2v2.0n',
    vendor_class: OpenDesktop::V1_1_0,
    os: osname,
    idir: 'sco/systemv/3.2v2.0n',
    odir: 'SCO/SystemV:386/3.2v2.0n',
    sources: %w[man/cat.*]
end
