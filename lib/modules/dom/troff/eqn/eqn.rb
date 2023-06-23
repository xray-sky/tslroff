Dir.glob("#{__dir__}/words/*.rb").each do |i|
  require_relative i
end

module Eqn

  def eqn_setup
    @state[:eqn_active] = true
    @eqnhold = @current_block
    @current_block = EqnBlock.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    # save and set fonts
    @register['98'] = @register['.f'].dup
    @register['99'] = @register['.s'].dup
    req_ft "#{@state[:eqn_gfont]}"
    req_ps "#{@state[:eqn_gsize]}"
  end

  def eqn_restore
    @state[:eqn_active] = false
    @eqnhold << @current_block
    @current_block = @eqnhold
    # restore fonts
    # seems to happen two or more times, through various strategies
    # I guess to make sure that \s0 and \fP get cleared?
    req_ft @register['98'].to_s
    req_ft @register['98'].to_s
    req_ps @register['99'].to_s
    req_ps @register['99'].to_s
  end

  def parse_eqn(line, inline: true)
    # this is a desultory first draft just to get something happening
    # and clean the no request warnings out of stderr.
    # TODO probably gonna have to disregard escaped delims. maybe mid-word delims? (or is this handled already from parse())

    # "Set apart keywords recognized by eqn with spaces, tabs, new-lines, braces, double quotes, tildes, and circumflexes."
    # "Use braces for grouping; generally speaking, anywhere you can use a single character such as x, you may use a complicated constrution enclosed in braces instead."
    # "Tilde (~) represents a full space in the output, circumflex (^) half as much."
    words = line.split
    if !inline and respond_to? "eqn_#{words[0]}" # avoid sending input lines with inline eqn, which start with e.g. 'from' to eqn_bounds
      send "eqn_#{words[0]}", line[words[0].length + 1..-1]
    else
      case words[0]
      #when '.EN'
      #  raise EndOfEqn
      when /^[\.']/ # is request
        parse line
      else
        warn "eqn parsing #{line.inspect}"
        # I think we will want to do the delim processing outside of here, and only send
        # whatever's inside delim to parse_eqn. leave this to just doing eqn and nothing else.
        #
        # we don't, because piece-mealing the calls to unescape results in extraneous breaks
        # we can assume, however, that if we got here, there is definitely eqn to parse.
        #
        # so, if there are no delimiters, then we are in .EQ/.EN and the whole line goes

        resc = Regexp.quote @state[:escape_char]
        eqnline = ''

        unless @state[:eqn_start] and line.match?(/(?<!#{resc})#{resc}#{resc}#{Regexp.quote @state[:eqn_start]}|(?<!#{resc})#{Regexp.quote @state[:eqn_start]}/)
          # we are parsing .EQ/.EN
          #warn ".EQ parse_tree built #{eqn_parse_tree(line.dup).inspect}"

          eqn_setup
          gen_eqn eqn_parse_tree(line)
          eqn_restore

        else
          ## need to temporarily suppress :nofill
          fill = @register['.u'].value
          # req_fi breaks, has block-related side effects
          @register['.u'].value = 1
          loop do
            break if line.empty?
            rbeg = Regexp.escape @state[:eqn_start]
            rend = Regexp.escape @state[:eqn_end]
            mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rbeg}|(?<!#{resc})#{rbeg}/)
            if mark
              head = line.slice!(0..mark).chop
              mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rend}|(?<!#{resc})#{rend}/)
              #warn "eqn unterminated delim #{@state[:eqn_end].inspect}!" and break unless mark
              unless mark
                warn "eqn unterminated delim #{@state[:eqn_end].inspect}! -- pulling next line"
                line << next_line
              end
              unescape head
              eqn_setup
              gen_eqn eqn_parse_tree(line.slice!(0..mark).chop)
              eqn_restore
            else
              unescape line.slice!(0..-1)
            end
          end
          @register['.u'].value = fill
        end
      end
    end
  end

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
        when 'fat'
          warn "eqn no support yet for keyword '#{elem}'"
          unescape elem
        when 'back', 'fwd', 'up', 'down'
          warn "eqn no support yet for keyword '#{elem} #{parse_tree.shift.inspect}'"
          gen_eqn [ parse_tree.shift ]
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
                m = "\\|#{m}" if @register['.f'].value == 2 and !@current_block.terminal_text_obj.empty?
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
      when 'sqrt', 'roman', 'bold', 'italic', 'fat' #'lim', 'sqrt'
        eqn << [ tok, eqn_parse_tree(str, limit: 1) ]
      when 'fwd', 'back', 'up', 'down'
        eqn << [ tok, eqn_parse_tree(str, limit: 1), eqn_parse_tree(str, limit: 1) ]
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
