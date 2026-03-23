collectionNamespace 'HP' do

  # A.01.00_BL50 HP_OSF1 1.0
  # from plamen; incomplete - need tmac.an (for now, pretend it's the same as DEC?)
  # disc 2 only - products:
  #  • C++ Compiler 2.1
  #  • Developer's Kit 1.0
  #  • Pascal Compiler 1.0
  collectionNamespace 'OSF1' do
    manualNamespace '1.0',
      idir: 'hp/osf1/a.01.00_bl50',
      sources: %w[
        usr/CC/man/man[13]
        man-assembler/files/usr/share/man/man1
        man-ccs/files/usr/share/man/man[13]
        man-dde/files/usr/dde/man/man1
        man-devenv/files/usr/local/sdm/man/man[15]
        man-ncs/files/usr/share/man/man[13]
        man-x11r4/files/usr/share/man/man[134]
        pascal~58a4/man/files/usr/pas/man/man1
      ]
  end

  require_relative 'hp/hpux.rb'
  require_relative 'hp/unbundled.rb'

end
