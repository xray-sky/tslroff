collectionNamespace 'unbundled' do
  manualNamespace 'ANSI-C_A09.00/S300', # TODO has links to base HPUX pages
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/unbundled/ansi-c/A.09.00-S300',
    odir: 'HP/unbundled/ANSI-C_A09.00/S300',
    sources: %w[usr/man/man[12345].Z]
  manualNamespace 'ANSI-C_A10.11/S700', # TODO there's some Japanese language manual pages in here, too
    vendor_class: HPUX::V10_20,
    idir: 'hp/hpux/unbundled/ansi-c/A.10.11-S700',
    odir: 'HP/unbundled/ANSI-C_A10.11/S700',
    sources: %w[
      */*/opt/imake/man/man1.Z
      */*/usr/share/man/man[1-8]*.Z
      */*/opt/*/share/man/man[1-8].Z
      */*/opt/graphics/*/share/man/man[1-8].Z
    ]
  manualNamespace 'C++_A.03.20/S300', # REVIEW has extra man macros in usr/CC/man/SC/manmacros
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/unbundled/c++/A.03.20-S300',
    odir: 'HP/unbundled/C++_A.03.20/S300',
    sources: %w[
      usr/man/man3
      usr/man/man[13].Z
      usr/CC/man/SC/man[134]
    ]
  manualNamespace 'DATIO_1.2',
    vendor_class: HPUX::V8_05,
    idir: 'hp/hpux/unbundled/datio/1.2',
    odir: 'HP/unbundled/DATIO_1.2',
    sources: %w[usr/man/man1.Z]
  manualNamespace 'Instrument-Control-Lib_C.03.01',
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/unbundled/instrument-control-lib/C.03.01',
    odir: 'HP/unbundled/Instrument-Control-Lib_C.03.01',
    sources: %w[usr/man/man*]
  manualNamespace 'Instrument-Control-Lib_G.03.00',
    vendor_class: HPUX::V9_05,
    idir: 'hp/hpux/unbundled/instrument-control-lib/G.03.00',
    odir: 'HP/unbundled/Instrument-Control-Lib_G.03.00',
    sources: %w[
      opt/sicl/share/man/man*
      opt/vxipnp/hpux/hpvisa/share/man/man3
    ]
  manualNamespace 'Network-Peripheral-Interface_A.02.00',
    vendor_class: HPUX::V8_05,
    idir: 'sun/sunos/thirdparty/hp_npi_a.02.00',
    odir: 'HP/unbundled/Network-Peripheral-Interface_A.02.00',
    sources: %w[usr/lib/hpnp/hp-man/man[14]*.Z]
  manualNamespace 'PersonalVisualizer_2.11/S700',
    vendor_class: HPUX::V8_05,
    idir: 'hp/hpux/unbundled/personalvisualizer/2.11-S700',
    odir: 'HP/unbundled/PersonalVisualizer_2.11/S700',
    sources: %w[usr/man/man[13].Z]
  manualNamespace 'PowerShade_A.B1.00/S700',
    vendor_class: HPUX::V8_05,
    idir: 'hp/hpux/unbundled/powershade/A.B1.00-S700',
    odir: 'HP/unbundled/PowerShade_A.B1.00/S700',
    sources: %w[usr/man/man1.Z]
  manualNamespace 'SCPI_B.02.00/S300',
    vendor_class: HPUX::V8_05,
    idir: 'hp/hpux/unbundled/scpi/B.02.00-S300',
    odir: 'HP/unbundled/SCPI_B.02.00/S300',
    sources: %w[usr/hp75000/man/man[135]]
end
