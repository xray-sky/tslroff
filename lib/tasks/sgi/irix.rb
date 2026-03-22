collectionNamespace '4D1' do
  manualNamespace '2.0',
    vendor_class: IRIX,
    idir: 'sgi/irix/2.0',
    odir: 'SGI/4D1/2.0',
    sources: %w[
      usr/catman/?_man/cat[1-8]
    ]
end

collectionNamespace 'IRIX' do
  manualNamespace '6.5.3f',
    vendor_class: IRIX,
    odir: 'SGI/IRIX/6.5.3f',
    sources: %w[
      share/catman/?_man/cat[1-8o]/*.z
      share/catman/?_man/cat[1-8o]/dmedia
      share/catman/?_man/cat[1-8o]/Inventor
      share/catman/?_man/cat[1-8o]/Performer_demo
      share/catman/?_man/cat[1-8o]/X11
      share/catman/?_man/cat[1-8o]/Xm
      share/catman/a_man/cat1/sysadm
      share/catman/g_man/cat3/*
      share/catman/p_man/cat[1-8o]/ifl
      share/catman/p_man/cat[1-8o]/libelf
      share/catman/p_man/cat[1-8o]/libelfutil
      share/catman/p_man/cat[1-8o]/libexc
      share/catman/p_man/cat[1-8o]/perl5
      share/catman/p_man/cat[1-8o]/standard
      share/catman/p_man/cat[1-8o]/Vk
      share/catman/p_man/cat[1-8o]/Xvc
      share/catman/p_man/cat3dm/*
    ]
end
