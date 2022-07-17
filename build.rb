#! /usr/bin/env ruby
#
# build.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 06/24/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
# Automate building of product manuals
#
# TODO: unbundleds (output, plus review input collections which may be mixed)
# TODO: manual.erb can't find the CSS with the extra level of directory structure (e.g. UTek)
# TODO: cope with pages named 'index' (e.g. DG-UX 5.4R3.00 index(3C))
#       - possibly by providing top level all-sections index (permuted or otherwise?)
# TODO: unlink 404 refs, probably after auditing whether they are really missing
# TODO: rewrite links in "overlay" versions (e.g. DG-UX 4.31, 5.4.2T, etc.) to base manual
# TODO: rewrite links in optional products (e.g. Apollo ada 1.0 links to ld(1)) to.. where exactly?

collections = {
  '': {
    disabled: true,
    '': {
      '': {
        basedir: '',
        srcdirs: %w[]
      }
    }
  },
  'Acorn': {
    disabled: true,
    'RISCiX': {
      '1.2': {
        basedir: 'acorn/riscix/1.2',
        # TODO: were the math functions moved to man0 to 'disable' them?
        # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
        srcdirs: %w[
          share/man/man0/*.3m
          share/man/man[1-8]
        ]
      }
    }
  },
  'Alias': {
    # use GL2/IRIX defs
    disabled: true,
    '1': {
      '2.1': {
        basedir: 'alias/1/2.1',
        srcdirs: %w[iris]
      }
    }
  },
  'Apollo': {
    disabled: true,
    'unbundled': {
      module_override: 'DomainOS',
      'ada_1.0': {
        basedir: 'apollo/domain_os/unbundled/ada_1.0',
        srcdirs: %w[bsd4.2/usr/man/man[13]] # TODO: + doc/*release_notes
      },
      'cc_4.6': {
        basedir: 'apollo/domain_os/unbundled/cc_4.6',
        srcdirs: %w[sys/help] # TODO: + doc/*release_notes
      },
      'cc_5.5': {
        basedir: 'apollo/domain_os/unbundled/cc_5.5',
        srcdirs: %w[sys/help] # TODO: + doc/*release_notes
      },
      'cc_6.9': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/cc.hlp] # TODO: + doc/*release_notes
      },
      'dpcc_3.5': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/dpcc*.hlp] # TODO: + doc/*release_notes
      },
      'ftn_10.9': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/ftn.hlp] # TODO: + doc/*release_notes
      },
      'lisp_2.0': { # DOMAIN LISP
        disabled: true, # TODO: release_notes
        basedir: 'apollo/domain_os/unbundled/lisp_2.0',
        srcdirs: %w[doc]
      },
      'lisp_4.0': { # Common LISP
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/*lisp.hlp] # REVIEW: these are all three the same, what is the extent to which I care?
      },
      'nfs_1.0': {
        basedir: 'apollo/domain_os/unbundled/nfs_1.0',
        srcdirs: %w[bsd4.2/usr/man/man[58]] # TODO: + doc/*release_notes ; REVIEW: cat[58] also present
      },
      'pascal_7.54': {
        basedir: 'apollo/domain_os/unbundled/pascal_7.54',
        srcdirs: %w[sys/help] # TODO: + doc/*release_notes
      },
      'pascal_8.8': { # REVIEW: what version _is_ this??
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/pas.hlp] # TODO: + doc/*release_notes
      },
      'tcpbsd_3.0': {
        disabled: true, # TODO: release_notes
        basedir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.0',
        srcdirs: %w[doc]
      },
      'tcpbsd_3.1': {
        basedir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.1',
        srcdirs: %w[bsd4.2/usr/man/man[18]] # TODO: + doc/*release_notes
      }
    },
    'Aegis': {
      module_override: 'DomainOS',
      'SR9.7.5': {
        # TODO: (what though?) unbundled products for sure (lisp)
        basedir: 'apollo/domain_os/9.7.5',
        srcdirs: %w[sys/help/*]
      }
    },
    'DomainIX': {
      module_override: 'DomainOS',
      'SR9.5': {
        basedir: 'apollo/domain_os/9.5',
        srcdirs: %w[
          bsd4.2/usr/man/cat[1-8]
          sys5/usr/catman/?_man/man[1-8]
        ]
      }
    },
    'DomainOS': {
      'SR10.3.5': {
        # TODO: (what though?) unbundled products for sure (lisp)
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[
          sys/help/*
          bsd4.3/usr/man/cat[1-8]
          sys5/usr/catman/?_man/man[1-8]
          usr/apollo/man/mana
          usr/new/mann
          usr/X11/man/cat*
        ]
      },
      'SR10.4': {
        # TODO: (what though?) unbundled products for sure (lisp)
        basedir: 'apollo/domain_os/10.4',
        srcdirs: %w[
          sys/help/*
          bsd4.3/usr/man/cat[1-8]
          sys5/usr/catman/?_man/man[1-8]
          usr/apollo/man/mana
          usr/new/mann
          usr/softbench/man/man*
          usr/X11/man/cat*
        ]
      },
      'SR10.4.1': {
        # TODO: (what though?) unbundled products probably (pascal, fortran, etc.)
        basedir: 'apollo/domain_os/10.4.1',
        srcdirs: %w[
          sys/help/*
          bsd4.3/usr/man/cat[1-8]
          sys5/usr/catman/?_man/man[1-8]
          usr/apollo/man/mana
          usr/new/mann
          usr/softbench/man/man*
          usr/X11/man/cat*
        ]
      }
    }
  },
  'Apple': {
    disabled: true,
    'A-UX': {
      '0.7': {
        basedir: 'apple/aux/0.7',
        srcdirs: %w[catman/?_man/man[1-8]]
      },
      '2.0': {
        basedir: 'apple/aux/2.0',
        srcdirs: %w[catman/?_man/man[1-8]]
      },
      '3.0.1': {
        basedir: 'apple/aux/3.0.1',
        srcdirs: %w[catman/?_man/man[1-8]]
      }
    },
    'Rhapsody': {
      disabled: true,
      '5.0': {
        basedir: 'apple/rhapsody/dr1',
        srcdirs: %w[man/man[1-8]]
      },
      '5.1': {
        basedir: 'apple/rhapsody/dr2',
        srcdirs: %w[usr/share/man/man[1-8l]]
      },
      '5.3': { # REVIEW are there more man pages (e.g. for sections 2 & 3) in the dev pkgs?
        basedir: 'apple/rhapsody/5.3',
        srcdirs: %w[man/man[145678n]]
      },
      '5.5': {
        basedir: 'apple/rhapsody/5.5',
        srcdirs: %w[man/man[145678n]]
      }
    }
  },
  'Ardent': {
    disabled: true,
    'SysV': {
      'R3.0': {
        basedir: 'ardent/sysv/3.0',
        srcdirs: %w[
          man/man[1-8]
          man/bsd/man[1-3]
        ]
      }
    }
  },
  'Atari': {
    disabled: true,
    'SysV': {
      # TODO: sort out differences & local changes. are these separate releases??
      '1.1-06': {
        basedir: 'atari/system_v/1.1-06',
        srcdirs: %w[
          share/man/cat[1-8]
          share/man/man[13]
        ]
      },
      'ue12': {
        basedir: 'atari/system_v/ue12',
        srcdirs: %w[share/man/cat[1-8]]
      }
    }
  },
  'Be': {
    # TODO: graphics assets - the gifs in the R3 ./graphics/ & pressinfo/resources (not belogos/) directories are macbinary encoded! - must decode first
    # TODO: are there actually metrowerks docs for R4 and earlier, somewhere other than develop/BeIDE?
    #       (cd /Volumes/Museum/Manual/in/be/beos/pr2/beos/documentation && find . \( -name '*.jp*g' -o \( -name '*.[gG][iI][fF]' -o -name '*.pdf' \) \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/PR2 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r3/beos/documentation && find . \( -name '*.jp*g' -o -name '*.[gG][iI][fF]' \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R3 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r3/beos/documentation && find . \( -name '*.tiff' -o \( -name '*.eps' -o -name '*.map' \) \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R3 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r4/beos/documentation && find . \( -name '*.jp*g' -o \( -name '*.[gG][iI][fF]' -o -name '*.eps' \) \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R4 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r4.5/develop && find . -name '*.gif' -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R4.5 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r4.5/beos/documentation && find . \( -name '*.jp*g' -o -name '*.[gG][iI][fF]' \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R4.5 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r5/develop && find . -name '*.gif' -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R5 && tar xvfB - )
    #       (cd /Volumes/Museum/Manual/in/be/beos/r5/beos/documentation && find . \( -name '*.jp*g' -o -name '*.[gG][iI][fF]' \) -print0 | xargs -0 tar cf -) | ( cd /Volumes/dev.online.typewritten.org/Manual/Be/BeOS/R5 && tar xvfB - )
    disabled: true,
    'BeOS': {
      'PR2': {
        basedir: 'be/beos/pr2',
        srcdirs: %w[
          beos/documentation
          beos/documentation/Be?Book
          beos/documentation/Be?Book/*/*.html
          beos/documentation/BeOS?Product?Information
          beos/documentation/FAQs
          beos/documentation/Shell?Tools
          beos/documentation/Shell?Tools/man1
          beos/documentation/User?s?Guide/HTML/*.html
        ]
      },
      'R3': {
        basedir: 'be/beos/r3',
        srcdirs: %w[
          beos/documentation
          beos/documentation/Be?Book
          beos/documentation/Be?Book/[DGPT]*/*.html
          beos/documentation/BeOS_Product_Information
          beos/documentation/notes
          beos/documentation/PressInfo
          beos/documentation/PressInfo/[anr]*/*.html
          beos/documentation/PressInfo/aboutbe/*/*.html
          beos/documentation/PressInfo/aboutbe/*/news_images/*.html
          beos/documentation/PressInfo/aboutbe/pressphotos/*/*.html
          beos/documentation/PressInfo/resources/*/*.html
          beos/documentation/Release_Notes
          beos/documentation/Shell?Tools
          beos/documentation/Shell?Tools/man1
          beos/documentation/The_Be_FAQs
          beos/documentation/The_Be_FAQs/faqs
          beos/documentation/User?s?Guide
        ]
      },
      'R4': {
        basedir: 'be/beos/r4',
        srcdirs: %w[
          beos/documentation
          beos/documentation/AlertInfo
          beos/documentation/Be?Book
          beos/documentation/Be?Book/[PRT]*/*.html
          beos/documentation/BeOS_Product_Information
          beos/documentation/BeOS_Product_Information/beos_tour/*.html
          beos/documentation/Shell?Tools
          beos/documentation/Shell?Tools/man1
          beos/documentation/The_Be_FAQs
          beos/documentation/The_Be_FAQs/faqs
          beos/documentation/User?s?Guide
          beos/documentation/User?s?Guide/[0AR]*
          beos/documentation/Virtual_Press_Kit
          beos/documentation/Virtual_Press_Kit/aboutbe
          beos/documentation/Virtual_Press_Kit/aboutbe/[ln]*/*.html
          beos/documentation/Virtual_Press_Kit/aboutbe/pressreleases
        ]
      },
      'R4.5': {
        basedir: 'be/beos/r4.5',
        srcdirs: %w[
          beos/documentation
          beos/documentation/AlertInfo
          beos/documentation/AlertInfo/ATCommands
          beos/documentation/Be?Book
          beos/documentation/Be?Book/[A-Z]*
          beos/documentation/Be?Book/Release?Notes/[bB]*
          beos/documentation/BeOS_Product_Information
          beos/documentation/BeOS_Product_Information/beos_tour/*.html
          beos/documentation/Shell?Tools
          beos/documentation/Shell?Tools/man1
          beos/documentation/Shell?Tools/ref/*
          beos/documentation/User?s?Guide
          beos/documentation/User?s?Guide/0[1-7]_*
          beos/documentation/User?s?Guide/Appx*
          beos/documentation/User?s?Guide/French
          beos/documentation/User?s?Guide/French/[0A]*
          beos/documentation/User?s?Guide/German
          beos/documentation/User?s?Guide/German/[0A]*
          beos/documentation/User?s?Guide/Release?Notes*
          beos/documentation/User?s?Guide/Release?Notes*/3DMixer
          beos/documentation/Virtual_Press_Kit
          beos/documentation/Virtual_Press_Kit/aboutbe
          beos/documentation/Virtual_Press_Kit/aboutbe/[ln]*/*.html
          beos/documentation/Virtual_Press_Kit/aboutbe/pressreleases
          develop/BeIDE/Documentation/BeOS?doc?/*_html
        ]
      },
      'R5': {
        basedir: 'be/beos/r5',
        srcdirs: %w[
          beos/documentation
          beos/documentation/AlertInfo
          beos/documentation/AlertInfo/ATCommands
          beos/documentation/Be?Book
          beos/documentation/Be?Book/[A-Z]*
          beos/documentation/BinkJet?2.0
          beos/documentation/BinkJet?2.0/[ds]*/*.html
          beos/documentation/Shell?Tools
          beos/documentation/Shell?Tools/man1
          beos/documentation/Shell?Tools/ref/*
          beos/documentation/User?s?Guide
          beos/documentation/User?s?Guide/0[1-7]_*
          develop/BeIDE/Documentation/BeOS?doc?/*_html
        ]
      }
    }
  },
  'Bell': {
    disabled: true,
    # TODO: gif assets in 1ed, 1.1ed
    'Plan9': {
      '1ed': {
        basedir: 'bell/plan9/1e0',
        srcdirs: %w[man/html/*.htm]
      },
      '1.1ed': {
        basedir: 'bell/plan9/1e1src',
        srcdirs: %w[man/html/*.htm]
      },
      '3ed': {
        disabled: true,
        basedir: 'bell/plan9/3e',
        srcdirs: %w[man/[1-9]*]
      }
    },
    'UNIX': {
      disabled: true,
      'V6': {
        # TODO: also contains a lot of papers for as, cc, etc.
        basedir: 'bell/unix/v6',
        srcdirs: %w[
          man/man[1-8]
          man/man0/intro
        ]
      },
      'V7': {
        basedir: 'bell/unix/v7',
        srcdirs: %w[
          man/man[1-8]
          man/man0/intro
        ]
      },
      '32V': {
        basedir: 'bell/unix/32v',
        srcdirs: %w[
          usr/man/man[1-8]
          usr/man/man0/intro
        ]
      },
      'SysIII': {
        # TODO: also contains a lot of papers for as, cc, etc.
        basedir: 'bell/unix/sysiii',
        srcdirs: %w[
          usr/src/man/man[1-8]
          usr/src/man/man0/intro
        ]
      }
    }
  },
  'Commodore': {
    disabled: true,
    'AMIX': {
      '1.1': {
        basedir: 'commodore/amix/1.1',
        srcdirs: %w[share/catman/g[1-8]?]
      },
      '2.0': {
        basedir: 'commodore/amix/2.00',
        srcdirs: %w[
          usr/share/catman/[1-8]?
          usr/share/man/[1-8]?
        ]
      },
      '2.01': {
        basedir: 'commodore/amix/2.01',
        srcdirs: %w[
          usr/share/catman/[1-8]?
          usr/share/man/[1-8]?
        ]
      },
      '2.03': {
        basedir: 'commodore/amix/2.03',
        srcdirs: %w[
          usr/share/catman/[1-8]?
          usr/share/man/[1-8]?
        ]
      },
      '2.1': {
        basedir: 'commodore/amix/2.10',
        srcdirs: %w[
          usr/share/catman/[1-8]?
          usr/share/man/[1-8]?
        ]
      }
    }
  },
  'Concurrent': {
    disabled: true,
    'CX-UX': {
      # TODO: (?) canonically is 'CX/UX'
      '6.20': {
        basedir: 'concurrent/cx-ux/6.20',
        srcdirs: %w[
          usr/catman/?_man/man[1-8]
          usr/man/?_man/man[1-8]
        ]
      }
    }
  },
  'DEC': {
    disabled: true,
    'Ultrix': {
      '2.0.0': {
        basedir: 'dec/ultrix/2.0.0',
        srcdirs: %w[
          src/usr/man/man[1-8]
          src/new/*/man/*.[1-8]
          src/new/rcs/man/man[15]/*.[1-8]
          src/new/spms/man/catn/spmsintro.n
          src/new/spms/man/man3/pgrep.3p
          src/new/spms/man/mann/*.n
        ]
      },
      '4.2.0/VAX': {
        basedir: 'dec/ultrix/4.2.0',
        srcdirs: %w[usr/man/_vax.d/man[1-8]]
      },
      '4.2.0/mips': {
        basedir: 'dec/ultrix/4.2.0',
        srcdirs: %w[usr/man/_mips.d/man[1-8]]
      },
      '4.5.1/mips': {
        basedir: 'dec/ultrix/4.5.1_mips',
        srcdirs: %w[man/man[1-8]]
      }
    },
    'Tru64': {
      '5.1b': {
        basedir: 'dec/tru64/5.1b',
        srcdirs: %w[
          usr/share/man/man[1-9]
          usr/dt/share/man/man[1-5]
        ]
      },
    }
  },
  'DG': {
   disabled: true,
    'DG-UX': {
      # TODO: canonically, 'DG/UX'
      '4.30': {
        basedir: 'dg/dgux/4.30',
        srcdirs: %w[catman/?_man/man[0-8]]
      },
      '4.31': {
        basedir: 'dg/dgux/4.31',
        srcdirs: %w[catman/?_man/man[0-8]]
      },
      '5.4.2A': {
        basedir: 'dg/dgux/5.4.2A',
        srcdirs: %w[
          catman/?_man/man[0-8]
          catman/lg.1.z
        ]
      },
      '5.4.2T': {
        basedir: 'dg/dgux/5.4.2T',
        srcdirs: %w[catman/?_man/man[1-8]]
      },
      '5.4R2.01': {
        basedir: 'dg/dgux/5.4R2.01',
        srcdirs: %w[
          catman/?_man/man[0-8]
          catman/man[358]
        ]
      },
      '5.4R2.01p8': {
        basedir: 'dg/dgux/5.4R2.01p8',
        srcdirs: %w[catman/?_man/man[147]]
      },
      '5.4R3.00': {
        basedir: 'dg/dgux/5.4R3.00',
        srcdirs: %w[
          catman/?_man/man[0-8]
          catman/man[1358]
        ]
      }
    }
  },
  'Gould': {
    disabled: true,
    'GDT-UNX': {
      '6.8_er0': {
        # TODO: man1/adb.1 vs. man1/adb.1.orig etc.
        #       divergences in cat[n] apart from n=9?
        basedir: 'gould/gdt-unx/6.8_er0',
        srcdirs: %w[
          man/cat9
          man/man[1-8l]
        ]
      }
    }
  },
  'HP': {
    disabled: true,
    'unbundled': {
      module_override: 'HPUX',
      'ANSI-C_A09.00/S300': {
        basedir: 'hp/hpux/unbundled/ansi-c/A.09.00-S300',
        srcdirs: %w[usr/man/man[12345].Z]
      },
      'ANSI-C_A10.11/S700': { # TODO there's some Japanese language manual pages in here, too
        basedir: 'hp/hpux/unbundled/ansi-c/A.10.11-S700',
        srcdirs: %w[
          */*/opt/imake/man/man1.Z
          */*/usr/share/man/man[1-8]*.Z
          */*/opt/*/share/man/man[1-8].Z
          */*/opt/graphics/*/share/man/man[1-8].Z
        ]
      },
      'C++_A.03.20/S300': { # REVIEW has extra man macros in usr/CC/man/SC/manmacros
        basedir: 'hp/hpux/unbundled/c++/A.03.20-S300',
        srcdirs: %w[
          usr/man/man3
          usr/man/man[13].Z
          usr/CC/man/SC/man[134]
        ]
      },
      'DATIO_1.2': {
        basedir: 'hp/hpux/unbundled/datio/1.2',
        srcdirs: %w[usr/man/man1.Z]
      },
      'Instrument-Control-Lib_C.03.01': {
        basedir: 'hp/hpux/unbundled/instrument-control-lib/C.03.01',
        srcdirs: %w[usr/man/man*]
      },
      'Instrument-Control-Lib_G.03.00': {
        basedir: 'hp/hpux/unbundled/instrument-control-lib/G.03.00',
        srcdirs: %w[
          opt/sicl/share/man/man*
          opt/vxipnp/hpux/hpvisa/share/man/man3
        ]
      },
      'PersonalVisualizer_2.11/S700': {
        basedir: 'hp/hpux/unbundled/personalvisualizer/2.11-S700',
        srcdirs: %w[usr/man/man[13].Z]
      },
      'PowerShade_A.B1.00/S700': {
        basedir: 'hp/hpux/unbundled/powershade/A.B1.00-S700',
        srcdirs: %w[usr/man/man1.Z]
      },
      'SCPI_B.02.00/S300': {
        basedir: 'hp/hpux/unbundled/scpi/B.02.00-S300',
        srcdirs: %w[usr/hp75000/man/man[135]]
      }
    },
    'HPUX': {
      '5.00': {
        basedir: 'hp/hpux/5.00/S500',
        srcdirs: %w[usr/man/man*]
      },
      '5.20/S300': {
        basedir: 'hp/hpux/5.20/S300',
        srcdirs: %w[
          usr/man/cat[1-5]
          usr/man/cat1m
          usr/man/man*
        ]
      },
      '5.20/S500': {
        basedir: 'hp/hpux/5.20/S500',
        srcdirs: %w[usr/man/man*]
      },
      '5.50': {
        basedir: 'hp/hpux/5.50/S300',
        srcdirs: %w[
          usr/man/cat[1-5]
          usr/man/cat1m
          usr/man/man*
        ]
      },
      '6.00': {
        basedir: 'hp/hpux/6.00',
        srcdirs: %w[S300/usr/man/man*.Z]
      },
      '6.20': {
        basedir: 'hp/hpux/6.20',
        srcdirs: %w[S300/usr/man/man*.Z]
      },
      '7.01': {
        basedir: 'hp/hpux/7.01',
        srcdirs: %w[usr/man/man*]
      },
      '7.03': {
        basedir: 'hp/hpux/7.03',
        srcdirs: %w[usr/man/man*]
      },
      '8.05': {
        basedir: 'hp/hpux/8.05',
        srcdirs: %w[
          usr/man/man*
          usr/contrib/man/man1m
        ]
      },
      '8.07': {
        basedir: 'hp/hpux/8.07',
        srcdirs: %w[usr/man/man*]
      },
      '9.00': {
        basedir: 'hp/hpux/9.00',
        srcdirs: %w[man/man*]
      },
      '9.03': {
        basedir: 'hp/hpux/9.03',
        srcdirs: %w[
          usr/man/man*
          usr/contrib/man/man1.Z
          softbench/man/man*.Z
        ]
      },
      '9.04': {
        basedir: 'hp/hpux/9.04 (S800 HP-PA Support)',
        srcdirs: %w[usr/man/man1m.Z]
      },
      '9.05': {
        basedir: 'hp/hpux/9.05',
        srcdirs: %w[
          man/man*.Z
          contrib/man/man1.Z
          softbench/man/man*.Z
        ]
      },
      '9.10': {
        basedir: 'hp/hpux/9.10',
        srcdirs: %w[usr/man/man*]  # TODO: unbundled ?
      },
      '10.20': {
        basedir: 'hp/hpux/10.20',
        srcdirs: %w[man/man*]  # TODO: doc/ ?
      }
    }
  },
  'IBM': {
    disabled: true,
    'AIX': {
      '1.2.1': {
        #disabled: true,
        basedir: 'ibm/aix/1.2.1',
        srcdirs: %w[man/cat[1-8]]
      },
      '2.2.1': {
        #disabled: true,
        # REVIEW: 2.2.1-alt-src/
        basedir: 'ibm/aix/2.2.1',
        srcdirs: %w[man/man[1-7]]
      },
      '4.3.3': {
        disabled: true,
        # TODO: incomplete (infoexplorer/html manual?)
        basedir: 'ibm/aix/4.3.3',
        srcdirs: %w[
          share/man/man[1-8]
          dt/man/man*
        ]
      }
    },
    'AOS': {
      disabled: true,
      '4.3': {
        # REVIEW: 4.3 (unknown provenance)
        basedir: 'ibm/aos/4.3',
        srcdirs: %w[man/man[1-9nx]]
      }
    #},
    # TODO:
    #'VM/ESA': {
    #  'V2R3M0': {
    #    basedir: 'ibm/vm:esa/v2r3m0',
    #    srcdirs: %w[]
    #  }
    }
  },
  'Intergraph': {
    disabled: true,
    'CLIX': {
      '3.1r7.6.22': {
        basedir: 'intergraph/clix/3.1r7.6.22',
        srcdirs: %w[catman/man[0-8]]
      },
      '3.1r7.6.28': {
        basedir: 'intergraph/clix/3.1r7.6.28',
        srcdirs: %w[
          sysvdoc/catman/man[0-8]
          forms_s/catman
        ]
      }
    }
  },
  'mips': {
    disabled: true,
    'unbundled': {
      module_override: 'RISC-os',
      'RISCwindows_4.00': {
        basedir: 'mips/risc-os/unbundled/riscwindows/4.00',
        srcdirs: %w[usr/RISCwindows4.0/man/cat/man[13]]
      }
    },
    'RISC-os': {  # TODO: canonically, RISC/os
      '4.52': {
        basedir: 'mips/risc-os/4.52',
        srcdirs: %w[man/catman/?_man/*man[1-8]]
      },
      '5.01': {
        basedir: 'mips/risc-os/5.01',
        srcdirs: %w[share/man/catman/?_man/*man[1-8]]
      }
    }
  },
  'MIT': {
    disabled: true,
    'X10': {
      'R4': {
        basedir: 'mit/x10/r4',
        srcdirs: %w[doc/mann]
      }
    },
    'X11': {
      'R4': {
        basedir: 'mit/x11/r4',
        srcdirs: %w[man/man[3n]]
      }
    }
  },
  'Motorola': {
    disabled: true,
    'SysV': {
      '88k/FH40.42': {
        basedir: 'motorola/sysv-88k/R4/FH40.42',
        srcdirs: %w[usr/src/man/man[1-7]]
      },
      '88k/FH40.43': {
        basedir: 'motorola/sysv-88k/R4/FH40.43',
        srcdirs: %w[
          usr/src/man/man[1-7]
          usr/src/ddi_man/man[1-5]
        ]
      }
    }
  },
  'MWC': {
    disabled: true,
    'Coherent': {
      '3.1.0': {
        basedir: 'mwc/coherent/3.1.0',
        srcdirs: %w[
          man/ALL
          man/COHERENT
          man/MULTI
        ]
      }
    }
  },
  'NeXT': {
    disabled: true,
    'NEXTSTEP': {
      '1.0': {
        basedir: 'next/nextstep/1.0',
        srcdirs: %w[NextLibrary/Documentation/Unix/ManPages/man[1-8]]
      },
      '3.3': {
        basedir: 'next/nextstep/3.3',
        srcdirs: %w[NextLibrary/Documentation/ManPages/man[1-8]]
      },
      '4.0pr1': {
        basedir: 'next/nextstep/4.0pr1',
        srcdirs: %w[NextLibrary/Documentation/ManPages/man[1-8]]
      }
    },
    'OPENSTEP': {
      '4.2': {
        basedir: 'next/openstep/4.2',
        srcdirs: %w[NextLibrary/Documentation/ManPages/man[1-8]]
      }
    }
  },
  'Novell': {
    disabled: true,
    'UnixWare': {
      '2.01': {
        basedir: 'novell/unixware/2.01',
        srcdirs: %w[usr/share/man/cat[1-8]]
      }
    }
  },
  'Pixar': {
    disabled: true,
    'HSI': {
      'sun3/1.1': {  # use SunOS 4 defs
        basedir: 'pixar/hsi-sun3/1.1',
        srcdirs: %w[hsi/man/man[1-8]]
      }
    }
  },
  'SCO': {
    disabled: true,
    'OpenDesktop': {
      '3.0.0': {
        basedir: 'sco/odt/3.0.0',
        srcdirs: %w[man/cat.*]
      }
    },
    'Xenix': {
      #disabled: true,
      '2.3.4': {
        basedir: 'sco/xenix/2.3.4',
        srcdirs: %w[usr/man/cat.*]
      },
      '2.3.4g': {
        basedir: 'sco/xenix/2.3.4g',
        srcdirs: %w[man/cat.*]
      }
    }
  },
  'SGI': {
    disabled: true,
    'libiris': {  # using 4BSD defs?
      'R1c': {
        basedir: 'sgi/iris-lib/R1c',
        srcdirs: %w[man/man[13]]
      }
    },
    'GL1': {
      'W2.1': {
        basedir: 'sgi/gl1/w2.1',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W2.3': {
        basedir: 'sgi/gl1/w2.3',
        srcdirs: %w[man/?_man/man[1-8]]
      }
    },
    'GL2': {
      'W2.3': {
        basedir: 'sgi/gl2/w2.3',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W2.5': {
        basedir: 'sgi/gl2/w2.5',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W3.5r1': {
        basedir: 'sgi/gl2/w3.5r1',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W3.6': {
        basedir: 'sgi/gl2/w3.6',
        srcdirs: %w[usr/man/?_man/man[1-8]]
      }
    },
    'IRIX': {  # using 4BSD defs?
      '6.5.3f': {
        basedir: 'sgi/irix/6/5/3f',
        srcdirs: %w[
          share/catman/?_man/cat[1-8o]/*.z
          share/catman/?_man/cat[1-8o]/dmedia
          share/catman/?_man/cat[1-8o]/Inventor
          share/catman/?_man/cat[1-8o]/Performer_demo
          share/catman/?_man/cat[1-8o]/X11
          share/catman/?_man/cat[1-8o]/Xm
          share/catman/1_man/cat1/sysadm
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
      }
    }
  },
  'Solbourne': {
    disabled: true,
    'OS-MP': {
      '4.1': {
        basedir: 'solbourne/os-mp/4.1',
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.1A3': {
        basedir: 'solbourne/os-mp/4.1A3',
        srcdirs: %w[share/man/man[1-8]]
      },
      'unbundled/X11R5': {
        basedir: 'solbourne/os-mp/unbundled/x11r5',
        srcdirs: %w[man[13]]
      }
    }
  },
  'Sony': {
    disabled: true,
    'NEWS-os': {
      '4.2.1R/ja_JP': {
        basedir: 'sony/news-os/4.2.1R',
        srcdirs: %w[
          ja_JP.SJIS/man[1-8nop]
          Motif1.0/ja_JP.SJIS/man3
        ]
      },
      '5.0.1/en_US': {
        basedir: 'sony/news-os/5.0.1',
        # REVIEW: share/man.foon ??
        srcdirs: %w[
          share/man/*cat[1-8]
          X11/usr/man/man[13]
          X11/usr/man/Motif/man[13]
        ]
      }
    }
  },
  'Sun': {
    disabled: true,
    'Interactive': {
      '3.2r4.1': {
        basedir: 'sun/interactive/3.2r4.1',
        srcdirs: %w[
          man/mann
          man/u_man/man[1-8]
        ]
      }
    },
    'SunOS': {
      '0.3': {
        basedir: 'sun/sunos/0.3',
        srcdirs: %w[man/man[1-8]]
      },
      '0.4': {
        basedir: 'sun/sunos/0.4',
        srcdirs: %w[man/man[1-8]]
      },
      '1.0': {
        basedir: 'sun/sunos/1.0',
        srcdirs: %w[man/man[1-8]]
      },
      '1.1': {
        basedir: 'sun/sunos/1.1',
        srcdirs: %w[man/man[1-8]]
      },
      '1.4U': {
        basedir: 'sun/sunos/1.4U',
        srcdirs: %w[man/man[1-8]]
      },
      '2.0': {
        basedir: 'sun/sunos/2.0',
        srcdirs: %w[man/man[1-8]]
      },
      '2.2U': {
        basedir: 'sun/sunos/2.2-update',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '2.3U': {
        basedir: 'sun/sunos/2.3-update',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '3.0': {
        basedir: 'sun/sunos/3.0',
        srcdirs: %w[man/man[1-8]]
      },
      '3.2': {
        basedir: 'sun/sunos/3.2',
        srcdirs: %w[68010/man/man[1-8]]  # REVIEW: same as 68020?
      },
      '3.4': {
        basedir: 'sun/sunos/3.4',
        srcdirs: %w[man/man[1-8]]
      },
      '3.5': {
        basedir: 'sun/sunos/3.5',
        srcdirs: %w[man/man[1-8]]
      },
      '4.0': {
        basedir: 'sun/sunos/4.0',
        srcdirs: %w[
          share/man/man[1-8]
          unbundled/SC0.0/man/man[135]
        ]
      },
      '4.0.2': {
        basedir: 'sun/sunos/4.0.2',
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.0.3/sun3': {
        basedir: 'sun/sunos/4.0.3',
        srcdirs: %w[68020/share/man/man[1-8]]
      },
      '4.0.3/sun4': {
        basedir: 'sun/sunos/4.0.3',
        srcdirs: %w[sun4/share/man/man[1-8]]
      },
      '4.1.1': {
        basedir: 'sun/sunos/4.1.1',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[136n]
        ]
      },
      '4.1.4': {
        basedir: 'sun/sunos/4.1.4',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[1-8]
        ]
      },
      '5.5.1': {
        basedir: 'sun/sunos/5.5.1',
        srcdirs: %w[share/man/man[1-9]*]
      },
      '5.10': {
        basedir: 'sun/sunos/5.10',
        srcdirs: %w[
          share/man/man[1-9]*
          share/man/sman[1-9]*
        ]
      }
    }
  },
  'Tektronix': {
    disabled: true,
    'UTek': {
      '6130-W2.3': {
        basedir: 'tek/utek/6130/w2.3_2.3e',
        srcdirs: %w[
          man/cat[1-8]
          man/man1
        ]
      },
      '4319-3.0': {
        basedir: 'tek/utek/4319/3.0',
        srcdirs: %w[man/cat[1-8]]
      },
      '4319-4.0': {
        basedir: 'tek/utek/4319/4.0',
        srcdirs: %w[man/cat[1-8]]
      }
    }
  },
  'UCB': {
    disabled: true,
    '386BSD': {
      '1.0': {
        basedir: 'ucb/386bsd/1.0',
        srcdirs: %w[
          share/man/cat[1-9]*
          local/man/man[13578]
          X386/man/man[135]
        ] # REVIEW: local/man/man8 is a file, will probably cause a problem
      }
    },
    'BSD': {
      '4.3-VAX-MIT': {
        basedir: 'ucb/bsd/4.3-VAX-MIT',
        srcdirs: %w[usr/man/man[1-8]]
      }
    },
    'Sprite': {
      'KS.390': {
        basedir: 'ucb/sprite/KS.390',
        srcdirs: %w[
          man/*/*.man
          man/lib/*/*.man
        ]
      }
    }
  }
}

def timed_execute
  start = Time.now
  result = yield
  { result: result, time: Time.now - start }
end

file = nil
debug = false
clean = false
indir = '/Volumes/Museum/Manual/in'
outdir = '/Volumes/dev.online.typewritten.org/Manual'

args = ARGV.each
loop do
  begin
    arg = args.next
    case arg
    when '-in'     then indir  = args.next
    when '-out'    then outdir = args.next
    when '-clean'  then clean  = true # TODO: blank the output directory
    when '-debug'  then debug  = true
    when '-vendor'
      vendor = args.next.to_sym
      collections = collections.select { |k,v| k == vendor }
    when '-os'
      os = args.next.to_sym
      collections = collections.select { |k,v| v.has_key?(os) }
      vendor = collections.keys.first
      collections[vendor].reject! { |k,v| k != os }
    when '-ver' # let's just assume we already filtered on an os
      ver = args.next.to_sym
      vendor = collections.keys.first
      os = collections[vendor].keys.first
      collections[vendor][os].reject! { |k,v| k != ver }
    else
      file = arg
    end
  rescue StopIteration
    break
  end
end

#raise ArgumentError, 'need input and output directories!' if indir.empty? || outdir.empty?

css = "#{__dir__}/lib/assets/tslroff.css"
unless File.mtime(css) <= File.mtime("#{outdir}/tslroff.css")
warn File.mtime(css).inspect
warn File.mtime("#{outdir}/tslroff.css").inspect
  Process.spawn("cp #{css} #{outdir}")
  Process.wait
  puts "updated tslroff.css from lib/assets/"
end

collections.each do |vendor, oses|
  next if oses[:disabled]
  oses.each do |os, versions|
    next unless versions.is_a?(Hash)
    next if versions[:disabled]
    versions.each do |ver, params|
      next unless params.is_a?(Hash)
      next if params[:disabled]
      logtime = Time.now.strftime('%Y%m%d-%H%M%S')
      odir = "#{outdir}/#{vendor}/#{os}/#{ver}"
      system('mkdir', '-p', odir) unless Dir.exists?(odir)
      (params[:override] or params[:srcdirs]).each do |srcdir|
        os_module = versions[:module_override] || os
        ver_module = params[:version_override] || ver
        srcdir << "/#{file}" if file
        cmd = "#{__dir__}/bin/tslroff.rb -odir #{odir} -os #{os_module} -ver #{ver_module} #{indir}/#{params[:basedir]}/#{srcdir}"
        t = timed_execute {
          if debug
            Process.spawn(cmd)
          else
            Process.spawn(cmd, [:out, :err] => ["#{odir}/build_#{logtime}.log", File::CREAT|File::WRONLY|File::APPEND, 0644] )
          end
          Process.wait
        }
        puts "#{os} (#{ver}) completed #{srcdir} in #{t[:time]}s"
      end
      #t = timed_execute {
      #  Process.spawn("#{__dir__}/bin/chk404.rb #{outdir}/#{vendor}/#{os}/#{ver}/*",
      #                [:out, :err] => ["#{odir}/404s_#{logtime}.log", File::CREAT|File::WRONLY|File::APPEND, 0644])
      #  Process.wait
      #}
      #puts "#{os} (#{ver}) scanned for broken links in #{t[:time]}s"
    end
  end
end
