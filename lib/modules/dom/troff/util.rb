# util.rb
# ---------------
#    Troff utility routines
# ---------------
#

module Troff

  private

  def self.quote_method(reqstr)
    case reqstr
    when '.'  then 'dot'
    when '"'  then 'quot'
    when '*'  then 'star'
    when '('  then 'lparen'
    when '}'  then 'rcurl'
    when '\"' then 'BsQuot'
    when 'T&' then 'TAmp'
    else           reqstr
    end
  end

end
