# frozen_string_literal: true
#

collection_namespace 'UCB' do
  collection_namespace '386BSD' do
    manual_namespace '1.0',
                    vendor_class: X386BSD,
                    idir: 'ucb/bsd/386bsd/1.0',
                    odir: 'UCB/386BSD/1.0',
                    sources: %w[
                      share/man/cat[1-9]*
                      local/man/man[13578]
                      X386/man/man[135]
                    ] # REVIEW local/man/man8 is a file, will probably cause a problem
  end

  collection_namespace 'BSD' do
    # this came from the eBay homemade tk50 - TODO check macros
    manual_namespace '2.11',
                    vendor_class: BSD::V2_11,
                    idir: 'ucb/bsd/2.11_unknown_provenance',
                    odir: 'UCB/BSD/2.11',
                    sources: %w[man/man[1-8]*]

    manual_namespace '4.3-VAX-MIT',
                    vendor_class: BSD::V4_3_VAX_MIT,
                    idir: 'ucb/bsd/4.3-VAX-MIT',
                    odir: 'UCB/BSD/4.3-VAX-MIT',
                    sources: %w[usr/man/man[1-8]]
  end

  collection_namespace 'BSD386' do
    # REVIEW differences between BSDI 386BSD, this, and UCB 386BSD?
    manual_namespace '1.0',
                    idir: 'ucb/bsd/bsd386/1.0',
                    odir: 'UCB/BSD386/1.0',
                    sources: %w[
                      contrib/man/cat[1-8]
                      share/man/cat[1-8]*
                      X11/man/cat[135]
                    ]
  end

  collection_namespace 'Sprite' do
    manual_namespace 'KS.390',
                    vendor_class: Sprite,
                    idir: 'ucb/sprite/KS.390',
                    odir: 'UCB/Sprite/KS.390',
                    sources: %w[
                      man/*/*.man
                      man/lib/*/*.man
                    ]
  end
end
