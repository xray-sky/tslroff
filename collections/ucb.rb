# frozen_string_literal: true
#

require_relative 'ucb/386bsd'
require_relative 'ucb/bsd'
require_relative 'ucb/sprite'

collection_namespace 'UCB' do
  collection_namespace '386BSD' do
    manual_namespace '1.0',
      vendor_class: X386BSD,
      idir: 'ucb/bsd/386bsd/1.0',
      odir: 'UCB/386BSD/1.0',
      sources: %w[
        share/man/cat[1-9]*
        local/man/man[13578]
        X386/man/man[135]
      ] # REVIEW local/man/man8 is a file, will probably cause a problem
  end

  collection_namespace 'UNIX' do
    # no macros?
    manual_namespace '1BSD',
      contributor: 'tuhs.org',
      vendor_class: BSD::V1,
      idir: 'ucb/bsd/1bsd',
      odir: 'UCB/UNIX/1BSD',
      sources: %w[man[15678]]
      # ./READ_ME uses different set of troff macros. figure it out.

    # REVIEW macros in upgrade/man ?
    manual_namespace '2BSD',
      vendor_class: BSD::V2_8,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/2bsd',
      odir: 'UCB/UNIX/2BSD',
      sources: %w[
        man
        misc
        tar.1
      ]

    # no macros?
    manual_namespace '2.8BSD',
      vendor_class: BSD::V2_8,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/2.8bsd',
      odir: 'UCB/UNIX/2.8BSD',
      sources: %w[
        usr/man
        usr/kernel/man/man[1234]
        usr/job.control/man
        usr/src/pwhash/man/man[135]
      ]

    manual_namespace '2.9BSD',
      vendor_class: BSD::V2_9,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/2.9bsd',
      odir: 'UCB/UNIX/2.9BSD',
      sources: %w[
        man[1-8]
        net/man/man[1-8n]
        net/local/rinstall/man
        contrib/*/man
        src/ucb/*/man
        src/lib/libU77/man
      ]

    manual_namespace '2.11BSD',
      vendor_class: BSD::V2_11,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/2.11bsd',
      odir: 'UCB/UNIX/2.11BSD',
      sources: %w[
        man/cat*
        local/man/cat*
        new/man/cat*
        src/man/man[1-9]*
        src/bin/tcsh
        src/games/trek/DOC
        src/warp
        src/libexec/identd
        src/local/mp
        src/local/mtools
        src/new/notes/man
        src/new/rcs/man
        src/usr.sbin/catman
        src/usr.sbin/ntp/man/*.8
      ]

    manual_namespace '3BSD',
      vendor_class: BSD::V3,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/3bsd',
      odir: 'UCB/UNIX/3BSD',
      sources: %w[usr/man/man[1-8]]

    manual_namespace '4.1BSD',
      vendor_class: BSD::V4_1,
      contributor: 'tuhs.org',
      idir: 'ucb/bsd/4.1bsd',
      odir: 'UCB/UNIX/4.1BSD',
      sources: %w[man/man[1-8]]

    # and where'd this come from?? needs headers copied in
    #manual_namespace '4.3BSD',
    #  vendor_class: BSD::V4_3_VAX_MIT,
    #  idir: 'ucb/bsd/4.3-VAX-MIT',
    #  odir: 'UCB/UNIX/4.3BSD',
    #  sources: %w[usr/man/man[1-8]]
  end

  # I think this is actually BSDI 386/BSD.
  #collection_namespace 'BSD386' do
  #  # REVIEW differences between BSDI 386BSD, this, and UCB 386BSD?
  #  manual_namespace '1.0',
  #    idir: 'ucb/bsd/bsd386/1.0',
  #    odir: 'UCB/BSD:386/1.0',
  #    sources: %w[
  #      contrib/man/cat[1-8]
  #      share/man/cat[1-8]*
  #      X11/man/cat[135]
  #    ]
  #end

  collection_namespace 'Sprite' do
    manual_namespace 'KS.390',
      vendor_class: Sprite,
      idir: 'ucb/sprite/KS.390',
      odir: 'UCB/Sprite/KS.390',
      sources: %w[
        man/*/*.man
        man/lib/*/*.man
      ]
  end
end
