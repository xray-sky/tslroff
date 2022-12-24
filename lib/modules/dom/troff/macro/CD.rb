# CD.rb
# -------------
#   troff
# -------------
#
#   .CD
#
#     define delimiters for cw(1) processing
#
#  TODO everything
#

module Troff
  define_method 'CD' do |*_args|
    warn "requires preprocessing by cw(1)"
  end
end
