# frozen_string_literal: true
#

require_relative 'bell/unix'
require_relative 'bell/plan9'
require_relative 'bell/inferno'

collection_namespace 'Bell' do
  collection_namespace 'Inferno' do
    manual_namespace '1ed',
      vendor_class: Inferno::FirstEd,
      entry_page: 'index.html',
      ver: '1st Edition',
      idir: 'bell/inferno/1e0',
      odir: 'Bell/Inferno/1ed',
      sources: %w[man/html/*.htm] do |t|
        t[:task].prerequisites << assets_task(%w(*.gif), t[:idir], t[:odir], cut_dirs: 2)
      end
    manual_namespace '1.1ed',
      vendor_class: Inferno::FirstEd_1,
      entry_page: 'mpgs.html',
      ver: '1st.1 Edition',
      idir: 'bell/inferno/1e1src',
      odir: 'Bell/Inferno/1.1ed',
      sources: %w[man/html/*.htm] do |t|
        t[:task].prerequisites << assets_task(%w(*.gif), t[:idir], t[:odir], cut_dirs: 2)
      end
    manual_namespace '3ed',
      vendor_class: Inferno::ThirdEd,
      ver: '3rd Edition',
      idir: 'bell/inferno/3e',
      odir: 'Bell/Inferno/3ed',
      sources: %w[man/[1-9]*]
    manual_namespace '4ed',
      vendor_class: Inferno::FourthEd,
      ver: '4th Edition',
      idir: 'bell/inferno/4e',
      odir: 'Bell/Inferno/4ed',
      sources: %w[man/[1-9]*]
  end

  collection_namespace 'Plan9' do
    # TODO macros
    # TODO sys/doc release notes etc.
    manual_namespace '1ed',
      vendor_class: Plan9,
      ver: '1st Edition',
      idir: 'bell/plan9/1e',
      odir: 'Bell/Plan9/1ed',
      sources: %w[sys/man/[1-8]]
    manual_namespace '2ed',
      vendor_class: Plan9,
      ver: '1st Edition',
      idir: 'bell/plan9/2e',
      odir: 'Bell/Plan9/2ed',
      sources: %w[sys/man/[1-8]]
    # this is from my Vita Nuova disc; filenames jacked from ISO? also includes some inferno stuff
    manual_namespace '3ed_vn',
      vendor_class: Plan9,
      ver: '3rd Edition (Vita Nuova)',
      idir: 'bell/plan9/3e_vita-nuova',
      odir: 'Bell/Plan9/3ed_Vita_Nuova',
      sources: %w[
        sys/man/[1-8]
        usr/inferno/man/[1-9]*
      ]
    # archive.org tar file
    manual_namespace '3ed',
      vendor_class: Plan9,
      ver: '3rd Edition',
      idir: 'bell/plan9/3e',
      odir: 'Bell/Plan9/3ed',
      sources: %w[sys/man/[1-8]]
    manual_namespace '4ed',
      vendor_class: Plan9,
      ver: '4th Edition',
      idir: 'bell/plan9/4e',
      odir: 'Bell/Plan9/4ed',
      sources: %w[man/[1-8]]
    manual_namespace '4ed15',
      vendor_class: Plan9,
      ver: '4th Edition',
      idir: 'bell/plan9/4e_20150110',
      odir: 'Bell/Plan9/4ed_20150110',
      sources: %w[sys/man/[1-8]]
  end

  collection_namespace 'UNIX' do
    manual_namespace 'V6',
      vendor_class: UNIX::V6,
      contributor: 'tuhs.org',
      ver: '6th Edition',
      odir: 'Bell/UNIX/V6',
      sources: %w[
        man/man[1-8]
        man/man0/intro
      ]
    manual_namespace 'V7',
      vendor_class: UNIX::V7,
      contributor: 'tuhs.org',
      ver: '7th Edition',
      odir: 'Bell/UNIX/V7',
      sources: %w[
        man/man[1-8]
        man/man0/intro
      ]
    manual_namespace '32V',
      vendor_class: UNIX::V7,
      contributor: 'tuhs.org',
      odir: 'Bell/UNIX/32V',
      sources: %w[
        usr/man/man[1-8]
        usr/man/man0/intro
      ]
    # TODO also contains a lot of papers for as, cc, etc.
    manual_namespace 'SysIII',
      vendor_class: UNIX::SysIII,
      contributor: 'tuhs.org',
      ver: 'System III',
      idir: 'bell/unix/sysiii',
      odir: 'Bell/UNIX/SystemIII',
      sources: %w[
        usr/src/man/man[1-8]
        usr/src/man/man0/intro
      ]
    # TODO macros
    #manual_namespace 'SVR1/m68k',
    #  vendor_class: UNIX::SVR1,
    #  contributor: 'bitsavers.org',
    #  ver: 'System V Release 1.0',
    #  idir: 'bell/svr1m68k',
    #  odir: 'Bell/UNIX/SystemV/R1/m68k',
    #  sources: %w[
    #    man/?_man/man[1-8]
    #    man/local/man[1-8]
    #  ]
  end
end
