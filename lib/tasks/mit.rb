# frozen_string_literal: true
#

collection_namespace 'MIT' do
  collection_namespace 'X10' do
    manual_namespace 'R4',
                    idir: 'mit/x10/r4',
                    #odir: 'MIT/X10R4',
                    sources: %w[doc/mann]
  end

  collection_namespace 'X11' do
    manual_namespace 'R4',
                    idir: 'mit/x11/r4',
                    #odir: 'MIT/X11R4',
                    sources: %w[man/man[3n]]
  end
end
