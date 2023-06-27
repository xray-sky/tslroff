#! /usr/bin/env ruby
#
# build.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 06/24/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
# Automate building of product manuals
#
# TODOs
#   unbundleds (output, plus REVIEW input collections which may be mixed)
#   manual.erb can't find the CSS with the extra level of directory structure (e.g. UTek)
# √   - fixed for now by absolute ref to css
#   cope with pages named 'index' (e.g. DG-UX 5.4R3.00 index(3C))
#     - possibly by providing top level all-sections index (permuted or otherwise?)
#   unlink 404 refs, probably after auditing whether they are really missing
#   rewrite links in "overlay" versions (e.g. DG-UX 4.31, 5.4.2T, etc.) to base manual
#   rewrite links in optional products (e.g. Apollo ada 1.0 links to ld(1)) to.. where exactly?
#   supplemental (non-man) docs recovered from mit afs
#   page titles for unbundled pages are messed up
#   assets failure if srcdirs[] is all files (*.htm - Inferno)
#

require 'fileutils'

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
  '_internal': {
    disabled: true,
    '_test': {
      '_pic': {
        basedir: '_test',
        srcdirs: %w[./pic*]
      },
      '_tbl': {
        basedir: '_test',
        srcdirs: %w[./stbl*]
      }
    }
  },
  'Acorn': {
    'RISCiX': {
      '1.2': {
        basedir: 'acorn/riscix/1.2',
        # REVIEW were the math functions moved to man0 to 'disable' them?
        # there are other BSD title pages etc. in man0, and a Makefile with Acorn (c)
        srcdirs: %w[
          share/man/man0/*.3m
          share/man/man[1-8]
        ]
      }
    }
  },
  'Alias': {
    '1': {
      module_override: 'GL2',
      'v2.1': {
        version_override: 'W3.6',
        basedir: 'alias/1/2.1',
        srcdirs: %w[iris]
      }
    }
  },
  'Apollo': {
    'unbundled': {
      module_override: 'DomainOS',
      'ada_1.0': {
        basedir: 'apollo/domain_os/unbundled/ada_1.0',
        srcdirs: %w[bsd4.2/usr/man/man[13]] # TODO + doc/*release_notes
      },
      'cc_4.6': {
        basedir: 'apollo/domain_os/unbundled/cc_4.6',
        srcdirs: %w[sys/help] # TODO + doc/*release_notes
      },
      'cc_5.5': {
        basedir: 'apollo/domain_os/unbundled/cc_5.5',
        srcdirs: %w[sys/help] # TODO + doc/*release_notes
      },
      'cc_6.9': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/cc.hlp] # TODO + doc/*release_notes
      },
      'dpcc_3.5': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/dpcc*.hlp] # TODO + doc/*release_notes
      },
      'ftn_10.9': {
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/ftn.hlp] # TODO + doc/*release_notes
      },
      'lisp_2.0': { # DOMAIN LISP
        disabled: true, # TODO release_notes
        basedir: 'apollo/domain_os/unbundled/lisp_2.0',
        srcdirs: %w[doc]
      },
      'lisp_4.0': { # Common LISP
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/*lisp.hlp] # REVIEW these are all three the same, what is the extent to which I care?
      },
      'nfs_1.0': {
        basedir: 'apollo/domain_os/unbundled/nfs_1.0',
        srcdirs: %w[bsd4.2/usr/man/man[58]] # TODO + doc/*release_notes ; REVIEW cat[58] also present
      },
      'pascal_7.54': {
        basedir: 'apollo/domain_os/unbundled/pascal_7.54',
        srcdirs: %w[sys/help] # TODO + doc/*release_notes
      },
      'pascal_8.8': { # REVIEW what version _is_ this??
        basedir: 'apollo/domain_os/10.3.5',
        srcdirs: %w[sys/help/pas.hlp] # TODO + doc/*release_notes
      },
      'tcpbsd_3.0': {
        disabled: true, # TODO release_notes
        basedir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.0',
        srcdirs: %w[doc]
      },
      'tcpbsd_3.1': {
        basedir: 'apollo/domain_os/unbundled/tcpbsd4.2_3.1',
        srcdirs: %w[bsd4.2/usr/man/man[18]] # TODO + doc/*release_notes
      }
    },
    'Aegis': {
      'SR9.7.5': {
        # TODO (what though?) unbundled products for sure (lisp)
        basedir: 'apollo/domain_os/9.7.5',
        srcdirs: %w[sys/help/*]
      }
    },
    'DomainIX': {
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
        # TODO (what though?) unbundled products for sure (lisp)
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
        # TODO (what though?) unbundled products for sure (lisp)
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
        # TODO (what though?) unbundled products probably (pascal, fortran, etc.)
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
    'A-UX': { # A/UX
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
      disabled: true, # requires groff, totally new macro package
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
    'SysV': {
      module_override: 'Ardent_SysV',
      'R3.0': {
        basedir: 'ardent/sysv/3.0',
        srcdirs: %w[
          man/man[1-8]
          man/bsd/man[1-3]
        ]
      },
      'R4.1': {
        basedir: 'ardent/sysv/4.1',
        srcdirs: %w[
          man[1-8]
          bsd/man[1-3]
        ]
      },
      'R4.2': {
        basedir: 'ardent/sysv/4.2',
        srcdirs: %w[
          man[1-8]
          bsd/man[1-3]
        ]
      }
    }
  },
  'Atari': {
    'SysV': {
      # TODO sort out differences & local changes. are these separate releases??
      module_override: 'Atari_SysV',
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
    # TODO graphics assets - the gifs in the R3 ./graphics/ & pressinfo/resources (not belogos/) directories are macbinary encoded! - must decode first
    # TODO are there actually metrowerks docs for R4 and earlier, somewhere other than develop/BeIDE?
    'BeOS': {
      'PR2': {
        assets: %w(*.jp*g *.[gG][iI][fF] *.pdf),
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
        assets: %w(*.jp*g *.[gG][iI][fF] *.map *.tiff *.eps),
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
        assets: %w(*.jp*g *.[gG][iI][fF] *.eps),
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
        assets: %w(*.jp*g *.[gG][iI][fF]),
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
        assets: %w(*.jp*g *.[gG][iI][fF]),
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
    'Inferno': {
      '1ed': {
        assets: %w[*.gif],
        basedir: 'bell/inferno/1e0',
        srcdirs: %w[man/html/*.htm]
      },
      '1.1ed': {
        assets: %w[*.gif],
        basedir: 'bell/inferno/1e1src',
        srcdirs: %w[man/html/*.htm]
      },
      '3ed': {
        basedir: 'bell/inferno/3e',
        srcdirs: %w[man/[1-9]*]
      },
      '4ed': {
        basedir: 'bell/inferno/4e',
        srcdirs: %w[man/[1-9]*]
      }
    },
    'Plan9': {
      '3ed': { # this is from my Vita Nuova disc - doesn't seem the same as Inferno 3ed, above
        disabled: true, # TODO macros REVIEW is it plan9 or is it inferno
        basedir: 'bell/plan9/3e',
        srcdirs: %w[usr/inferno/man/[1-9]*]
      },
      '4ed': {
        basedir: 'bell/plan9/4e',
        srcdirs: %w[man/[1-8]]
      }
    },
    'UNIX': {
      'V6': {
        # TODO also contains a lot of papers for as, cc, etc.
        #      where are the macro defs? - used lib/macros/an6 from gl2-w2.5
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
        version_override: 'V7',
        basedir: 'bell/unix/32v',
        srcdirs: %w[
          usr/man/man[1-8]
          usr/man/man0/intro
        ]
      },
      'SysIII': { # where'd I get this manual? need lib/macros/an
        # TODO also contains a lot of papers for as, cc, etc.
        disabled: true,
        basedir: 'bell/unix/sysiii',
        srcdirs: %w[
          usr/src/man/man[1-8]
          usr/src/man/man0/intro
        ]
      }
    }
  },
  'Commodore': {
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
    'CX-UX': { # CX/UX
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
    # TODO there's a bunch more releases / tapes to check
    #      not clear on all the various releases/differences etc.
    # TODO arrange output dirs better
    'thirdparty': {
      'Ultrix/Transarc_AFS_3.2/mips': {
        module_override: 'Ultrix',
        version_override: '4.2.0', # REVIEW correct?
        basedir: 'dec/ultrix/thirdparty/transarc_afs_3.2',
        srcdirs: %w[man/man1]
      }
    },
    'unbundled': {
      'Tru64/ACMSxp_3.2A': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/acm32a', # TODO uses rsml/sml macros
        srcdirs: %w[usr/opt/ACMSXPV32A/man/man[138]]
      },
      'Tru64/BASEstar_Open_Server_3.2': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/bst320',
        srcdirs: %w[
          usr/opt/BCF220/man/man1
          usr/opt/bstman320/man/man[13]
          usr/share/man/man3
        ]
      },
      'Ultrix/C_1.0/VAX': {
        module_override: 'Ultrix',
        version_override: '4.2.0', # REVIEW correct?
        basedir: 'dec/ultrix/unbundled/vax_c_1.0',
        srcdirs: %w[usr/man/man1]
      },
      'Tru64/C++_6.2': {
        module_override: 'OSF1',
        version_override: '4.0f',
        assets: %w[*.gif *.ps *.pdf],
        basedir: 'dec/du/unbundled/cxx620',
        srcdirs: %w[usr/share/doclib/cplusplus/*.htm] # TODO html support
      },
      'Tru64/COBOL_2.6': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/dca260',
        srcdirs: %w[usr/lib/cmplrs/cobol_260]
      },
      'Tru64/DCE_3.1': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/dce310', # TODO wth is up with the section 1 pages (others - some are "normal" though - 3rpc, 3sec are)
        srcdirs: %w[usr/opt/DCE310/man/man[1-8]]
      },
      'Ultrix/DECnet_3.0/VAX': {
        module_override: 'Ultrix',
        version_override: '4.2.0',
        basedir: 'dec/ultrix/unbundled/decnet_vax_3.0',
        srcdirs: %w[usr/man/man[1238]]
      },
      'Ultrix/DECnet_SNA_1.0': {
        module_override: 'Ultrix',
        version_override: '4.2.0', # REVIEW correct?
        basedir: 'dec/ultrix/unbundled/decnetsna_1.0',
        srcdirs: %w[usr/man/man1]
      },
      'Digital_UNIX/DECnet_OSI_4.0C': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/dna40c',
        srcdirs: %w[usr/opt/DNA403/share/man/man[158]]
      },
      'Tru64/DECnet-Plus_5.0': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/dna500',
        srcdirs: %w[usr/opt/DNA500/share/man/man[158]]
      },
      'Digital_UNIX/DECnet_WAN_Support_3.0A': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/xxa30a',
        srcdirs: %w[usr/opt/[WX]?A300/share/man/man[123478]]
      },
      'Tru64/DECnet_WAN_Support_3.1': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/xxa310',
        srcdirs: %w[usr/opt/[WX]?A310/share/man/man[123478]]
      },
      'Digital_UNIX/DECosap_AP_3.1': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/sap310',
        srcdirs: %w[usr/share/man/man3]
      },
      'Tru64/Diskless_Driver_2.01': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/ddu201',
        srcdirs: %w[usr/man/man[78]]
      },
      'OSF1/DSM_Japanese_1.0E': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/jds10e',
        srcdirs: %w[usr/opt/JDS105/man/man1] # ja_JP page also - but is identical to en_US page
      },
      'Digital_UNIX/EDI_3.2': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/dedi320',
        srcdirs: %w[
          usr/opt/DEDIAMSGMAN320/usr/man/man8
          usr/opt/DEDICLTMAN320/usr/man/man[13]
          usr/opt/DEDISERVMAN320/usr/man/man8
        ]
      },
      'Digital_UNIX/Extended_Math_Library_3.4': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/xmd340',
        srcdirs: %w[usr/opt/XMDMAN340/man]
      },
      'OSF1/F-RJE_1.0': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/fjr100', # have to use OSF1 to convert deckanji encoding to something we can cope with
        #srcdirs: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man*]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man*] # iconv giving ¥ instead of \
        srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man*]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.eucJP/man/man*]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.ISO-2022-JP/man/man*]
      },
      'Ultrix/FORTRAN_1.0/mips': {
        module_override: 'Ultrix',
        version_override: '4.2.0', # REVIEW correct?
        basedir: 'dec/ultrix/unbundled/fortran_mips_1.0',
        srcdirs: %w[usr/man/man[13]]
      },
      'Tru64/FORTRAN_5.3': {
        module_override: 'OSF1',
        version_override: '4.0f',
        assets: %w[*.gif],
        basedir: 'dec/du/unbundled/dfa530',
        srcdirs: %w[
          usr/lib/cmplrs/fort*_530/*.man
          usr/lib/cmplrs/fort*_530/relnotes*
          usr/opt/XMDMAN360/man/*.3*
          usr/opt/XMDHTM360/cxml_webpages/*.html
        ]
      },
      'Tru64/FUSE_4.2/en_US': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/fus420',
        srcdirs: %w[usr/opt/FUS420/man/man1]
      },
      'Tru64/FUSE_4.2/ja_JP': { # ja_JP pages also
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/fus420',
        srcdirs: %w[usr/opt/FUS420/man/ja_JP.SJIS/man1]
      },
      'Digital_UNIX/InfoBroker_Server_2.2': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/ibx220',
        srcdirs: %w[usr/share/man/man[38]]
      },
      'Tru64/Micro_Focus_COBOL_4.1B': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/mfc41b',
        srcdirs: %w[usr/lib/cmplrs/cob_413]
      },
      'Digital_UNIX/Multimedia_Services_2.4B': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/mme24b',
        srcdirs: %w[usr/opt/MME242/share/man/man[1347]]
      },
      'Digital_UNIX/MAILbus_400_2.0C': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/mtaa20c',
        srcdirs: %w[usr/opt/MTAAMAN202/usr/share/man/man3]
      },
      'Tru64/Open3D_4.96': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/o3d496', # TODO 3gl pages have no section regex match
        srcdirs: %w[usr/man/man[13]]
      },
      'Digital_UNIX/Optical_Storage_Management_1.6': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/osms160',
        srcdirs: %w[usr/man/man[14578]]
      },
      'Tru64/Pascal_5.7': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/dpo570',
        srcdirs: %w[usr/lib/cmplrs/pc_570]
      },
      'Tru64/Parallel_Software_Environment_1.9': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/pse190',
        srcdirs: %w[usr/opt/PVM190/man/man[13]]
      },
      'Digital_UNIX/PHIGS_5.1': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/pho510',
        srcdirs: %w[usr/man/man3]
      },
      'Digital_UNIX/POLYCENTER_Intrusion_Detector_1.2A': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/ido12a',
        srcdirs: %w[usr/opt/IDOA12A/usr/share/man/man[58]]
      },
      'Digital_UNIX/POLYCENTER_Security_Compliance_Manager_2.5': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/soa250',
        srcdirs: %w[usr/opt/SOA250/man/man8]
      },
      'Tru64/Powerstorm_4D_5.0B': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/prs50b',
        srcdirs: %w[usr/man/man3]
      },
      'OSF1/PrintServer_5.1': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/lps520',
        srcdirs: %w[usr/opt/LPS/man/*.[18]]
      },
      'Digital_UNIX/PrintServer_Japanese_5.1': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/jls510',
        #srcdirs: %w[usr/i18n/share/ja_JP.deckanji/man/man[18]]
        #srcdirs: %w[xlated/usr/i18n/share/ja_JP.UTF-8/man/man[18]]
        srcdirs: %w[xlated/usr/i18n/share/ja_JP.SJIS/man/man[18]]
      },
      'OSF1/SNA_3270_Datastream_Programming_Japanese_1.0': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/sjd100',
        #srcdirs: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
        srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]
      },
      'OSF1/SNA_Printer_Emulator_Japanese_1.0': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/sjp100',
        #srcdirs: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[18]]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[18]]
        srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[18]]
      },
      'OSF1/SNA_RJE_1.0': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/sjr100',
        #srcdirs: %w[usr/opt/*/usr/i18n/usr/share/ja_JP.deckanji/man/man[138]]
        #srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.UTF-8/man/man[138]]
        srcdirs: %w[xlated/usr/opt/*/usr/i18n/usr/share/ja_JP.SJIS/man/man[138]]
      },
      'OSF1/SNA_DECwindows_3270_Emulator_Japanese_2.1A': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/snja21a',
        srcdirs: %w[usr/opt/*/usr/i18n/usr/share/man/man[18]]
      },
      'Digital_UNIX/SNA_APPC_LU6.2_Programming_3.2': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/snp320',
        srcdirs: %w[usr/share/man/man3]
      },
      'Tru64/SNA_APPC_LU6.2_Programming_4.0': {
        module_override: 'OSF1',
        version_override: '4.0f',
        basedir: 'dec/du/unbundled/snp400',
        srcdirs: %w[usr/share/man/man3]
      },
      'Digital_UNIX/SNA_LUA_Programming_1.0': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/snalu100',
        srcdirs: %w[usr/opt/SNALUA100/usr/man/man3]
      },
      'Digital_UNIX/SNA_TN3270-C_1.0': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/tnc100',
        srcdirs: %w[usr/tn3270c/manpages]
      },
      'Ultrix/SQL_1.0/mips': {
        module_override: 'Ultrix',
        version_override: '4.2.0', # REVIEW correct?
        basedir: 'dec/ultrix/unbundled/sql_mips_1.0',
        srcdirs: %w[usr/man/man[18]]
      },
      'Digital_UNIX/StorageWorks_HSZ40_1.1A': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/swa11a',
        srcdirs: %w[usr/opt/SWA11A/usr/share/man/man8]
      },
      'Digital_UNIX/TeMIP_Framework_3.2A': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/tfr32a',
        srcdirs: %w[usr/*/manp]
      },
      'OSF1/Watchdog_Autopilot_2.1': {
        module_override: 'OSF1',
        version_override: '3.2c',
        basedir: 'dec/du/unbundled/wdx210',
        srcdirs: %w[usr/share/man/man[58]]
      },
      'Digital_UNIX/X.500_3.1': {
        module_override: 'OSF1',
        version_override: '4.0d',
        basedir: 'dec/du/unbundled/dxd310',
        srcdirs: %w[usr/opt/DXDAMAN310/usr/share/man/man3]
      }
    },
    'Ultrix': {
      'WS-1.1': { # tmac.an.repro no different from 2.0.0
        version_override: '2.0.0',
        basedir: 'dec/ultrix/ws-1.1',
        srcdirs: %w[usr/man/man[1-8]]
      },
      # AQ-NC13A/B-BE
      # what about AQ-KU57B-BE??
      'WS-2.0/VAX': { # includes unsupported REVIEW where's the X pages? tmac.an.repro no different from 2.0.0
        version_override: '2.0.0',
        basedir: 'dec/ultrix/ws-2.0/vax',
        srcdirs: %w[
          usr/man/man[1-8]
          usr/new/man/man[15]
        ]
      },
      '2.0': { # from source, + unsupported filesets (not in srcdist)
        version_override: '2.0.0',
        basedir: 'dec/ultrix/2.0.0',
        srcdirs: %w[
          src/usr/man/man[1-8]
          src/new/*/man/*.[1-8]
          src/new/rcs/man/man[15]/*.[1-8]
          src/new/spms/man/catn/spmsintro.n
          src/new/spms/man/man3/pgrep.3p
          src/new/spms/man/mann/*.n
          usr/man/man[1-8]
          usr/new/man/man[15]
          usr/new/news/man
        ]
      },
      '3.1+WS-2.2/VAX': { # same manual content, PB30B vs. PB30A tapes
        version_override: '3.1.0',
        basedir: 'dec/ultrix/3.1+ws-2.2_update/vax',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '3.1D/mips': { # 3.1D supported subsets (check macros)
        version_override: '3.1.0',
        basedir: 'dec/ultrix/3.1d/mips',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '4.0/mips': { # UWS 4.0 unsupported subsets + supported vol2
        version_override: '4.0.0/mips',
        basedir: 'dec/ultrix/4.0.0/mips',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '4.0/VAX': { # UWS 4.0 supported & unsupported subsets
        version_override: '4.0.0/vax',
        basedir: 'dec/ultrix/4.0.0/vax',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '4.1/mips': { # UWS 4.1 unsupported subsets + supported vol2
        version_override: '4.1.0/mips', # check macros
        basedir: 'dec/ultrix/4.1.0/mips',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '4.2/VAX': { # from source
        version_override: '4.2.0',
        basedir: 'dec/ultrix/4.2.0',
        srcdirs: %w[src/usr/man/_vax.d/man[1-8]]
      },
      '4.2/mips': { # from source
        version_override: '4.2.0',
        basedir: 'dec/ultrix/4.2.0',
        srcdirs: %w[src/usr/man/_mips.d/man[1-8]]
      },
      '4.4/mips': { # UWS 4.4 unsupported subsets + supported vol2
        version_override: '4.4.0/mips',
        basedir: 'dec/ultrix/4.4.0/mips',
        srcdirs: %w[usr/man/man[1-8]]
      },
      '4.5.1/mips': {
        basedir: 'dec/ultrix/4.5.1_mips',
        srcdirs: %w[man/man[1-8]]
      }
    },
    'OSF1': {
      'SILVER_Baselevel_4_rev36': {
        # DEC OSF/1 SILVER Baselevel 4 (Rev. 36) for MIPS from tenox - prerelease for mips TODO tmac.an
        basedir: 'dec/osf1/silver4_r36_mips',
        srcdirs: %w[usr/share/man/man[1-8]]
      },
      '1.0/mips': {
        # DEC OSF/1 V1.0 (TIN) for MIPS from tenox - TODO tmac.an
        basedir: 'dec/osf1/1.0_tin_mips',
        srcdirs: %w[usr/share/man/man[1-8]]
      },
      'X2.0-8/mips': {
        # DEC OSF/1 X2.0-8 (Rev. 155) for MIPS from tenox - TODO tmac.an
        basedir: 'dec/osf1/2.0-8_mips',
        srcdirs: %w[usr/share/man/man[1-8]]
      },
      '3.0': {
        version_override: '3.2c', # identical apart from (c) date
        basedir: 'dec/osf1/3.0',
        srcdirs: %w[share/man/man[1-8]]
      }
    },
    'Digital_UNIX': {
      '3.2c': {
        basedir: 'dec/du/3.2c',
        srcdirs: %w[
          usr/share/man/man[1-8]
          usr/dt/share/man/man[1-6]
          usr/opt/XR6320/X11R6/man/man[3n]
        ]
      },
      '4.0d': {
        basedir: 'dec/du/4.0d',
        srcdirs: %w[
          usr/share/man/man[1-8]
          usr/dt/share/man/man[1-5]*
        ]
      }
    },
    'Tru64': {
      module_override: 'OSF1',
      '4.0f': {
        basedir: 'dec/tru64/4.0f',
        srcdirs: %w[
          usr/share/man/man[1-8]
          usr/dt/share/man/man[1-5]*
        ]
      },
      '5.0a': {
        basedir: 'dec/tru64/5.0a',
        srcdirs: %w[
          usr/share/man/man[1-9]
          usr/dt/share/man/man[1-6]*
        ]
      },
      '5.1b': {
        basedir: 'dec/tru64/5.1b',
        srcdirs: %w[
          usr/share/man/man[1-9]
          usr/dt/share/man/man[1-5]
        ]
      }
    },
    'MicroVMS': {
      '4.4': {
        basedir: 'dec/microvms/4.4',
        srcdirs: %w[
          */?
          sys0/syshlp
        ]
      },
      '4.5B': { # is this the same as 4.4? - yes
        basedir: 'dec/microvms/4.5B',
        srcdirs: %w[
          */?
          sys0/syshlp
        ]
      },
      '4.6': { # is THIS the same as 4.4?? - no
        basedir: 'dec/microvms/4.6',
        srcdirs: %w[
          options/*/?
          sys0/syshlp
        ]
      }
    },
    'VMS': {
      '4.6': {
        basedir: 'dec/vms/4.6',
        srcdirs: %w[sys0/syshlp]
      },
      '5.0': {
        basedir: 'dec/vms/5.0',
        srcdirs: %w[sys0/syshlp]
      },
      '5.1-B': {
        basedir: 'dec/vms/5.1-B',
        srcdirs: %w[sys0/syshlp]
      },
      '5.2': {
        basedir: 'dec/vms/5.2',
        srcdirs: %w[sys0/syshlp]
      },
      '5.4': {
        basedir: 'dec/vms/5.4',
        srcdirs: %w[sys0/syshlp]
      },
      '5.4-3': { # update only
        basedir: 'dec/vms/5.4-3',
        srcdirs: %w[
          latmaster/lat_kit/0543_a
          savesets/saveset_[cd]
        ]
      },
      '5.5': {
        basedir: 'dec/vms/5.5',
        srcdirs: %w[sys0/syshlp]
      },
      '5.5-2H4': {
        basedir: 'dec/vms/5.5-2H4',
        srcdirs: %w[sys0/syshlp]
      }
    }
  },
  'DG': {
    #disabled: true,
    'DG-UX': {
      # TODO canonically, 'DG/UX'
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
      },
      'R4.11': {
        basedir: 'dg/dgux/R4.11',
        srcdirs: %w[
          catman/?_man/man[0-8]
          catman/man[358]
          catman/sdk_man/man[1-6]
        ]
      },
      'R4.11MU05': {
        version_override: 'R4.11',
        basedir: 'dg/dgux/R4.11MU05',
        srcdirs: %w[
          catman/?_man/man[0-8]
          catman/man[358]
          catman/sdk_man/man[1-6]
        ]
      }
    }
  },
  'Gould': {
    #disabled: true,
    'GDT-UNX': {
      '6.8_er0': {
        # TODO man1/adb.1 vs. man1/adb.1.orig etc.
        #       divergences in cat[n] apart from n=9?
        basedir: 'gould/gdt-unx/6.8_er0',
        srcdirs: %w[
          man/cat9
          man/man[1-8l]
        ]
      },
      '6.8_er0_nroff': {
        # enabled to facilitate comparision of preprocessed vs. source manuals
        basedir: 'gould/gdt-unx/6.8_er0',
        srcdirs: %w[man/cat[1-9l]]
      }
    }
  },
  'HP': {
    #disabled: true,
    'unbundled': {
      module_override: 'HPUX',
      'ANSI-C_A09.00/S300': { # TODO has links to base HPUX pages
        version_override: '9.05',
        basedir: 'hp/hpux/unbundled/ansi-c/A.09.00-S300',
        srcdirs: %w[usr/man/man[12345].Z]
      },
      'ANSI-C_A10.11/S700': { # TODO there's some Japanese language manual pages in here, too
        version_override: '10.20',
        basedir: 'hp/hpux/unbundled/ansi-c/A.10.11-S700',
        srcdirs: %w[
          */*/opt/imake/man/man1.Z
          */*/usr/share/man/man[1-8]*.Z
          */*/opt/*/share/man/man[1-8].Z
          */*/opt/graphics/*/share/man/man[1-8].Z
        ]
      },
      'C++_A.03.20/S300': { # REVIEW has extra man macros in usr/CC/man/SC/manmacros
        version_override: '9.05',
        basedir: 'hp/hpux/unbundled/c++/A.03.20-S300',
        srcdirs: %w[
          usr/man/man3
          usr/man/man[13].Z
          usr/CC/man/SC/man[134]
        ]
      },
      'DATIO_1.2': {
        version_override: '8.05',
        basedir: 'hp/hpux/unbundled/datio/1.2',
        srcdirs: %w[usr/man/man1.Z]
      },
      'Instrument-Control-Lib_C.03.01': {
        version_override: '9.05',
        basedir: 'hp/hpux/unbundled/instrument-control-lib/C.03.01',
        srcdirs: %w[usr/man/man*]
      },
      'Instrument-Control-Lib_G.03.00': {
        version_override: '9.05',
        basedir: 'hp/hpux/unbundled/instrument-control-lib/G.03.00',
        srcdirs: %w[
          opt/sicl/share/man/man*
          opt/vxipnp/hpux/hpvisa/share/man/man3
        ]
      },
      'Network-Peripheral-Interface_A.02.00': {
        version_override: '8.05',
        basedir: 'sun/sunos/unbundled/hp_npi_a.02.00',
        srcdirs: %w[usr/lib/hpnp/hp-man/man[14]*.Z]
      },
      'PersonalVisualizer_2.11/S700': {
        version_override: '8.05',
        basedir: 'hp/hpux/unbundled/personalvisualizer/2.11-S700',
        srcdirs: %w[usr/man/man[13].Z]
      },
      'PowerShade_A.B1.00/S700': {
        version_override: '8.05',
        basedir: 'hp/hpux/unbundled/powershade/A.B1.00-S700',
        srcdirs: %w[usr/man/man1.Z]
      },
      'SCPI_B.02.00/S300': {
        version_override: '8.05',
        basedir: 'hp/hpux/unbundled/scpi/B.02.00-S300',
        srcdirs: %w[usr/hp75000/man/man[135]]
      }
    },
    'OSF1': {
      # A.01.00_BL50 HP_OSF1 1.0
      # from plamen; incomplete - need tmac.an (for now, pretend it's the same as DEC?)
      # disc 2 only - products:
      #  • C++ Compiler 2.1
      #  • Developer's Kit 1.0
      #  • Pascal Compiler 1.0
      '1.0': {
        basedir: 'hp/osf1/a.01.00_bl50',
        srcdirs: %w[
          usr/CC/man/man[13]
          man-assembler/files/usr/share/man/man1
          man-ccs/files/usr/share/man/man[13]
          man-dde/files/usr/dde/man/man1
          man-devenv/files/usr/local/sdm/man/man[15]
          man-ncs/files/usr/share/man/man[13]
          man-x11r4/files/usr/share/man/man[134]
          pascal~58a4/man/files/usr/pas/man/man1
        ]
      }
    },
    'HPUX': {
      '5.00': { # refs S200 and S500, presumably either set will be the same?
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
      '6.00': { # TODO fix file dates (in 2021)
        basedir: 'hp/hpux/6.00',
        srcdirs: %w[S300/usr/man/man*.Z]
      },
      '6.20': {
        basedir: 'hp/hpux/6.20',
        srcdirs: %w[S300/usr/man/man*.Z]
      },
      '7.01': { # REVIEW appears incomplete. where'd it come from?
        disabled: true, # no tmac support yet
        basedir: 'hp/hpux/7.01',
        srcdirs: %w[usr/man/man*]
      },
      '7.03': { # REVIEW appears incomplete. where'd it come from?
        disabled: true, # no tmac support yet
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
      '8.07': { # REVIEW pages claim to be 8.05? is that payload from the entry? tmac is identical to 9.05 (must be, 9.0 shares tmac and pages say 9.0)
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
        basedir: 'hp/hpux/9.04\ \(S800\ HP-PA\ Support\)',
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
        srcdirs: %w[usr/man/man*] # TODO unbundled stuff mixed in ?
      },
      '10.20': {
        basedir: 'hp/hpux/10.20',
        srcdirs: %w[man/man*] # TODO + doc/ ?
      }
    }
  },
  'IBM': {
    #disabled: true,
    'AIX': {
      '1.2.1': {
        #disabled: true,
        basedir: 'ibm/aix/1.2.1',
        srcdirs: %w[man/cat[1-8]]
      },
      '2.2.1': {
        #disabled: true,
        # REVIEW 2.2.1-alt-src/
        basedir: 'ibm/aix/2.2.1',
        srcdirs: %w[man/man[1-7]]
      },
      '4.3.3': {
        disabled: true,
        # TODO incomplete (infoexplorer/html manual?)
        basedir: 'ibm/aix/4.3.3',
        srcdirs: %w[
          share/man/man[1-8]
          dt/man/man*
        ]
      }
    },
    'AOS': {
      #disabled: true,
      '4.3': {
        # REVIEW 4.3 (unknown provenance)
        basedir: 'ibm/aos/4.3',
        srcdirs: %w[man/man[1-9nx]]
      },
      '4.3/supplemental': { # this is -mm source for supplemental IBM/4.3 doc, recovered from mit.edu afs
        disabled: true,
        version_override: '4.3',
        basedir: 'ibm/aos/ibmdoc',
        srcdirs: %w[] # TODO
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
    #disabled: true,
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
  'Kodak': {
    'Interactive': {
      '2.2': {
        basedir: 'kodak/interactive/2.2',
        srcdirs: %w[
          progman/new/usr/catman/p_man/man[1-5]
          userman/new/usr/catman/u_man/man[178]
        ]
      }
    }
  },
  'mips': {
    'unbundled': {
      module_override: 'RISC-os',
      'RISCwindows_4.00': {
        basedir: 'mips/risc-os/unbundled/riscwindows/4.00',
        srcdirs: %w[usr/RISCwindows4.0/man/cat/man[13]]
      }
    },
    'RISC-os': { # TODO canonically, RISC/os
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
    'SysV': {
      module_override: 'Motorola_SysV',
      'MC88000/FH40.42': {
        basedir: 'motorola/sysv-88k/R4/FH40.42',
        srcdirs: %w[usr/src/man/man[1-7]]
      },
      'MC88000/FH40.43': {
        basedir: 'motorola/sysv-88k/R4/FH40.43',
        srcdirs: %w[
          usr/src/man/man[1-7]
          usr/src/ddi_man/man[1-5]
        ]
      }
    }
  },
  'MWC': {
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
  'NBI': {
    '4.2BSD': {
      module_override: 'NBI_4.2BSD',
      '3.04v10.B': { # TODO these were not extracted cleanly. they're almost but not quite tar files - there's garbage in many files
        basedir: 'nbi/4.2bsd/3.04v10.b',
        srcdirs: %w[man/man[1-8]]
      }
    }
  },
  'NeXT': {
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
    'UnixWare': {
      '2.01': {
        basedir: 'novell/unixware/2.01',
        srcdirs: %w[usr/share/man/cat[1-8]]
      }
    }
  },
  'SCO': {
    'unbundled': {
      module_override: 'OpenDesktop',
      'LLI_3.1.0j': {
        basedir: 'sco/unbundled/lli-r3.1.0j',
        srcdirs: %w[usr/man/cat.*]
      },
      'TCPIP_1.2.0i': {
        basedir: 'sco/unbundled/tcpip-1.2.0i',
        srcdirs: %w[usr/man/cat.*]
      }
    },
    'OpenDesktop': {
      '1.0.0y': {
        basedir: 'sco/odt/1.0.0y',
        srcdirs: %w[usr/man/cat.*]
      },
      '1.1.0': {
        basedir: 'sco/odt/1.1.0',
        srcdirs: %w[usr/man/cat.*]
      },
      '1.1.1g': {
        basedir: 'sco/odt/1.1.1-update-g',
        srcdirs: %w[usr/man/cat.*]
      },
      'X11R4-EFS-4.1.1b': {
        basedir: 'sco/odt/x11r4-efs-r4.1.1b',
        srcdirs: %w[usr/man/cat.*]
      },
      '3.0.0': {
        basedir: 'sco/odt/3.0.0',
        srcdirs: %w[man/cat.*]
      }
    },
    'Xenix': {
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
  'Sequent': {
    disabled: true,
    # TODO macros, etc.
    # TODO blacklist Makefile, RCS dir
    # TODO extra docs (BSD), maybe
    'DYNIX': {
      '3.0.17': {
        basedir: 'sequent/dynix/3.0.17',
        srcdirs: %w[
          src/doc/man[1-8]
          src.nfs/doc/man/man[1-8]
        ]
      },
      '3.2.0': {
        basedir: 'sequent/dynix/3.2.0',
        srcdirs: %w[
          src/doc/man[1-8]
          src.nfs/doc/man/man[1-8]
        ]
      }
    }
  },
  'SGI': {
    'thirdparty': {
      'C-TAD_Look-In': {
        basedir: 'sgi/thirdparty/ctad_lookin',
        srcdirs: %w[lookin.man] # nroff
      },
      'SynOpSys_Synthesis_3.1a': { # TODO needs section detecting
        module_override: 'GL2', # TODO only it ain't, it's 4D1, but I ain't got a macro package for that yet
        basedir: 'sgi/thirdparty/synopsys_core_synthesis_3.1a',
        srcdirs: %w[
          doc/license/man/man1
          doc/syn/man/cat[123n]
        ] # there is also doc/syn/man/fmt[123n] that contains C/A/T typesetter output from troff. presumably this will never be usable for us.
      },
      'Wolfram_Mathematica': {
        module_override: 'GL2', # TODO only it ain't, it's 4D1, but I ain't got a macro package for that yet
        basedir: 'sgi/thirdparty/mathematica',
        srcdirs: %w[Install/man]
      }
    },
    'libiris': { # using 4BSD macros?
      'R1c': {
        module_override: 'BSD',
        version_override: '4.3-VAX-MIT',
        basedir: 'sgi/iris-lib/R1c',
        srcdirs: %w[man/man[13]]
      }
    },
    'GL1': { # REVIEW split out options? or leave mixed.
      module_override: 'GL2',
      'W2.1': {
        basedir: 'sgi/gl1/w2.1',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W2.3': {
        basedir: 'sgi/gl1/w2.3',
        srcdirs: %w[
          man/?_man/man[1-8]
          options/usr/man/?_man/man[1-8]
        ]
      }
    },
    'GL2': {
      'W2.3': {
        basedir: 'sgi/gl2/w2.3',
        srcdirs: %w[usr/man/?_man/man[1-8]]
      },
      'W2.4': {
        basedir: 'sgi/gl2/w2.4_fe_upd', # REVIEW incomplete? (probably not. 1099 entries vs. 1067 for W2.3)
        srcdirs: %w[usr/man/?_man/man[1-8]]
      },
      'W2.5': { # TODO these are installed dates, not release dates. they came from the SAQ IRIS.
        basedir: 'sgi/gl2/w2.5',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W2.5r1': { # REVIEW incomplete? options, update only (1183 entries though)
        basedir: 'sgi/gl2/w2.5r1',
        srcdirs: %w[
          update_only/usr/man/?_man/man[1-8]
          options/usr/man/?_man/man[1-8]
        ]
      },
      'W3.5r1': {
        basedir: 'sgi/gl2/w3.5r1',
        srcdirs: %w[man/?_man/man[1-8]]
      },
      'W3.6': {
        basedir: 'sgi/gl2/w3.6',
        srcdirs: %w[
          usr/man/?_man/man[1-8]
          options/usr/man/?_man/man[1-8]
        ]
      }
    },
    'IRIX': {
      '6.5.3f': { # TODO re-extraction
        basedir: 'sgi/irix/6.5.3f',
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
    'OS-MP': {
      '4.1A': {
        basedir: 'solbourne/os-mp/4.1A',
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.1A3': {
        basedir: 'solbourne/os-mp/4.1A3',
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.1C': {
        basedir: 'solbourne/os-mp/4.1C',
        srcdirs: %w[share/man/man[1-8]]
      },
      'unbundled/OpenWindows_3.0': {
        basedir: 'solbourne/os-mp/unbundled/ow3.0',
        srcdirs: %w[man[1-8]]
      },
      'unbundled/X11R3': { # REVIEW is actually X11R5 ?? from pete/X.3.Q150
        basedir: 'solbourne/os-mp/unbundled/x11r3',
        srcdirs: %w[man[13]]
      },
      'unbundled/X11R5': {
        basedir: 'solbourne/os-mp/unbundled/x11r5',
        srcdirs: %w[man[13]]
      }
    }
  },
  'Sony': {
    'NEWS-os': {
      '3.3/en_US': { # TODO extra docs
        basedir: 'sony/news-os/3.3',
        srcdirs: %w[public/usr/man/man[1-8nops]]
      },
      '3.3/ja_JP': {
        basedir: 'sony/news-os/3.3',
        srcdirs: %w[public/usr/jman/man[1-8nops]]
      },
      '4.1C/en_US': { # TODO extra docs
        basedir: 'sony/news-os/4.1ca/usr/man',
        srcdirs: %w[C/man[1-8nop]]
      },
      '4.1C/ja_JP': {
        basedir: 'sony/news-os/4.1ca/usr/man',
        srcdirs: %w[
          ja_JP.SJIS/man[1-8nop]
          Motif1.0/ja_JP.SJIS/man3
        ]
      },
      '4.2.1R/en_US': {
        basedir: 'sony/news-os/4.2.1R/usr/man',
        srcdirs: %w[C/man[1-8nop]]
      },
      '4.2.1R/ja_JP': { # TODO compare installed man w/ media-extracted (.../4.2.1R/usr/man)
        basedir: 'sony/news-os/4.2.1R/man',
        srcdirs: %w[
          ja_JP.SJIS/man[1-8nop]
          Motif1.0/ja_JP.SJIS/man3
        ]
      },
      '5.0.1': {
        basedir: 'sony/news-os/5.0.1',
        # REVIEW share/man.foon ??
        srcdirs: %w[
          share/man/*cat[1-8]
          X11/usr/man/man[13]
          X11/usr/man/Motif/man[13]
        ]
      }
    }
  },
  'Sun': {
    'Interactive': {
      '3.2r4.1': {
        basedir: 'sun/interactive/3.2r4.1',
        srcdirs: %w[
          man/mann
          man/u_man/man[1-8]
        ]
      }
    },
    'unbundled': {
      module_override: 'SunOS',
      #'SunCompilers_1.0': { # is this right? there's c and f77 in here
      #  version_override: '4.0',
      #  basedir: 'sun/sunos/4.0',
      #  srcdirs: %w[unbundled/SC0.0/man/man[135]] # SC0.0 overwrites several pages from 4.0
      #} # TODO probably I shouldn't have mixed the C and F77 products here. -- CORRECTED in sunos/unbundled
      'ATM_2.0': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/atm_2.0',
        srcdirs: %w[SUNWatm/man/man[13479]*]
      },
      'C_1.0': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/c_1.0',
        srcdirs: %w[man/man[1358]]
      },
      'C++_2.0': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/c++_2.0',
        srcdirs: %w[CC/man/man[13]]
      },
      'CDE_1.0.1': { # same as CDE 1.0.2 on Desktop 1.1
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/cde_1.0',
        srcdirs: %w[dt/share/man/man[1-6]*]
      },
      'DiskSuite_4.0': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/disksuite_4.0',
        srcdirs: %w[usr/opt/SUNWmd/man/man[147]*]
      },
      'DOS_Windows_1.0': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/dos_windows_1.0',
        srcdirs: %w[man]
      },
      'FORTRAN_1.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/fortran_1.1',
        srcdirs: %w[share/man/man[13]]
      },
      'FORTRAN_1.2': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/fortran_1.2',
        srcdirs: %w[share/man/man[13]]
      },
      'FORTRAN_1.3.1': {
        version_override: '4.1',
        basedir: 'sun/sunos/unbundled/fortran_1.3.1',
        srcdirs: %w[man/man[1358]]
      },
      'FORTRAN_1.4': {
        version_override: '4.1',
        basedir: 'sun/sunos/unbundled/fortran_1.4',
        srcdirs: %w[man/man[135]]
      },
      'Motif_SDK_1.2.2': { # for Solaris 2.2
        version_override: '5.2',
        basedir: 'sun/sunos/unbundled/motif_1.2.2_sdk',
        srcdirs: %w[SUNWmfdoc/man/man[135]]
      },
      'NeWS_1.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/news_1.1',
        srcdirs: %w[man/man[136]]
        # TODO local string.defs, header.mex
      },
      'ODBC_2.11': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/odbc_2.11',
        srcdirs: %w[man/man4]
      },
      'OpenWindows_1.0_PreFCS': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/openwindows_1.0_pre_fcs',
        srcdirs: %w[man/man[136n]]
      },
      'OpenWindows_1.1_Developer_Guide': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/openwindows_1.1_dev_guide',
        srcdirs: %w[man/man1]
      },
      'OpenWindows_V2': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/openwindows_v2',
        srcdirs: %w[man/man[136n]]
      },
      'Pascal_1.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/pascal_1.1',
        srcdirs: %w[man/man1]
      },
      'Pascal_2.0': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/pascal_2.0',
        srcdirs: %w[man/man1]
      },
      'Pascal_2.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/pascal_2.1',
        srcdirs: %w[man/man[15]]
      },
      'PHIGS_1.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/phigs_1.1',
        srcdirs: %w[man/phigs1.1/man[37]]
        # TODO local tmac.an with .ds j (\nj=1 ? CADAM : NO_CADAM) for CADAM specific text
        # escape.3 refs conditional; escape_-3.3 and escape_-13.3 are entirely conditional on it
        # section 3P+ for PHIGS+
      },
      'ProWorks_3.0.1': { # V3N1 x86
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/proworks_3.0.1',
        srcdirs: %w[
          SUNWspro/*/man/man[1345]*
          SUNWspro/FSF/sbtags/man/man1
          SUNWste/license_tools/man/man1
        ]
      },
      'SBus_Printer_Card_1.0': {
        version_override: '4.1',
        basedir: 'sun/sunos/unbundled/sbus_printer_card_1.0',
        srcdirs: %w[man]
      },
      'Solaris_2.4_x86_SDK': {
        version_override: '5.4',
        basedir: 'sun/sunos/unbundled/solaris_2.4_x86_sdk',
        srcdirs: %w[
          dt/man/man[135]
          SUNWgmfu/share/man/man1
          SUNWguide/demo/gnt/man/man1
          SUNWguide/share/man/man1
          SUNWits/Graphics-sw/x?l/man/man3
          SUNWmfwm/man/man1
        ]
      },
      'Solstice_Backup_4.1.2/Solaris': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
        srcdirs: %w[share/man/man[358]]
      },
      'Solstice_Backup_4.1.2/SunOS': { # REVIEW different from Solaris manual?
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/solstice_backup_4.1.2',
        srcdirs: %w[SunOS/man]
      },
      'WorkShop_3.0.1': { # V5N1 SPARC Solaris 2.x # TODO Solaris 1.x
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/workshop_3.0',
        srcdirs: %w[
          SUNWspro/*/man/man[134]*
          SUNWspro/contrib/*/man/man1
          SUNWste/license_tools/man/man1
        ]
      },
      'WorkShop_5.0': { # V6N1 SPARC
        version_override: '5.6',
        basedir: 'sun/sunos/unbundled/workshop_5.0',
        srcdirs: %w[
          SUNW*/*/man/man[134]*
          SUNWspro/contrib/XEmacs20.4/man/man1
          SUNWste/license_tools/man/man1
        ]
      },
      'TOPS_2.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/tops_2.1',
        srcdirs: %w[.]
      },
      'TranSCRIPT_2.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/unbundled/transcript_2.1',
        srcdirs: %w[man]
      },
      'TranSCRIPT_2.1.1': {
        version_override: '4.1',
        basedir: 'sun/sunos/unbundled/transcript_2.1.1',
        srcdirs: %w[man]
      },
      'WABI_2.0': {
        version_override: '5.4',
        basedir: 'sun/sunos/unbundled/wabi_2.0',
        srcdirs: %w[SUNWwabi/man/man1]
      },
      'WABI_2.1': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/wabi_2.1',
        srcdirs: %w[SUNWwabi/man/man1]
      },
      'WABI_2.2': {
        version_override: '5.5',
        basedir: 'sun/sunos/unbundled/wabi_2.2',
        srcdirs: %w[SUNWwabi/man/man1]
      }
    },
    'thirdparty': {
      module_override: 'SunOS',
      'AMT/DAP_4.1S': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/amt_dap_4.1s',
        srcdirs: %w[sunany/dapany/rtshelp]
        # TODO no Solaris 4.1(.0?) doc or macros yet
      },
      'ArborText/Publisher_3.1.1': {
        version_override: '3.2',
        basedir: 'sun/sunos/thirdparty/arbortext_publisher_3.1.1',
        srcdirs: %w[
          file.1/lpr/man
          file.1/man
        ]
      },
      'ArborText/Adept_Publisher_5.0.2': {
        version_override: '5.4',
        basedir: 'sun/sunos/thirdparty/arbortext_adept_5.0.2',
        srcdirs: %w[man]
        # TODO no Solaris 2.4 doc or macros yet
      },
      'Cadre/Teamwork_4.0.2': {
        version_override: '5.1',
        basedir: 'sun/sunos/thirdparty/cadre_teamwork_4.0.2',
        srcdirs: %w[cadre/help]
        # TODO nroff plain text; non-standard manual format
      },
      'Centerline/TestCenter_1.0.2_beta1.0': {
        version_override: '5.1',
        basedir: 'sun/sunos/thirdparty/centerline_testcenter_1.0.2_b1.0',
        srcdirs: %w[CenterLine/man/man[15]]
        # TODO no Solaris 2.1 doc or macros yet
      },
      'Centerline/ViewCenter_2.5.0': {
        version_override: '5.2',
        basedir: 'sun/sunos/thirdparty/centerline_viewcenter_2.5.0',
        srcdirs: %w[CenterLine/man.19930811/man/man[15]]
        # TODO no Solaris 2.2 doc or macros yet
      },
      'HP/NPI_A.02.00': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/hp_npi_a.02.00',
        srcdirs: %w[usr/lib/hpnp/sun-man/man[158]]
      },
      'Interphase/NC400_1.4.2': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/interphase_nc400_1.4.2',
        srcdirs: %w[man/OMNI/man[148]]
      },
      'Illustra/Datablade_1.1': {
        version_override: '5.5.1', # ...probably?
        basedir: 'sun/sunos/thirdparty/illustra_datablade_1.1',
        srcdirs: %w[dbdk/man/manl]
      },
      'IXI/Motif_1.1_X11R4': {
        version_override: '4.0',
        basedir: 'sun/sunos/thirdparty/ixi_motif_1.1',
        srcdirs: %w[usr/man/man[3n]]
      },
      'IXI/Motif_Developer_Pack_1.2.2a': {
        version_override: '4.0',
        basedir: 'sun/sunos/thirdparty/ixi_motif_devpack_1.2.2a',
        srcdirs: %w[man/man[135]]
      },
      'Lotus/1-2-3_1.0': {
        version_override: '4.0',
        basedir: 'sun/sunos/thirdparty/lotus_123_1.0',
        srcdirs: %w[lotus/man/man1]
      },
      'Lucid/C_2.2': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/lucid_c_2.2',
        srcdirs: %w[man/man1]
      },
      'Lucid/C++_3.0beta': {
        version_override: '5.2',
        basedir: 'sun/sunos/thirdparty/lucid_c++_3.0b',
        srcdirs: %w[man/man[13]]
        # TODO no Solaris 2.2 doc or macros yet
      },
      'Lucid/Energize_2.1': {
        version_override: '4.0',
        basedir: 'sun/sunos/thirdparty/lucid_energize_2.1',
        srcdirs: %w[
          etc.new/examples/man/man[13]
          etc.new/tutorial/man/man3
          flexlm.new/man/man[15]
          lcc.new/man/man[13]
          man.new/man/man[1358]
          ostore.new/man/man[18]
          iv-3.1/iv/installed/man/mann
          iv-3.1/iv/man/faq/faq.out
          iv-3.1/iv/man/commands/*.n
          iv-3.1/iv/man/Dispatch/*.n
          iv-3.1/iv/man/Interviews/*.n
          iv-3.1/iv/man/Unidraw/*.n
        ]
        # TODO all kinds of stuff in here, it (probably) needs sorted/organized into subdirs
        #       TeX sources of Lucid Emacs manual in lemacs.new/man/
        #       postscript source in iv-3.1/iv/src/man/refman > make refman.PS
      },
      'Oracle/6.0.33.1': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/oracle_6.0.33.1',
        srcdirs: %w[*/man]
      },
      'Parallax/PNeWS_3.0': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/parallax_pnews_3.0',
        srcdirs: %w[
          plx.4
          man/sc.1
          man/man[136]
        ]
        # TODO local string.defs (see: NeWS_1.1)
      },
      'Pixar/High_Speed_Interface_1.1': {
        version_override: '4.1.4',
        basedir: 'pixar/hsi-sun3/1.1',
        srcdirs: %w[hsi/man/man[1-8]]
      },
      'Sybase/DB_Library_C_4.0': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/sybase_db_library_c_4.0',
        srcdirs: %w[doc]
        # TODO nroff for terminal (short screen, 24 or 25 line page length)
      },
      'Sybase/SQL_Server_4.0': {
        version_override: '4.1',
        basedir: 'sun/sunos/thirdparty/sybase_sql_server_4.0',
        srcdirs: %w[doc]
        # TODO nroff for terminal (short screen, 24 or 25 line page length)
      },
      'Transarc/AFS_3.2': {
        version_override: '4.1.4',
        basedir: 'sun/sunos/thirdparty/transarc_afs_3.2',
        srcdirs: %w[man/man1]
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
      '3.2/68010': {
        version_override: '3.2',
        basedir: 'sun/sunos/3.2',
        srcdirs: %w[68010/man/man[1-8]]
      },
      '3.2/68020': {
        version_override: '3.2',
        basedir: 'sun/sunos/3.2',
        srcdirs: %w[68020*/man/man[1-8]]
      },
      '3.2/SYS4': {
        version_override: '3.2',
        basedir: 'sun/sunos/3.2',
        srcdirs: %w[SYS4-3.2/man/man[1-8]]
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
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.0.2': {
        version_override: '4.0', # literally identical
        basedir: 'sun/sunos/4.0.2',
        srcdirs: %w[share/man/man[1-8]]
      },
      '4.0.3/sun3': {
        version_override: '4.0', # literally identical
        basedir: 'sun/sunos/4.0.3',
        srcdirs: %w[68020/share/man/man[1-8]]
      },
      '4.0.3/sun4': { # 35 more pages than sun3? REVIEW other differences?
        version_override: '4.0', # literally identical
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
      '4.1.2': {
        basedir: 'sun/sunos/4.1.2',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[136n]
        ]
      },
      '4.1.3B': {
        # 4.1.3 (Solaris 1.1 SunSoft Version B, 704-3545-10) - all other 4.1.3mumble Domestic manuals are identical to 4.1.3_U1
        # TODO reveal the secret of how it's different
        basedir: 'sun/sunos/4.1.3_sunsoft_revB',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[1-8]
        ]
      },
      '4.1.3_U1': {
        # All identical: 4.1.3 SunSoft Ver A, 4.1.3 SunSoft Ver C, 4.1.3_U1, and 4.1.3_U1 SunSoft Ver B (704-3662)
        # TODO 4.1.3_U1 SunSoft Ver B (704-4037) has International/EUC amendments - not identical, though also en_US
        basedir: 'sun/sunos/4.1.3u1',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[1-8]
        ]
      },
      '4.1.4': {
        basedir: 'sun/sunos/4.1.4',
        srcdirs: %w[
          share/man/man[1-8]
          openwin/share/man/man[1-8]
        ]
      },
      '5.1/SPARC': {
        # TODO reveal the secrets of how SPARC and x86 are different, if beyond drivers in man7
        #       I guess that's just an intellectual exercise as they can't be merged
        #        - e.g. substantial differences in matherr(3m)
        version_override: '5.1',
        basedir: 'sun/sunos/5.1',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-8]
          usr/demo/SOUND/man/man3
        ]
      },
      '5.1/x86': {
        version_override: '5.1',
        basedir: 'sun/sunos/5.1_x86',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-8]
          usr/demo/SOUND/man/man3
        ]
      },
      '5.2': {
        basedir: 'sun/sunos/5.2',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-8]*
          usr/demo/SOUND/man/man3
        ]
      },
      '5.3': {
        basedir: 'sun/sunos/5.3',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-8]*
          usr/demo/SOUND/man/man3
          SUNWits/Graphics-sw/xil/man/man3
        ]
      },
      '5.4': { # HW 3/95
        # TODO hw395_upd
        basedir: 'sun/sunos/5.4_hw395',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-8]*
          dt/man/man1
          usr/demo/SOUND/man/man3
          SUNWits/Graphics-sw/xil/man/man[13]
          SUNWrtvc/man/man1
        ]
      },
      '5.5/SPARC': {
        # TODO 5.5_upd
        version_override: '5.5',
        basedir: 'sun/sunos/5.5',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-7]*
          usr/openwin/share/man/man[16]
          usr/demo/SOUND/man/man3
          SUNWits/Graphics-sw/xil/man/man[13]
        ]
      },
      '5.5/x86': {
        # TODO it is different from SPARC, but how? doesn't have XIL package... doesn't look like that is the only diff?
        version_override: '5.5',
        basedir: 'sun/sunos/5.5_x86',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-7]*
          usr/openwin/share/man/man[16]
          usr/demo/SOUND/man/man3
        ]
      },
      '5.5.1': { # TODO re-extract from media
        basedir: 'sun/sunos/5.5.1',
        srcdirs: %w[share/man/man[1-9]*]
      },
      '5.6': { #
        # TODO compare x86
        basedir: 'sun/sunos/5.6_hw598',
        srcdirs: %w[
          share/man/man[1-9]*
          openwin/share/man/man[1-7]*
          usr/openwin/share/man/man[167]
          usr/demo/SOUND/man/man3
          SUNWrtvc/man/man[13]
        ]
      },
      '5.10': {
        disabled: true, # this manual does weird absolute positioning instead of .IP/.TP
        basedir: 'sun/sunos/5.10',
        srcdirs: %w[
          share/man/man[1-9]*
          share/man/sman[1-9]*/*.[1-9]*
        ]
      }
    }
  },
  'Tektronix': {
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
    '386BSD': {
      '1.0': {
        basedir: 'ucb/386bsd/1.0',
        srcdirs: %w[
          share/man/cat[1-9]*
          local/man/man[13578]
          X386/man/man[135]
        ] # REVIEW local/man/man8 is a file, will probably cause a problem
      }
    },
    'BSD': {
      '2.11': { # TODO check macros
        basedir: 'ucb/bsd/2.11_unknown_provenance',
        srcdirs: %w[man/man[1-8]*]
      },
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

os     = nil
ver    = nil
file   = nil
vendor = nil
debug  = false
clean  = false
indir  = '/Volumes/Museum/Manual/in'
outdir = '/Volumes/dev.online.typewritten.org/Manual'

args = ARGV.each
loop do
  begin
    arg = args.next
    case arg
    when '-in'     then indir  = args.next
    when '-out'    then outdir = args.next
    when '-clean'  then clean  = true # TODO blank the output directory
    when '-debug'  then debug  = true
    when '-vendor' then vendor = args.next.to_sym
    when '-os'     then os     = args.next.to_sym
    when '-version',
         '-ver'    then ver    = args.next.to_sym
    else           file = arg
    end
  rescue StopIteration
    break
  end
end

collections = collections.select { |k, _v| k == vendor } if vendor
if os
  collections = collections.select { |k, v| v.key?(os) }
  vendor ||= collections.select { |_k, v| v.is_a?(Hash) }.keys.first
  collections[vendor].reject! { |k, v| (k != os && v.is_a?(Hash)) || (k == :disabled) }
end
if ver
  vendor ||= collections.keys.first
  os ||= collections[vendor].select { |_k, v| v.is_a?(Hash) }.keys.first
  collections[vendor][os].reject! { |k, v| (k != ver && v.is_a?(Hash)) || (k == :disabled) }
end

#raise ArgumentError, 'need input and output directories!' if indir.empty? || outdir.empty?

system('mkdir', '-p', outdir) unless Dir.exist?(outdir)
css = "#{__dir__}/lib/assets/tslroff.css"
unless File.exist?("#{outdir}/tslroff.css") and File.mtime(css) > File.mtime("#{outdir}/tslroff.css") # FIX no longer copies on empty dir (FIXed? test it: 20230626)
  Process.spawn("cp #{css} #{outdir}")
  Process.wait
  puts 'updated tslroff.css from lib/assets/'
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
      system('mkdir', '-p', odir) unless Dir.exist?(odir)

      (params[:override] or params[:srcdirs]).each do |srcdir|
        os_module = params[:module_override] || versions[:module_override] || os
        ver_module = params[:version_override] || ver
        srcdir << "/#{file}" if file
        cmd = "#{__dir__}/bin/tslroff.rb -odir #{odir} -os #{os_module} -ver #{ver_module} #{indir}/#{params[:basedir]}/#{srcdir}"
        t = timed_execute {
          if debug
            Process.spawn(cmd)
          else
            if params[:assets]
              Dir.glob params[:assets].map { |g| "**/#{g}" },
                       base: "#{indir}/#{params[:basedir]}/#{srcdir}" do |asset|
                filename = File.basename asset
                dest_dir = "#{odir}/#{File.dirname asset}"
                next if File.exist? "#{dest_dir}/#{filename}"
                system %(mkdir -p "#{dest_dir}") unless Dir.exist? dest_dir
                FileUtils.copy "#{indir}/#{params[:basedir]}/#{srcdir}/#{asset}",
                               "#{dest_dir}/#{filename}", preserve: true
                FileUtils.chmod 'a+r', "#{dest_dir}/#{filename}" # for some reason some of the BeOS graphics copy with limited read perms
              end
            end

            Process.spawn(cmd, %i[out err] => ["#{odir}/build_#{logtime}.log", File::CREAT | File::WRONLY | File::APPEND, 0o644])
          end
          Process.wait
        }
        puts "#{vendor} #{os} (#{ver}) completed #{srcdir} in #{t[:time]}s"
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
