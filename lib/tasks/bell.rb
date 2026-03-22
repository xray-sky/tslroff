collectionNamespace 'Bell' do
  collectionNamespace 'Inferno' do
    manualNamespace '1ed',
      vendor_class: Inferno::FirstEd,
      idir: 'bell/inferno/1e0',
      odir: 'Bell/Inferno/1ed',
      sources: %w[man/html/*.htm] do |t|
        t[:task].prerequisites << assetsTask(%w(*.gif), t[:idir], t[:odir], cut_dirs: 2)
      end
    manualNamespace '1.1ed',
      vendor_class: Inferno::FirstEd_1,
      idir: 'bell/inferno/1e1src',
      odir: 'Bell/Inferno/1.1ed',
      sources: %w[man/html/*.htm] do |t|
        t[:task].prerequisites << assetsTask(%w(*.gif), t[:idir], t[:odir], cut_dirs: 2)
      end
    manualNamespace '3ed',
      vendor_class: Inferno::ThirdEd,
      idir: 'bell/inferno/3e',
      odir: 'Bell/Inferno/3ed',
      sources: %w[man/[1-9]*]
    manualNamespace '4ed',
      vendor_class: Inferno::FourthEd,
      idir: 'bell/inferno/4e',
      odir: 'Bell/Inferno/4ed',
      sources: %w[man/[1-9]*]
  end

  collectionNamespace 'Plan9' do
    manualNamespace '3ed',
      # this is from my Vita Nuova disc - doesn't seem the same as Inferno 3ed, above
      # TODO macros REVIEW is it plan9 or is it inferno
      vendor_class: Plan9,
      idir: 'bell/plan9/3e',
      odir: 'Bell/Plan9/3ed',
      sources: %w[usr/inferno/man/[1-9]*]
    manualNamespace '4ed',
      vendor_class: Plan9,
      idir: 'bell/plan9/4e',
      odir: 'Bell/Plan9/4ed',
      sources: %w[man/[1-8]]
  end

  collectionNamespace 'UNIX' do
    manualNamespace 'V6',
      vendor_class: UNIX::V6,
      odir: 'Bell/UNIX/V6',
      sources: %w[
        man/man[1-8]
        man/man0/intro
      ]
    manualNamespace 'V7',
      vendor_class: UNIX::V7,
      odir: 'Bell/UNIX/V7',
      sources: %w[
        man/man[1-8]
        man/man0/intro
      ]
    manualNamespace '32V',
      vendor_class: UNIX::V7,
      odir: 'Bell/UNIX/32V',
      sources: %w[
        usr/man/man[1-8]
        usr/man/man0/intro
      ]
    manualNamespace 'SysIII',
      # where'd I get this manual? need lib/macros/an
      # TODO also contains a lot of papers for as, cc, etc.
      idir: 'bell/unix/sysiii',
      odir: 'Bell/UNIX/SystemIII',
      sources: %w[
        usr/src/man/man[1-8]
        usr/src/man/man0/intro
      ]
  end
end
