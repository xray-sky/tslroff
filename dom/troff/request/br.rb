# br.rb
# -------------
#   troff
# -------------
#
#   line break
#

module Troff

  def req_br(_args)
    @current_block << '<br />'   # TODO: does this need to be more sophisticated??
  end

end