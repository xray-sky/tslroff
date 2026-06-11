# frozen_string_literal: true
#

collection_namespace 'thirdparty' do
  collection_namespace 'Alias' do
    # REVIEW were the math functions moved to man0 to 'disable' them?
    # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
    manual_namespace '1_2.1',
      vendor_class: GL2::W3_6,
      os: 'Alias/1',
      ver: '2.1',
      idir: 'alias/1/2.1',
      odir: 'SGI/thirdparty/Alias/Alias:1_2.1',
      sources: %w[iris]
  end

  collection_namespace 'C-TAD' do
    manual_namespace 'Look-In',
      vendor_class: GL2,
      os: 'C-TAD Look-In',
      ver: '',
      idir: 'sgi/thirdparty/ctad_lookin',
      odir: 'SGI/thirdparty/C-TAD/Look-In',
      sources: %w[lookin.man] # nroff
  end

  # TODO needs section detecting
  collection_namespace 'SynOpSys' do
    # TODO is 4D1, not GL2 but I don't have the 4D1 vendor class defined for Troff
    manual_namespace 'Synthesis_3.1a',
      vendor_class: GL2,
      os: 'SynOpSys Synthesis',
      ver: '3.1a',
      idir: 'sgi/thirdparty/synopsys_core_synthesis_3.1a',
      odir: 'SGI/thirdparty/SynOpSys/Synthesis_3.1a',
      # there is also doc/syn/man/fmt[123n] that contains C/A/T typesetter output from troff.
      # presumably this will never be usable for us.
      sources: %w[
        doc/license/man/man1
        doc/syn/man/cat[123n]
      ]
  end

  collection_namespace 'Wolfram' do
    # TODO is 4D1, not GL2 but I don't have the 4D1 vendor class defined for Troff
    manual_namespace 'Mathematica',
      vendor_class: GL2,
      os: 'Mathematica',
      ver: '',
      idir: 'sgi/thirdparty/mathematica',
      odir: 'SGI/thirdparty/Wolfram/Mathematica',
      sources: %w[Install/man]
  end
end
