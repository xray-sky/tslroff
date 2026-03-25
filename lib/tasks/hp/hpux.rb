# frozen_string_literal: true
#

collection_namespace 'HPUX' do
  # refs S200 and S500, presumably either set will be the same?
  manual_namespace '5.00',
                  vendor_class: HPUX::V5_00,
                  idir: 'hp/hpux/5.00/S500',
                  odir: 'HP/HPUX/5.00',
                  sources: %w[usr/man/man*]

  manual_namespace '5.20/S300',
                  vendor_class: HPUX::V5_20::S300,
                  idir: 'hp/hpux/5.20/S300',
                  odir: 'HP/HPUX/5.20/S300',
                  sources: %w[
                    usr/man/cat[1-5]
                    usr/man/cat1m
                    usr/man/man*
                  ]

  manual_namespace '5.20/S500',
                  vendor_class: HPUX::V5_20::S500,
                  idir: 'hp/hpux/5.20/S500',
                  odir: 'HP/HPUX/5.20/S500',
                  sources: %w[usr/man/man*]

  manual_namespace '5.50',
                  vendor_class: HPUX::V5_50,
                  idir: 'hp/hpux/5.50/S300',
                  odir: 'HP/HPUX/5.50',
                  sources: %w[
                    usr/man/cat[1-5]
                    usr/man/cat1m
                    usr/man/man*
                  ]

  manual_namespace '6.00', # TODO fix file dates (in 2021)
                  vendor_class: HPUX::V6_00,
                  odir: 'HP/HPUX/6.00',
                  sources: %w[S300/usr/man/man*.Z]

  manual_namespace '6.20',
                  vendor_class: HPUX::V6_20,
                  odir: 'HP/HPUX/6.20',
                  sources: %w[S300/usr/man/man*.Z]

  # REVIEW appears incomplete. where'd it come from?
  manual_namespace '7.01',
                  #vendor_class: HPUX::V7_01,
                  idir: 'hp/hpux/7.01',
                  #odir: 'HP/HPUX/7.01',  # no tmac support yet
                  sources: %w[usr/man/man*]

  # REVIEW appears incomplete. where'd it come from?
  manual_namespace '7.03',
                  #vendor_class: HPUX::V7_03,
                  idir: 'hp/hpux/7.03',
                  #odir: 'HP/HPUX/7.03',  # no tmac support yet
                  sources: %w[usr/man/man*]

  manual_namespace '8.05',
                  vendor_class: HPUX::V8_05,
                  odir: 'HP/HPUX/8.05',
                  sources: %w[
                    usr/man/man*
                    usr/contrib/man/man1m
                  ]

  # REVIEW pages claim to be 8.05? is that payload from the entry?
  # tmac is identical to 9.05 (must be, 9.0 shares tmac and pages say 9.0)
  manual_namespace '8.07',
                  vendor_class: HPUX::V8_07,
                  odir: 'HP/HPUX/8.07',
                  sources: %w[usr/man/man*]

  manual_namespace '9.00',
                  vendor_class: HPUX::V9_00,
                  odir: 'HP/HPUX/9.00',
                  sources: %w[man/man*]

  manual_namespace '9.03',
                  vendor_class: HPUX::V9_03,
                  odir: 'HP/HPUX/9.03',
                  sources: %w[
                    usr/man/man*
                    usr/contrib/man/man1.Z
                    softbench/man/man*.Z
                  ]

  manual_namespace '9.04',
                  vendor_class: HPUX::V9_04,
                  idir: 'hp/hpux/9.04\ \(S800\ HP-PA\ Support\)',
                  odir: 'HP/HPUX/9.04',
                  sources: %w[usr/man/man1m.Z]

  manual_namespace '9.05',
                  vendor_class: HPUX::V9_05,
                  odir: 'HP/HPUX/9.05',
                  sources: %w[
                    man/man*.Z
                    contrib/man/man1.Z
                    softbench/man/man*.Z
                  ]

  manual_namespace '9.10',
                  vendor_class: HPUX::V9_05,
                  odir: 'HP/HPUX/9.10',
                  sources: %w[usr/man/man*] # TODO unbundled stuff mixed in ?

  manual_namespace '10.20',
                  vendor_class: HPUX::V10_20,
                  odir: 'HP/HPUX/10.20',
                  sources: %w[man/man*] # TODO + doc/ ?
end
