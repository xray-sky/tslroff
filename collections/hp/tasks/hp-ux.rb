# frozen_string_literal: true
#

collection_namespace 'HP-UX' do
  # refs S200 and S500, presumably either set will be the same?
  manual_namespace '5.00',
    vendor_class: HPUX::V5_00,
    #idir: 'hp/hpux/5.00/S500',
    idir: 'hp/hpux/5.00/S500_redo',
    odir: 'HP/HP-UX/5.00',
    sources: %w[usr/man/man*]

  manual_namespace '5.05',
    vendor_class: HPUX::V5_00,
    idir: 'hp/hpux/5.05upd/S500',
    odir: 'HP/HP-UX/5.05_update',
    sources: %w[usr/man/man*]

  manual_namespace '5.20/S300',
    vendor_class: HPUX::V5_20::S300,
    contributor: 'hpmuseum.net',
    ver: '5.20',
    #idir: 'hp/hpux/5.20/S300',
    idir: 'hp/hpux/5.20/S300lr',
    odir: 'HP/HP-UX/5.20/S300',
    sources: %w[
      usr/man/cat[1-5]
      usr/man/cat1m
      usr/man/man*
    ]

  manual_namespace '5.20/S500',
    vendor_class: HPUX::V5_20::S500,
    ver: '5.20',
    #idir: 'hp/hpux/5.20/S500',
    idir: 'hp/hpux/5.20/S500_redo',
    odir: 'HP/HP-UX/5.20/S500',
    sources: %w[usr/man/man*]

  manual_namespace '5.50',
    vendor_class: HPUX::V5_50,
    contributor: 'hpmuseum.net',
    #idir: 'hp/hpux/5.50/S300',
    idir: 'hp/hpux/5.50/S300lr',
    odir: 'HP/HP-UX/5.50',
    sources: %w[
      usr/man/cat[1-5]
      usr/man/cat1m
      usr/man/man*
    ]

  manual_namespace '6.00',
    vendor_class: HPUX::V6_00,
    contributor: 'hpmuseum.net',
    #idir: 'hp/hpux/6.00/S300',
    idir: 'hp/hpux/6.00/S300lr',
    odir: 'HP/HP-UX/6.00',
    sources: %w[usr/man/man*.Z]

  manual_namespace '6.20',
    vendor_class: HPUX::V6_20,
    contributor: 'hpmuseum.net',
    #idir: 'hp/hpux/6.20/S300',
    idir: 'hp/hpux/6.20/S300lr',
    odir: 'HP/HP-UX/6.20',
    sources: %w[
      usr/man/man*.Z
      usr/contrib/man/man1m
    ]

  # bitsavers
  manual_namespace '7.01',
    vendor_class: HPUX::V7_01,
    contributor: 'bitsavers.org',
    idir: 'hp/hpux/7.01',
    odir: 'HP/HP-UX/7.01',  # no tmac support yet
    sources: %w[usr/man/man*]

  # REVIEW appears incomplete. where'd it come from?
  #  -- only have tape 2 of 2
  manual_namespace '7.03',
    #vendor_class: HPUX::V7_03,
    idir: 'hp/hpux/7.03',
    #odir: 'HP/HP-UX/7.03',  # no tmac support yet
    sources: %w[usr/man/man*]

  manual_namespace '8.05',
    vendor_class: HPUX::V8_05,
    idir: 'hp/hpux/8.05',
    odir: 'HP/HP-UX/8.05',
    sources: %w[
      usr/man/man*
      usr/contrib/man/man1m
    ]

  # REVIEW pages claim to be 8.05? is that payload from the entry?
  # tmac is identical to 9.05 (must be, 9.0 shares tmac and pages say 9.0)
  manual_namespace '8.07',
    vendor_class: HPUX::V8_07,
    idir: 'hp/hpux/8.07',
    odir: 'HP/HP-UX/8.07',
    sources: %w[usr/man/man*]

  manual_namespace '9.00',
    vendor_class: HPUX::V9_00,
    idir: 'hp/hpux/9.00',
    odir: 'HP/HP-UX/9.00',
    sources: %w[man/man*]

  manual_namespace '9.03',
    vendor_class: HPUX::V9_03,
    idir: 'hp/hpux/9.03',
    odir: 'HP/HP-UX/9.03',
    sources: %w[
      usr/man/man*
      usr/contrib/man/man1.Z
      softbench/man/man*.Z
    ]

  manual_namespace '9.04',
    vendor_class: HPUX::V9_04,
    idir: 'hp/hpux/9.04\ \(S800\ HP-PA\ Support\)',
    odir: 'HP/HP-UX/9.04',
    sources: %w[usr/man/man1m.Z]

  manual_namespace '9.05',
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/9.05',
    odir: 'HP/HP-UX/9.05',
    sources: %w[
      man/man*.Z
      contrib/man/man1.Z
      softbench/man/man*.Z
    ]

  manual_namespace '9.10',
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/9.10',
    odir: 'HP/HP-UX/9.10',
    sources: %w[usr/man/man*] # TODO unbundled stuff mixed in ?

  manual_namespace '10.20',
    vendor_class: HPUX::V10_20,
    idir: 'hp/hpux/10.20',
    odir: 'HP/HP-UX/10.20',
    sources: %w[man/man*] # TODO + doc/ ?
end
