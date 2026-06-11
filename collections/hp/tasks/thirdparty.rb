# frozen_string_literal: true
#

collection_namespace 'thirdparty' do
  manual_namespace 'Apple/MAE+JLK_2.0',
    vendor_class: HPUX::V9_05,
    os: 'Macintosh Execution Environment',
    ver: '2.0',
    idir: 'hp/hpux/thirdparty/apple/mae+jlk_2.0',
    odir: 'HP/thirdparty/Apple/MAE_2.0',
    sources: %w[
      README.TXT
      STREAMS/READ.ME
      usr/apple/man1
      usr/man/man[1237]*.Z
    ]
end
