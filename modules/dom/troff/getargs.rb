# getargs.rb
# ---------------
#    Troff.getargs source
# ---------------
#

module Troff

  def getargs(str)
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    until str.empty?
      if str.sub!(/^\"(.*?(#{esc}\")*)(\"|$)/, '') # an open quote may be closed by EOL
        args << Regexp.last_match(1)             # REVIEW: are single-quoted args allowed??
      else
        str.sub!(/^\s*(.+?(#{esc}\s)*\s*)(\s|$)/, '')
        args << Regexp.last_match(1)
      end
    end
    args
  end

end
