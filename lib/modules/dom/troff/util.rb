# util.rb
# ---------------
#    Troff utility routines
# ---------------
#
=begin
module Troff

  private

  def self.quote_method(reqstr)
    reqstr.gsub(/([."*(){}\\&#])/, {
      '.' => 'Dot',
      '"' => 'Quot',
      '*' => 'Star',
      '(' => 'Lparen',
      ')' => 'Rparen',
      '{' => 'Lcurl',
      '}' => 'Rcurl',
      '\\' => 'Bs',
      '&' => 'Amp',
      '#' => 'Num'
    })
  end

end
=end
