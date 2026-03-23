collectionNamespace 'IBM' do
  collectionNamespace 'AIX' do
    manualNamespace '1.2.1',
      vendor_class: AIX::V1_2_1,
      odir: 'IBM/AIX/1.2.1',
      sources: %w[man/cat[1-8]]
    # REVIEW 2.2.1-alt-src/
    manualNamespace '2.2.1',
      vendor_class: AIX::V2_2_1,
      odir: 'IBM/AIX/2.2.1',
      sources: %w[man/man[1-7]]
    # TODO incomplete (infoexplorer/html manual?)
    manualNamespace '4.3.3',
      vendor_class: AIX,
      idir: 'ibm/aix/4.3.3',
      #odir: 'IBM/AIX/4.3.3',
      sources: %w[
        share/man/man[1-8]
        dt/man/man*
      ]
  end

  collectionNamespace 'AOS' do
    # REVIEW 4.3 (unknown provenance)
    manualNamespace '4.3',
      vendor_class: AOS::V4_3,
      odir: 'IBM/AOS/4.3',
      sources: %w[man/man[1-9nx]]
    # this is -mm source for supplemental IBM/4.3 doc, recovered from mit.edu afs
    manualNamespace '4.3/supplemental',
      vendor_class: AOS::V4_3,
      idir: 'ibm/aos/ibmdoc',
      #odir: 'IBM/AOS/4.3/Supplemental'
      sources: %w[] # TODO
  end

  # TODO:
  #collectionNamespace 'VM/ESA' do
  #  manualNamespace 'V2R3M0' do
  #    idir: 'ibm/vm:esa/v2r3m0',
  #    sources: %w[]

end
