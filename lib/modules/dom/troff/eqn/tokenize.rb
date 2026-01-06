# eqn tokenizers

class Troff
  module Eqn

  def eqn_get_token(s)
    return s if s.empty?
    s.lstrip! # TODO tabs are passed through
    s.slice!(eqn_next_token(s))
  end

  def eqn_next_token(s)
    return s if s.empty?
    case s.lstrip # TODO tabs are passed through
    when /^[\t{}~^]/ then s[0]          # one character tokens for brackets/whitespace
    else                  s.split.first # everything else on whitespace
    end
  end

end
end
