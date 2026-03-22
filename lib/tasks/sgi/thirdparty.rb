collectionNamespace 'ThirdParty' do
  collectionNamespace 'C-TAD' do
    manualNamespace 'Look-In',
      idir: 'sgi/thirdparty/ctad_lookin',
      odir: 'SGI/thirdparty/C-TAD/Look-In',
      # nroff
      sources: %w[
        lookin.man
      ]
  end

  collectionNamespace 'SynOpSys' do
    # TODO needs section detecting
    manualNamespace 'Synthesis_3.1a',
      # TODO is 4D1, not GL2 but I don't have the 4D1 vendor class defined for Troff
      vendor_class: GL2,
      idir: 'sgi/thirdparty/synopsys_core_synthesis_3.1a',
      odir: 'SGI/thirdparty/SynOpSys/Synthesis_3.1a',
      # there is also doc/syn/man/fmt[123n] that contains C/A/T typesetter output from troff.
      # presumably this will never be usable for us.
      sources: %w[
        doc/license/man/man1
        doc/syn/man/cat[123n]
      ]
  end

  collectionNamespace 'Wolfram' do
    manualNamespace 'Mathematica',
      # TODO is 4D1, not GL2 but I don't have the 4D1 vendor class defined for Troff
      vendor_class: GL2,
      idir: 'sgi/thirdparty/mathematica',
      odir: 'SGI/thirdparty/Wolfram/Mathematica',
      sources: %w[
        Install/man
      ]
  end
end
