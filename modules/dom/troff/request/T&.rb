# T&.rb
# -------------
#   troff
# -------------
#
#   Alters table formats for subsequent rows
#

module Troff
  def req_TAmp(_args)
    formats_terminator = Regexp.new('\.\s*$')
    @state[:tbl_formats] = Troff.tbl_formats(@lines.collect_through { |l| l.match(formats_terminator) })
  end
end