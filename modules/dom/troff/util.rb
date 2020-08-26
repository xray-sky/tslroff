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
    when '*'  then 'star'
    when '('  then 'lparen'
    when '\"' then 'BsQuot'
    when 'T&' then 'TAmp'
    else           reqstr
    end
  end

end
