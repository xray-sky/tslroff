# br.rb
# -------------
#   troff
# -------------
#
#   line break
#

module Troff
  def req_br(_args)
    # REVIEW: does this need to be more sophisticated??
    @current_block << '<br />'
  end
end