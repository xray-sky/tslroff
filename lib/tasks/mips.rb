# frozen_string_literal: true
#

collection_namespace 'mips' do
  collection_namespace 'unbundled' do
    # TODO macro package?
    manual_namespace 'SysProgPkg_2.1',
                    #vendor_class: RISC_os,
                    idir: 'mips/risc-os/unbundled/2.1spp',
                    odir: 'mips/unbundled/UMIPS:BSD_System_Programmers_Package_2.1',
                    sources: %w[usr/src/SA/man/man[1-8]]
    manual_namespace 'RISCwindows_4.00',
                    vendor_class: RISC_os,
                    idir: 'mips/risc-os/unbundled/riscwindows/4.00',
                    odir: 'mips/unbundled/RISCwindows_4.00',
                    sources: %w[usr/RISCwindows4.0/man/cat/man[13]]
  end

  collection_namespace 'RISC/os' do
    manual_namespace '4.52',
                    vendor_class: RISC_os::V4_52,
                    idir: 'mips/risc-os/4.52',
                    odir: 'mips/RISC:os/4.52',
                    sources: %w[man/catman/?_man/*man[1-8]]
    manual_namespace '5.01',
                    vendor_class: RISC_os::V5_01,
                    idir: 'mips/risc-os/5.01',
                    odir: 'mips/RISC:os/5.01',
                    sources: %w[share/man/catman/?_man/*man[1-8]]
  end
end
