# TE.rb
# -------------
#   troff
# -------------
#
#   Ends table (tbl) processing
#

module Troff
  def req_TE
    raise EndOfTable
  end
end
