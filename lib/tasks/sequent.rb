# TODO macros, etc.
# TODO blacklist Makefile, RCS dir
# TODO extra docs (BSD), maybe

collectionNamespace 'Sequent' do
  collectionNamespace 'DYNIX/ptx' do
    manualNamespace '3.0.17',
      vendor_class: DYNIX_ptx,
      idir: 'sequent/dynix/3.0.17',
      odir: 'Sequent/DYNIX:ptx/3.0.17',
      sources: %w[
        src/doc/man[1-8]
        src.nfs/doc/man/man[1-8]
      ]
    manualNamespace '3.2.0',
      vendor_class: DYNIX_ptx,
      idir: 'sequent/dynix/3.2.0',
      odir: 'Sequent/DYNIX:ptx/3.2.0',
      sources: %w[
        src/doc/man[1-8]
        src.nfs/doc/man/man[1-8]
      ]
  end
end
