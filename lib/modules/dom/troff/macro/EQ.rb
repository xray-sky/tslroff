# EQ.rb
# -------------
#   troff
# -------------
#
#   .EQ
#
#     Begin equation (eqn) processing
#
#     troff does not alter .EQ/.EN lines, so they may be defined in macro packages to get
#     centering, numbering, etc.
#
#     use braces {} for grouping; generally speaking, anywhere you can use a single
#     character such as x, you may use a complicated construction enclosed in braces instead.
#
#     when processing between .EQ/.EN it looks like no requests or macros are processed.
#     no whitespace allowed; must end exactly with /^\.EN$/
#
#     Any argument to the .EQ macro will be placed at the right margin as an equation number.
#
#     Whitespace on input is not used to create space in the output. This includes newlines.
#     Tabs output. Spaces should be put around separate parts of the input. "pi" is not
#     recognized given the input, "f(pi)". It looks like maybe this is only important for
#     "sequences of letters".
#
#     Digits, parentheses, brackets, punctuation marks, and the following mathematical words
#     are converted to Roman font:
#     %w(sin cos tan sinh cosh tanh arc max min lim log ln exp Re Im and if for det)
#
#     As with the "sub" and "sup" keywords, size and font changes affect only the string that
#     follows and revert to the normal situation afterward.
#
#     'fat' is an allowed font style.
#     Legal font sizes are %w(6 7 8 9 10 11 12 14 16 18 20 22 24 28 36)
#     "In-line font changes must be closed before in-line equations are encountered."
#
#  TODO everything
#
#  words: sub sup over sqrt
#         from to left right c f
#         pile lpile cpile rpile matrix rcol
#         dot dotdot hat tilde bar vec dyad under
#         size roman italic bold font gsize gfont
#         mark lineup
#         define
#         sum int inf >= != -> (greek letters spelled out in desired case; alpha, GAMMA)
#         double quoted strings passed through untouched
#         to embolden digits, parentheses, etc. it is necessary to quote them,
#            as in bold "12.3", when used with the mm macro package.
#         displayed equations must appear only inside displays
#

EndOfEqn = Class.new(RuntimeError)

module Troff
  def req_EQ(*args)
    warn ".EQ received #{args.inspect} as args"
    # TODO save font/size & restore at end - would presumably also have to cover inline with delims
    #      but also honor gsize/gfont coming back in, etc.
    # TODO need to parse eqn in macro args too! e.g. .BR neqn(1) [SunOS 5.5.1] :: [190]
    #      so how much would it break if we moved it ahead of the req processing, like a true preprocessor?
    loop do
      parse_eqn(next_line)
    end
  rescue EndOfEqn => e
    true
  end

  def parse_eqn(line)
    # this is a desultory first draft just to get something happening
    # and clean the no request warnings out of stderr.
    # TODO probably gonna have to disregard escaped delims. maybe mid-word delims? (or is this handled already from parse())

    # "Set apart keywords recognized by eqn with spaces, tabs, new-lines, braces, double quotes, tildes, and circumflexes."
    # "Use braces for grouping; generally speaking, anywhere you can use a single character such as x, you may use a complicated constrution enclosed in braces instead."
    # "Tilde (~) represents a full space in the output, circumflex (^) half as much."
    words = line.split
    case words[0]
    when '.EN'
      raise EndOfEqn
    when 'delim'
      if words[1] == 'off'
        @state.delete(:eqn_start)
        @state.delete(:eqn_end)
        nil
      else
        (@state[:eqn_start], @state[:eqn_end]) = words[1].chars
      end
    when 'gfont' then warn "eqn requests gfont #{words[1]}" #@state[:eqn_gsize] = REVIEW are these going to be allowed to appear inline?
    when 'gsize' then warn "eqn requests gsize #{words[1]}" #@state[:eqn_gsize] =
    when 'ndefine' then nil
    when 'tdefine', 'define'
      if @state[:eqnchars].include? words[1] # TODO redefinitions allowed
        nil
      else
        delim = Regexp.quote words[2].first
        defstr = words[2..-1].join(' ').sub(/^#{delim}(.*)#{delim}\s*$/, '\1')
        warn "eqn wants to define new char #{words[1].inspect} as #{defstr.inspect}"
        @state[:eqnchars][words[1]] = defstr
      end
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
        eqnline = gen_eqn(line)
        #eqnparts = line.split(/(?<=(?<!#{resc})#{resc}#{resc})"|(?<!#{resc})"/)
        #while part = eqnparts.shift do
        #  eqnline << gen_eqn(part)
        #  eqnline << (eqnparts.shift || '') # shift will return nil if we run out of quoted parts
        #end
      else
        loop do
          break if line.empty?
          rbeg = Regexp.escape @state[:eqn_start]
          rend = Regexp.escape @state[:eqn_end]
          mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rbeg}|(?<!#{resc})#{rbeg}/)
          if mark
            head = line.slice!(0..mark).chop
            mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rend}|(?<!#{resc})#{rend}/)
            warn "eqn unterminated delim #{@state[:eqn_end].inspect}!" and break unless mark
            eqnline << head
            eqnline << gen_eqn(line.slice!(0..mark).chop)
            # need to pass " quoted stuff straight through to troff
            #eqnparts = line.slice!(0..mark).chop.split(/(?<=(?<!#{resc})#{resc}#{resc})"|(?<!#{resc})"/)
            #while part = eqnparts.shift do
            #  eqnline << gen_eqn(part)
            #  eqnline << (eqnparts.shift || '') # shift will return nil if we run out of quoted parts
            #end
          else
            eqnline << line.slice!(0..-1)
          end
        end
      end
      warn "eqn built up for unescape #{eqnline.inspect}"

=begin
      loop do # look for
        break if line.empty?
        #if line.start_with? '{'
          # do something
        #elsif line.start_with? '"'
        if line.start_with? '"'
          word = line.slice!(0, get_quot_str(line).length)
          line << word.sub(/^\"(.*)\"$/, '\1')
        else
          #word = line.slice!(/^(\s*)(\S+)(\s+|$)/)
          #(asep, word, bsep) = Regexp.last_match.to_a[1..3]
          #eqchar = @state[:eqnchars][word] || ''.tap { warn "eqn has no character definition for #{word.inspect}" }
          #words = line.slice!(/^[^"]*/).gsub(/(?<=^|\s)(?:#{@state[:eqnchars].keys.collect{|c|Regexp.quote c}.join('|')})(?=\s|$)/) { |c| @state[:eqnchars][c] }
          #apply { @current_block.text.last.style[:eqn] = true }
          #unescape asep + eqchar + bsep
          #unescape words
          #apply { @current_block.text.last.style.delete(:eqn) }
        #loop do
        #  break if line.empty?
          # this seems to be the magic to match an unescaped eqn_start
          # while not being fooled by an escaped escape
          mark = line.index(/(?<!#{resc})#{resc}#{resc}#{rbeg}|(?<!#{resc})#{rbeg}/)
          if mark
            # eqn throws away the whole line if the delims are unbalanced.
            # we emit partial lines so pay attention to the complaints log.
            # don't spit out a blank if delim is the first thing on the line
            head = line.slice!(0..mark).chop
            parse head unless head.empty?
            tail = line.index(/(?<!#{resc})#{resc}#{resc}#{rend}|(?<!#{resc})#{rend}/)
            warn "eqn unterminated delim #{@state[:eqn_end].inspect}!" and break unless tail
            eqnline << line.slice!(0..tail).chop
          end
        end

        end
      end
=end
      apply { @current_block.text.last.style[:eqn] = true }
      unescape eqnline
      apply { @current_block.text.last.style.delete(:eqn) }
    end
  end

=begin
this isn't going to work as a bunch of .sub calls
  # TODO set straight text (variable names) in italic (?), don't italicize numbers or etc.
  def gen_eqn(str)
    str.gsub!(/\s*(sub|sup)\s(\{.+?\}|\S+)/) do |m|
    (w,arg) = m.split
      case w
      when 'sub' then "\\d\\s-3#{arg}\\s0\\u".tap{|n| warn "eqn replacing sub with #{n.inspect}" }
      when 'sup' then "\\u\\s-3#{arg}\\s0\\d".tap{|n| warn "eqn replacing sup with #{n.inspect}" }
      end
    end
    # TODO parse keywords like 'sub' and 'sup', probably before running the character translations
    # TODO some of the translations like ~ and ^ don't need to be surrounded by spaces but
    #      some do? otherwise we translate 'printer' to 'pr&int;er' -- lpadmin(1m) [SunOS 5.5.1]
    sorted_keys = @state[:eqnchars].keys.sort { |a,b| b.length <=> a.length } # longest to shortest
    str.gsub(/#{sorted_keys.collect{|c|Regexp.quote c}.join('|')}/) { |c| @state[:eqnchars][c] }
  end
=end

  def gen_eqn(str)
    eqnstr = ''
    until str.empty? do
      eqnstr << case tok = str.slice!(0, get_eqn_token(str).tap{ |n| warn "gen_eqn got token #{n.inspect}" }.length)
                #when ' ' then ''
                when "\t" then tok
                when '~' then '&nbsp;'
                when '^' then '&thinsp;'
                when /^#{Regexp.quote @state[:escape_char]}/ then tok
                when /^"/ then tok.sub(/^"(.*)"$/, '\1') # pass through
                when /^{/ then gen_eqn(tok.sub(/^\{(.*)\}/, '\1')) # "block"
                when 'sub' then "\\v@0.33m@\\s-3#{gen_eqn(str.slice!(0, get_eqn_token(str).length))}\\s0\\v@-0.33m@" # REVIEW recursive.. is this too destructive of str?
                when 'sup' then "\\v@-0.33m@\\s-3#{gen_eqn(str.slice!(0, get_eqn_token(str).length))}\\s0\\v@0.33m@" # REVIEW recursive.. is this too destructive of str?
                # TODO eqn(1) [SunOS 5.5.1] has some of these as "shorthands" with no space
                #      separating them from () - they are recognized, but we don't.
                #      should ( and ) be their own tokens? - I think probably not?
                when /^(?:#{@state[:eqnchars].keys.collect{|c|Regexp.quote c}.join('|')})$/ then @state[:eqnchars][tok]
                else
                  tok.gsub(/[A-Za-z]+|[^A-Za-z]+/) do |m|
                  warn "entered gsub with #{m.inspect}"
                  # REVIEW might need to do our own equivalent of \fP etc.
                  #        in order to protect bozos like lpadmin(1m) [SunOS 5.5.1]
                  #        yeah - something's not quite right, how do we not get
                  #        messed by trying to italicize variables but also have
                  #        lpadmin(1m) e.g. [779, 780, etc.] doing font changes with \fP
                  #        [780] in particular. actually a "full reset" leaving eqn
                  #        would probably cover [780], and the rest actually looks ok
                  #        despite the ugly local font changes
                    if m.match?(/[A-Za-z]/)
                      "\\f2#{m}\\fP"
                    else
                      "\\f1#{m}\\fP"
                    end
                  end
                end
    end
    eqnstr
  end

  # "Tokens within eqn are separated by braces, double quotes, tildes, circumflexes,
  #  SPACE, TAB, or NEWLINE characters."

  def get_eqn_token(str)
    resc = Regexp.quote @state[:escape_char]
    case str[0]
    #when ' ' then '' # REVIEW what are we actually meant to do with unquoted (non-tab) whitespace?
    when ' ' then str.slice!(0) and get_eqn_token(str) # do over? NOTE destructive
    #when '~', '^', ' ', "\t" then str[0]
    when '~', '^', "\t" then str[0]
    when @state[:escape_char] then str[0] + get_escape(str[1..-1])
    when '{' # BEWARE NESTED {}! eqn(1) [SunOS 5.5.1]
      #last = str.index(/(?<!#{resc})#{resc}#{resc}\}|(?<!#{resc})\}/)
      #str[0..last]
      closing = 1
      depth = 0
      skip = false
      str[1..-1].each_char do |c,i|
        case c
        when '}'
          unless skip
            break if depth.zero?
            depth = depth - 1
          end
        when '{'
          depth = depth + 1 unless skip
        when "\\"
          skip = skip ? false : true
        end
        closing = closing + 1
      end
      str[0..closing]
    when '"'
      last = str.index(/(?<!#{resc})#{resc}#{resc}"|(?<!#{resc})"/, 1)
      str[0..last]
    else # count troff escapes as breaking, too. who knows if this will be correct, but lpadmin(1m) [SunOS 5.5.1] makes us deal with it
      # TODO will have to look ahead for diacritics, as these come after the token they apply to
      #      %w(dot dotdot hat tilde bar vec dyad under)
      last = str.index(/(?<!#{resc})#{resc}#{resc}[{"~^\s#{resc}]|(?<!#{resc})[{"~^\s#{resc}]/)
      last ? str[0..(last-1)] : str # may hit end of line
    end
  end

  def init_eqnchar
    @state[:eqnchars] = {
      #'~'        => '&nbsp;',
      #'^'        => '&thinsp;',
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
      '+-'       => '&plusmn;'
      '=='       => '&equiv;'
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
      'sum'      => '&Sigma;',
      'TAU'      => '&Tau;',
      'PHI'      => '&Phi;',
      'PSI'      => '&Psi;',
      'OMEGA'    => '&Omega;'
    }
  end
end
