# frozen_string_literal: true
#

collection_namespace 'MicroVMS' do
  manual_namespace '4.4',
                  vendor_class: VMS,
                  odir: 'DEC/MicroVMS/4.4',
                  sources: %w[
                    */?
                    sys0/syshlp
                  ]
  manual_namespace '4.5B', # is this the same as 4.4? - yes
                  vendor_class: VMS,
                  idir: 'dec/microvms/4.5B',
                  odir: 'DEC/MicroVMS/4.5B',
                  sources: %w[
                    */?
                    sys0/syshlp
                  ]
  manual_namespace '4.6', # is THIS the same as 4.4?? - no
                  vendor_class: VMS,
                  odir: 'DEC/MicroVMS/4.6',
                  sources: %w[
                    options/*/?
                    sys0/syshlp
                  ]
end

collection_namespace 'VMS' do
  manual_namespace '4.6',
                  vendor_class: VMS,
                  odir: 'DEC/VMS/4.6',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.0',
                  vendor_class: VMS,
                  odir: 'DEC/VMS/5.0',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.1-B',
                  vendor_class: VMS,
                  idir: 'dec/vms/5.1-B',
                  odir: 'DEC/VMS/5.1-B',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.2',
                  vendor_class: VMS,
                  odir: 'DEC/VMS/5.2',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.4',
                  vendor_class: VMS,
                  odir: 'DEC/VMS/5.4',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.4-3', # update only
                  vendor_class: VMS,
                  odir: 'DEC/VMS/5.4-3',
                  sources: %w[
                    latmaster/lat_kit/0543_a
                    savesets/saveset_[cd]
                  ]
  manual_namespace '5.5',
                  vendor_class: VMS::V5_5,
                  odir: 'DEC/VMS/5.5',
                  sources: %w[sys0/syshlp]
  manual_namespace '5.5-2H4',
                  vendor_class: VMS::V5_5,
                  idir: 'dec/vms/5.5-2H4',
                  odir: 'DEC/VMS/5.5-2H4',
                  sources: %w[sys0/syshlp]
end
