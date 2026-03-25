# frozen_string_literal: true
#
# TODO macros, etc.
# TODO blacklist Makefile, RCS dir
# TODO extra docs (BSD), maybe
#

collection_namespace 'Sequent' do
  collection_namespace 'DYNIX/ptx' do
    manual_namespace '3.0.17',
                    vendor_class: DYNIX_ptx,
                    idir: 'sequent/dynix/3.0.17',
                    odir: 'Sequent/DYNIX:ptx/3.0.17',
                    sources: %w[
                      src/doc/man[1-8]
                      src.nfs/doc/man/man[1-8]
                    ]
    manual_namespace '3.2.0',
                    vendor_class: DYNIX_ptx,
                    idir: 'sequent/dynix/3.2.0',
                    odir: 'Sequent/DYNIX:ptx/3.2.0',
                    sources: %w[
                      src/doc/man[1-8]
                      src.nfs/doc/man/man[1-8]
                    ]
  end
end
