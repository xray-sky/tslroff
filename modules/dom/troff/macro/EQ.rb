# EQ.rb
# -------------
#   troff
# -------------
#
#   .EQ
#
#     Begin equation (eqn) processing
#
#  TODO everything
#

module Troff
  def req_EQ
    @lines.collect_through { |l| l.match(/^.EN/) }[0..-2].each do |line|
      @register['.c'].value += 1
      parse_eqn(line)
    end
  end

  def parse_eqn(line)
    # this is a desultory first draft just to get something happening
    # and clean the no request warnings out of stderr.
    warn "eqn parsing #{line.inspect}"

    words = line.split
    case words[0]
    when 'delim' then (@state[:eqn_start], @state[:eqn_end]) = words[1].chars
    else
      if @state[:eqn_start]
        (beginning, eqn, ending) = line.match(/(.*?)#{Regexp.escape @state[:eqn_start]}(.+?)#{Regexp.escape @state[:eqn_end]}(.*)$/).to_a[1..3]
        unescape(beginning) if beginning
        @current_block << "&roffctl_unsupp;eqn(#{(eqn||line.chomp).inspect})&roffctl_endspan;"
        unescape(ending) if ending
      else
        @current_block << "&roffctl_unsupp;eqn(#{line.inspect})&roffctl_endspan;"
      end
    end
  end
end
