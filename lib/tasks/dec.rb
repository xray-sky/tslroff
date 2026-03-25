# frozen_string_literal: true
#

collection_namespace 'DEC' do
  # TODO there's a bunch more releases / tapes to check
  #      not clear on all the various releases/differences etc.
  # TODO arrange output dirs better
  collection_namespace 'thirdparty' do
    manual_namespace 'Ultrix/Transarc_AFS_3.2/mips',
                    vendor_class: Ultrix::V4_2_0,  # REVIEW correct?
                    idir: 'dec/ultrix/thirdparty/transarc_afs_3.2',
                    odir: 'DEC/thirdparty/Ultrix/Transarc/AFS_3.2/mips',
                    sources: %w[man/man1]
  end

  require_relative './dec/unbundled'
  require_relative './dec/ultrix'
  require_relative './dec/osf1'
  require_relative './dec/vms'
end
