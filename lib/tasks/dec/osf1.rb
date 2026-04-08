# frozen_string_literal: true
#

collection_namespace 'OSF/1' do
  # DEC OSF/1 SILVER Baselevel 4 (Rev. 36) for MIPS from tenox - prerelease for mips TODO tmac.an
  manual_namespace 'SILVER_Baselevel_4_rev36',
                  vendor_class: OSF1,
                  idir: 'dec/osf1/silver4_r36_mips',
                  odir: 'DEC/OSF:1/SILVER_Baselevel_4_rev36',
                  sources: %w[usr/share/man/man[1-8]]
  # DEC OSF/1 V1.0 (TIN) for MIPS from tenox - TODO tmac.an
  manual_namespace '1.0/mips',
                  vendor_class: OSF1,
                  idir: 'dec/osf1/1.0_tin_mips',
                  odir: 'DEC/OSF:1/1.0/mips',
                  sources: %w[usr/share/man/man[1-8]]
  # DEC OSF/1 X2.0-8 (Rev. 155) for MIPS from tenox - TODO tmac.an
  manual_namespace 'X2.0-8/mips',
                  vendor_class: OSF1,
                  idir: 'dec/osf1/2.0-8_mips',
                  odir: 'DEC/OSF:1/X2.0-8/mips',
                  sources: %w[usr/share/man/man[1-8]]
  manual_namespace '3.0',
                  vendor_class: OSF1::V3_2c,  # identical apart from (c) date
                  idir: 'dec/osf1/3.0',
                  odir: 'DEC/OSF:1/3.0',
                  sources: %w[share/man/man[1-8]]
end

collection_namespace 'Digital_UNIX' do
  manual_namespace '3.2c',
                  vendor_class: Digital_UNIX::V3_2c,
                  idir: 'dec/du/3.2c',
                  odir: 'DEC/Digital_UNIX/3.2c',
                  sources: %w[
                    usr/share/man/man[1-8]
                    usr/dt/share/man/man[1-6]
                    usr/opt/XR6320/X11R6/man/man[3n]
                  ]
  manual_namespace '4.0d',
                  vendor_class: Digital_UNIX::V4_0d,
                  idir: 'dec/du/4.0d',
                  odir: 'DEC/Digital_UNIX/4.0d',
                  sources: %w[
                    usr/share/man/man[1-8]
                    usr/dt/share/man/man[1-5]*
                  ]
end

collection_namespace 'Tru64' do
  manual_namespace '4.0f',
                  vendor_class: Tru64,
                  odir: 'DEC/Tru64/4.0f',
                  sources: %w[
                    usr/share/man/man[1-8]
                    usr/dt/share/man/man[1-5]*
                  ]
  manual_namespace '5.0a',
                  vendor_class: Tru64,
                  odir: 'DEC/Tru64/5.0a',
                  sources: %w[
                    usr/share/man/man[1-9]
                    usr/dt/share/man/man[1-6]*
                  ]
  manual_namespace '5.1b',
                  vendor_class: Tru64,
                  odir: 'DEC/Tru64/5.1b',
                  sources: %w[
                    usr/share/man/man[1-9]
                    usr/dt/share/man/man[1-5]
                  ]
end
