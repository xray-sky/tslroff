# frozen_string_literal: true
#

require_relative 'next/nextstep'

collection_namespace 'NeXT' do
  collection_namespace 'NEXTSTEP' do
    manual_namespace '1.0',
      vendor_class: NEXTSTEP,
      os: 'NeXTstep',
      odir: 'NeXT/NEXTSTEP/1.0',
      sources: %w[NextLibrary/Documentation/Unix/ManPages/man[1-8]]

    manual_namespace '2.2',
      vendor_class: NEXTSTEP,
      contributor: 'winworldpc.com',
      os: 'NeXTstep',
      odir: 'NeXT/NEXTSTEP/2.2',
      sources: %w[Unix/ManPages/man[1-8]]

    manual_namespace '3.0',
      vendor_class: NEXTSTEP,
      os: 'NeXTSTEP',
      odir: 'NeXT/NEXTSTEP/3.0',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

    manual_namespace '3.1pr1',
      vendor_class: NEXTSTEP,
      ver: '3.1 Prerelease 1',
      os: 'NeXTSTEP',
      odir: 'NeXT/NEXTSTEP/3.1pr1',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

	# m68k & x86 sources identical
    manual_namespace '3.1',
      vendor_class: NEXTSTEP,
      os: 'NeXTSTEP',
      odir: 'NeXT/NEXTSTEP/3.1',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

	# m68k & x86 sources identical
    manual_namespace '3.2',
      vendor_class: NEXTSTEP,
      odir: 'NeXT/NEXTSTEP/3.2',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

	# cisc & risc sources identical
    manual_namespace '3.3',
      vendor_class: NEXTSTEP,
      odir: 'NeXT/NEXTSTEP/3.3',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

    manual_namespace '4.0pr1',
      vendor_class: NEXTSTEP,
      ver: '4.0 Prerelease 1',
      odir: 'NeXT/NEXTSTEP/4.0pr1',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]

    # sources identical to 4.0pr1
    manual_namespace '4.0pr2',
      vendor_class: NEXTSTEP,
      ver: '4.0 Prerelease 2',
      #odir: 'NeXT/NEXTSTEP/4.0pr2',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]
  end

  collection_namespace 'OPENSTEP' do
    manual_namespace '4.2',
      vendor_class: NEXTSTEP,
      odir: 'NeXT/OPENSTEP/4.2',
      sources: %w[NextLibrary/Documentation/ManPages/man[1-8]]
  end
end
