collectionNamespace 'Sony' do
  collectionNamespace 'NEWS-os' do
    # TODO extra docs
    manualNamespace '3.3/en_US',
      vendor_class: NEWS_os::V3_3_en_US,
      idir: 'sony/news-os/3.3',
      odir: 'Sony/NEWS-os/3.3/en_US',
      sources: %w[public/usr/man/man[1-8nops]]
    manualNamespace '3.3/ja_JP',
      vendor_class: NEWS_os::V3_3_ja_JP,
      idir: 'sony/news-os/3.3',
      odir: 'Sony/NEWS-os/3.3/ja_JP',
      sources: %w[public/usr/jman/man[1-8nops]]
    # TODO extra docs
    manualNamespace '4.1C/en_US',
      vendor_class: NEWS_os::V4_1C_en_US,
      idir: 'sony/news-os/4.1ca/usr/man',
      odir: 'Sony/NEWS-os/4.1C/en_US',
      sources: %w[C/man[1-8nop]]
    manualNamespace '4.1C/ja_JP',
      vendor_class: NEWS_os::V4_1C_ja_JP,
      idir: 'sony/news-os/4.1ca/usr/man',
      odir: 'Sony/NEWS-os/4.1C/ja_JP',
      sources: %w[
        ja_JP.SJIS/man[1-8nop]
        Motif1.0/ja_JP.SJIS/man3
      ]
    manualNamespace '4.2.1R/en_US',
      vendor_class: NEWS_os::V4_2_1R_en_US,
      idir: 'sony/news-os/4.2.1R/usr/man',
      odir: 'Sony/NEWS-os/4.2.1R/en_US',
      sources: %w[C/man[1-8nop]]
    # TODO compare installed man w/ media-extracted (.../4.2.1R/usr/man)
    manualNamespace '4.2.1R/ja_JP',
      vendor_class: NEWS_os::V4_2_1R_ja_JP,
      idir: 'sony/news-os/4.2.1R/man',
      odir: 'Sony/NEWS-os/4.2.1R/ja_JP',
      sources: %w[
        ja_JP.SJIS/man[1-8nop]
        Motif1.0/ja_JP.SJIS/man3
      ]
    # REVIEW share/man.foon ??
    manualNamespace '5.0.1',
      vendor_class: NEWS_os::V5_0_1,
      odir: 'Sony/NEWS-os/5.0.1',
      sources: %w[
        share/man/*cat[1-8]
        X11/usr/man/man[13]
        X11/usr/man/Motif/man[13]
      ]
  end
end
