# PM.rb
# -------------
#   troff
# -------------
#
#   .PM m
#
#     Produces proprietary markings; see REFERENCE to mm(1).
#     REVIEW not sure this is present in too many non-AT&T versions of tmac.an
#            HP-UX defines it.
#     REVIEW just insert it here for every page to use? or leave it vendor-specific
#

=begin
module Troff
  define_method 'PM' do |*m|
    warn "don't know how to PM #{m.inspect}"
  end
end
=end
