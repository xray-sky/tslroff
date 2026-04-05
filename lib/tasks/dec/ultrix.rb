# frozen_string_literal: true
#

collection_namespace 'Ultrix' do
  # tmac.an.repro no different from 2.0.0
  manual_namespace 'WS-1.1',
                  vendor_class: Ultrix::V2_0_0,
                  odir: 'DEC/Ultrix/WS-1.1',
                  sources: %w[usr/man/man[1-8]]
  # AQ-NC13A/B-BE
  # what about AQ-KU57B-BE??
  # includes unsupported REVIEW where's the X pages? tmac.an.repro no different from 2.0.0
  manual_namespace 'WS-2.0/VAX',
                  vendor_class: Ultrix::V2_0_0,
                  odir: 'DEC/Ultrix/WS-2.0/VAX',
                  sources: %w[
                    usr/man/man[1-8]
                    usr/new/man/man[15]
                  ]
  # from source, + unsupported filesets (not in srcdist)
  manual_namespace '2.0',
                  vendor_class: Ultrix::V2_0_0,
                  idir: 'dec/ultrix/2.0.0',
                  odir: 'DEC/Ultrix/2.0',
                  sources: %w[
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
  # same manual content, PB30B vs. PB30A tapes
  manual_namespace '3.1+WS-2.2/VAX',
                  vendor_class: Ultrix::V3_1_0,
                  idir: 'dec/ultrix/3.1+ws-2.2_update/vax',
                  odir: 'DEC/Ultrix/3.1+WS-2.2/VAX',
                  sources: %w[usr/man/man[1-8]]
  # 3.1D supported subsets (check macros)
  manual_namespace '3.1D/mips',
                  vendor_class: Ultrix::V3_1_0,
                  odir: 'DEC/Ultrix/3.1D/mips',
                  sources: %w[usr/man/man[1-8]]
  # UWS 4.0 unsupported subsets + supported vol2
  manual_namespace '4.0/mips',
                  vendor_class: Ultrix::V4_2_0,
                  odir: 'DEC/Ultrix/4.0.0/mips',
                  sources: %w[usr/man/man[1-8]]
  # UWS 4.0 supported & unsupported subsets
  manual_namespace '4.0/VAX',
                  vendor_class: Ultrix::V4_2_0,
                  odir: 'DEC/Ultrix/4.0.0/VAX',
                  sources: %w[usr/man/man[1-8]]
  # UWS 4.1 unsupported subsets + supported vol2
  manual_namespace '4.1/mips',
                  vendor_class: Ultrix::V4_2_0, # check macros
                  odir: 'DEC/Ultrix/4.1.0/mips',
                  sources: %w[usr/man/man[1-8]]
  # from source
  manual_namespace '4.2/VAX',
                  vendor_class: Ultrix::V4_2_0,
                  idir: 'dec/ultrix/4.2.0',
                  odir: 'DEC/Ultrix/4.2/VAX',
                  sources: %w[src/usr/man/_vax.d/man[1-8]]
  manual_namespace '4.2/mips', # from source
                  vendor_class: Ultrix::V4_2_0,
                  idir: 'dec/ultrix/4.2.0',
                  odir: 'DEC/Ultrix/4.2/mips',
                  sources: %w[src/usr/man/_mips.d/man[1-8]]
  # UWS 4.4 unsupported subsets + supported vol2
  manual_namespace '4.4/mips',
                  vendor_class: Ultrix::V4_2_0,
                  idir: 'dec/ultrix/4.4.0/mips',
                  odir: 'DEC/Ultrix/4.4/mips',
                  sources: %w[usr/man/man[1-8]]
  manual_namespace '4.5.1/mips',
                  vendor_class: Ultrix::V4_2_0,
                  idir: 'dec/ultrix/4.5.1_mips',
                  odir: 'DEC/Ultrix/4.5.1/mips',
                  sources: %w[man/man[1-8]]
end
