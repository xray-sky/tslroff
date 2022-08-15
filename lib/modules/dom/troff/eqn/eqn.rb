EndOfEqn = Class.new(RuntimeError)

Dir.glob("#{__dir__}/words/*.rb").each do |i|
  require_relative i
end

module Eqn

  def gen_eqn(parse_tree, output: nil)
    #warn "entered gen_eqn with #{parse_tree.inspect}"
    if output
      hold_block = @current_block
      @current_block = output
    end

    loop do
      break if parse_tree.empty?

      elem = parse_tree.shift
      if respond_to? "eqn_#{elem}"
        send "eqn_#{elem}", parse_tree
      else
        case elem
        when Array then gen_eqn elem
        when "\t" then unescape elem
        when /^"/ then unescape elem.sub(/^"(.*)"$/, '\1') # pass through
        when '~'  then @current_block << '&nbsp;'
        when '^'  then @current_block << '&thinsp;'
        # these combining characters are meant to appear after the character they combine with
        # TODO they don't seem to combine with each other. but if we fix bar/under it probably won't matter in practice
        when 'vec'    then @current_block << '&#8407;'
        when 'dyad'   then @current_block << '&#8417;'
        when 'dot'    then @current_block << '&#775;'
        when 'dotdot' then @current_block << '&#776;'
        when 'hat'    then @current_block << '&#770;'
        when 'tilde'  then @current_block << '&#771;'
        when 'fat', 'back', 'fwd', 'up', 'down'
          warn "eqn no support yet for keyword '#{elem}'"
          unescape elem
        when /^(?:#{@state[:eqnchars].keys.collect{|c|Regexp.quote c}.join('|')})$/
          unescape "\\|" if @register['.f'].value == 2 and !@current_block.empty?
          unescape "\\f1#{@state[:eqnchars][elem]}\\fP"
        else
          loop do
            break if elem.empty?
            if elem.start_with? @state[:escape_char]
              unescape elem.slice!(0, get_char(elem).length)
            else
              next_esc = elem.index @state[:escape_char]
              txt = next_esc ? elem.slice!(0, next_esc) : elem.slice!(0..-1)
              # needed to protect escapes from this gsub.
              txt.gsub!(/[^A-Za-z]+/) do |m|
                m = "\\f1#{m}\\fP"
                m = "\\|#{m}" if @register['.f'].value == 2 and !@current_block.text.last.empty?
                m
              end
              # these "shorthands" apparently needn't be surrounded by spaces, so won't be caught by the eqnchars match
              unescape txt.gsub(%r{(==>|==<|<=>|<->|==|!=|\+-|>>|<<|<=|>=|\|<|\|>|->|<-|-)}) { |m| @state[:eqnchars][m] }
            end
          end
        end
      end
    end
    @current_block = hold_block if output
  end

  def eqn_parse_tree(str, limit: -1, terminate: '')
    eqn = []
    loop do
      break if str.empty? or eqn.length == limit
      case tok = str.slice!(0, get_eqn_token(str).length)
      when terminate then return eqn
      #when '~', '^', "\t" then eqn << tok
      when '{' then eqn << [ eqn_parse_tree(str, terminate: '}') ]
      when 'right'
        chr = str.slice!(0, get_eqn_token(str).length)
        return [ eqn, chr, :close ]
      when 'left'
        chr = str.slice!(0, get_eqn_token(str).length)
        encl = eqn_parse_tree(str)
        # 'right' is optional
        close = encl.last == :close ? encl.pop(2).first : nil
        eqn << [ :bracket, chr, close, encl ]
      when 'matrix', 'sqrt',
           'col', 'ccol', 'lcol', 'rcol',
           'pile', 'cpile', 'lpile', 'rpile'
        eqn << [ tok, eqn_parse_tree(str, limit: 1) ]
      when 'bar', 'under'
        eqn << [ tok, eqn.pop ]
      when 'dot', 'dotdot', 'dyad', 'vec'
        eqn << [ eqn.pop, tok ]
      when 'above', 'sub', 'sup'
        eqn << [ eqn.pop, [ tok, eqn_parse_tree(str, limit: 1) ] ]
      when 'from', 'to'
        eqn << [ eqn.pop, [ tok, eqn_parse_tree(str, limit: 1) ] ]
      when 'over'
        eqn << [ tok, eqn.pop, eqn_parse_tree(str, limit: 1) ]
      when 'sqrt', 'roman', 'bold', 'italic' #'lim', 'sqrt'
        eqn << [ tok, eqn_parse_tree(str, limit: 1) ]
      #when 'sum'
      #  eqn << [ tok, eqn_parse_tree(str, limit: 2) ]
      else
        eqn << tok
      end
    end
    eqn
  end

  # "Tokens within eqn are separated by braces, double quotes, tildes, circumflexes,
  #  SPACE, TAB, or NEWLINE characters."

  def get_eqn_token(str)
    resc = Regexp.quote @state[:escape_char]
    case str[0]
    #when ' ' then '' # REVIEW what are we actually meant to do with unquoted (non-tab) whitespace?
    when ' ' then str.slice!(0) and get_eqn_token(str) # do over? NOTE destructive
    #when '~', '^', ' ', "\t" then str[0]
    when '~', '^', "\t", '{', '}' then str[0]
    when @state[:escape_char] then str[0] + get_escape(str[1..-1])
    when '"'
      last = str.index(/(?<!#{resc})#{resc}#{resc}"|(?<!#{resc})"/, 1)
      str[0..last]
    else # count troff escapes as breaking, too. who knows if this will be correct, but lpadmin(1m) [SunOS 5.5.1] makes us deal with it
      # TODO will have to look ahead for diacritics, as these come after the token they apply to
      #      %w(dot dotdot hat tilde bar vec dyad under)
      last = str.index(/(?<!#{resc})#{resc}#{resc}[{}"~^\s#{resc}]|(?<!#{resc})[{}"~^\s#{resc}]/)
      last ? str[0..(last-1)] : str # may hit end of line
    end
  end

  def init_eqnchar
    @state[:eqnchars] = {
      #'~'        => '&nbsp;',
      #'^'        => '&thinsp;',
      '-'        => '&minus;',
      '->'       => '&rarr;',
      '<-'       => '&larr;',
      '<->'      => '&harr;',
      '<=>'      => '&hArr;',
      '|<'       => '&nlt;',
      '|>'       => '&ngt;',
      '<='       => '&le;',
      '>='       => '&ge;',
      '<<'       => '&Lt;',
      '>>'       => '&Gt;',
      '!='       => '&ne;',
      '+-'       => '&plusmn;',
      '=='       => '&equiv;',
      '==<'      => '&lE;',
      '==>'      => '&gE;',
      '...'      => '&ctdot;',      # REVIEW (center?) possible &hellip;
      '||'       => '&parallel;',	# REVIEW
      'inf'      => '&infin;',
      'int'      => '&int;',
      'sum'      => '&sum;',
      'sqrt'     => '&radic;',
      'ciplus'   => '&oplus;',
      'citimes'  => '&otimes;',
      'approx'   => '&approx;',
      'prime'    => '&prime;',
      'wig'      => '&sim;',
      '-wig'     => '&sime;',
      '>wig'     => '&gsim;',
      '<wig'     => '&lsim;',
      '=wig'     => '&cong;',
      'star'     => '&lowast;',
      'partial'  => '&part;',
      'bigstar'  => '\\s+4&lowast;\\s0',
      'cdot'     => '&centerdot;',
      '=dot'     => '&esdot;',
      'orsign'   => '&or;',
      'andsign'  => '&and;',
      '=del'     => '&trie;',
      'del'      => '&Del;',
      'grad'     => '&Del;',
      'times'    => '&times;',
      'oppA'     => '&forall;',
      'oppE'     => '&exist;',
      'angstrom' => '&#8491;',
      'langle'   => '&#10216;',
      'rangle'   => '&#10217;',
      'hbar'     => '&planck;',
      'ppd'      => '&perp;',
      'ang'      => '&ang;',
      'rang'     => '&angrt;',
      '3dot'     => '&vellip;',
      'thf'      => '&there4;',
      'quarter'  => '&frac14;',
      'half'     => '&frac12;',
      '3quarter' => '&frac34;',
      'degree'   => '&deg;',
      'square'   => '&#9633;',
      'circle'   => '&#9675;',
      'blot'     => '&#9632;',
      'bullet'   => '&bull;',
      'prop'     => '&prop;',
      'empty'    => '&empty;',
      'member'   => '&isin;',
      'nomem'    => '&notin;',
      'cup'      => '&cup;',
      'union'    => '&cup;',
      'cap'      => '&cap;',
      'inter'    => '&cap;',
      'incl'     => '&sqsube;',
      'subset'   => '&sub;',
      'supset'   => '&sup;',
      '!subset'  => '&sube;',
      '!supset'  => '&supe;',
      'scrL'     => '&ell;',
      'alpha'    => '&alpha;',
      'beta'     => '&beta;',
      'gamma'    => '&gamma;',
      'delta'    => '&delta;',
      'epsilon'  => '&epsilon;',
      'zeta'     => '&zeta;',
      'eta'      => '&eta;',
      'theta'    => '&theta;',
      'lambda'   => '&lambda;',
      'mu'       => '&mu;',
      'nu'       => '&nu;',
      'xi'       => '&xi;',
      'pi'       => '&pi;',
      'rho'      => '&rho;',
      'sigma'    => '&sigma;',
      'tau'      => '&tau;',
      'phi'      => '&phi;',
      'psi'      => '&psi;',
      'omega'    => '&omega;',
      'ALPHA'    => '&Alpha;',
      'BETA'     => '&Beta;',
      'GAMMA'    => '&Gamma;',
      'DELTA'    => '&Delta;',
      'EPSILON'  => '&Epsilon;',
      'ZETA'     => '&Zeta;',
      'ETA'      => '&Eta;',
      'THETA'    => '&Theta;',
      'LAMBDA'   => '&Lambda;',
      'MU'       => '&Mu;',
      'NU'       => '&Nu;',
      'XI'       => '&Xi;',
      'prod'     => '&Pi;',
      'PI'       => '&Pi;',
      'RHO'      => '&Rho;',
      'SIGMA'    => '&Sigma;',
      'TAU'      => '&Tau;',
      'PHI'      => '&Phi;',
      'PSI'      => '&Psi;',
      'OMEGA'    => '&Omega;'
    }
  end
end
