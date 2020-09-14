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

module Troff
  def req_EQ(*)
    @lines.collect_through { |l| l.match(/^.EN/) }[0..-2].each do |line|
      @register['.c'].incr
      parse_eqn(line)
    end
  end

  def parse_eqn(line)
    # this is a desultory first draft just to get something happening
    # and clean the no request warnings out of stderr.
    # TODO probably gonna have to disregard escaped delims. maybe mid-word delims? (or is this handled already from parse())
    warn "eqn parsing #{line.inspect}"

    # "Set apart keywords recognized by eqn with spaces, tabs, new-lines, braces, double quotes, tildes, and circumflexes."
    # "Use braces for grouping; generally speaking, anywhere you can use a single character such as x, you may use a complicated constrution enclosed in braces instead."
    # "Tilde (~) represents a full space in the output, circumflex (^) half as much."
    words = line.split
    case words[0]
    when 'delim' then (@state[:eqn_start], @state[:eqn_end]) = words[1].chars
    else
      if @state[:eqn_start]
        (beginning, eqn, ending) = line.match(/(.*?)#{Regexp.escape @state[:eqn_start]}(.+?)#{Regexp.escape @state[:eqn_end]}(.*)$/).to_a[1..3]
        unescape(beginning) if beginning
        eqn ||= line.chomp
        eqn.gsub!(/(?<=\s)(?:#{@state[:eqnchars].keys.join('|')})(?=\s)/) { |c| @state[:eqnchars][c] } # REVIEW I don't imagine this is sufficient.
        eqn.gsub!(/"/, '') # REVIEW this is DEFINITELY not sufficient
        apply { @current_block.text.last.style[:eqn] = true }
        unescape(eqn)
        apply { @current_block.text.last.style.delete(:eqn) }
        #@current_block << "&roffctl_unsupp;eqn(#{(eqn).inspect})&roffctl_endspan;"
        unescape(ending) if ending
      else
        line.gsub!(/(?<=\s)(?:#{@state[:eqnchars].keys.collect{|c|Regexp.quote c}.join('|')})(?=\s)/) { |c| @state[:eqnchars][c] } # REVIEW I don't imagine this is sufficient.
        #after translating all the eqn words, unquote the regular words
        line.gsub!(/"/, '') # REVIEW this is DEFINITELY not sufficient
        #@current_block << "&roffctl_unsupp;eqn(#{line.inspect})&roffctl_endspan;"
        apply { @current_block.text.last.style[:eqn] = true }
        unescape(line)
        apply { @current_block.text.last.style.delete(:eqn) }
      end
    end
  end

  def init_eqnchar
    @state[:eqnchars] = {
      '~' => '&nbsp;',
      '^' => '&thinsp;',
      'ciplus' => '&oplus;',
      'citimes' => '&otimes;',
      'wig' => '&sim;',
      '-wig' => '&sime;',
      '>wig' => '&gsim;',
      '<wig' => '&lsim;',
      '=wig' => '&cong;',
      'star' => '&lowast;',
      'bigstar' => '\\s+4&lowast;\\s0',
      '=dot' => '&esdot;',
      'orsign' => '&or;',
      'andsign' => '&and;',
      '=del' => '&trie;',
      'oppA' => '&forall;',
      'oppE' => '&exist;',
      'angstrom' => '&#8491;',
      '==<' => '&lE;',
      '||' => '&parallel;',	# REVIEW
      'langle' => '&#10216;',
      'rangle' => '&#10217;',
      'hbar' => '&planck;',
      'ppd' => '&perp;',
      '<->' => '&harr;',
      '<=>' => '&hArr;',
      '|<' => '&nlt;',
      '|>' => '&ngt;',
      'ang' => '&ang;',
      'rang' => '&angrt;',
      '3dot' => '&vellip;',
      'thf' => '&there4;',
      'quarter' => '&frac14;',
      '3quarter' => '&frac34;',
      'degree' => '&deg;',
      '==>' => '&gE;',
      'square' => '&#9633;',
      'circle' => '&#9675;',
      'blot' => '&#9632;',
      'bullet' => '&bull;',
      'prop' => '&prop;',
      'empty' => '&empty;',
      'member' => '&isin;',
      'nomem' => '&notin;',
      'cup' => '&cup;',
      'cap' => '&cap;',
      'incl' => '&sqsube;',
      'subset' => '&sub;',
      'supset' => '&sup;',
      '!subset' => '&sube;',
      '!supset' => '&supe;',
      'scrL' => '&ell;'
    }
  end
end
