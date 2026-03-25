# frozen_string_literal: true
#

collection_namespace 'Solbourne' do
  collection_namespace 'OS/MP' do
    manual_namespace '4.1A',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/4.1A',
                    odir: 'Solbourne/OS:MP/4.1A',
                    sources: %w[share/man/man[1-8]]

    manual_namespace '4.1A3',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/4.1A3',
                    odir: 'Solbourne/OS:MP/4.1A3',
                    sources: %w[share/man/man[1-8]]

    manual_namespace '4.1C',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/4.1C',
                    odir: 'Solbourne/OS:MP/4.1C',
                    sources: %w[share/man/man[1-8]]
  end

  collection_namespace 'unbundled' do
    manual_namespace 'OpenWindows_3.0',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/unbundled/ow3.0',
                    odir: 'Solbourne/unbundled/OpenWindows_3.0',
                    sources: %w[man[1-8]]

    # REVIEW is actually X11R5 ?? from pete/X.3.Q150
    manual_namespace 'X11R3',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/unbundled/x11r3',
                    odir: 'Solbourne/unbundled/X11R3',
                    sources: %w[man[13]]

    manual_namespace 'X11R5',
                    vendor_class: OS_MP,
                    idir: 'solbourne/os-mp/unbundled/x11r5',
                    odir: 'Solbourne/unbundled/X11R5',
                    sources: %w[man[13]]
  end
end
