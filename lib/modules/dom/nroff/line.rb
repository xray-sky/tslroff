class TypeClashError < RuntimeError
  attr_accessor :pile
  def initialize(pile)
    super
    @pile = pile
  end
end

class Line

  OVERSTRIKES = {
    %w[&]   => '&amp;',     %w[<]   => '&lt;',      %w[>]    => '&gt;',
    %w[O c]  => '&copy;',   %w[< a]  => '&alpha;',  %w[, f]  => '&fnof;',
    %w[/ E o] => '&exist;', %w[- C]  => '&isin;',   %w[- n]  => '&pi;',     %w[- V]  => '&forall;',
    %w[+ |]  => '&dagger;', %w[- |]  => '&dagger;', %w[= |]  => '&Dagger;', %w[v |]  => '&darr;',
    %w[+ -]  => '&plusmn;', %w[^ |]  => '&uarr;',   %w[' e]  => '&eacute;', %w[/ c]  => '&cent;',
    %w[/ =]  => '&ne;',     %w[/ L]  => '&#0321;',  %w[/ l]  => '&#0322;',  %w[/ O]  => '&empty;',
    %w[+ o]  => '&oplus;',  %w[+ O]  => '&oplus;',  %w[O x]  => '&otimes;', %w[O r]  => '&reg;',
    %w[H I X] => '&#9724;',  # U25FC see eqnchar(5) [DG/UX 4.30]
    %w[' , I] => '&int;',    #       see eqnchar(5) [DG/UX 4.30]
    %w[e o x] => '&bull;',   #       see eqnchar(5) [DG/UX 4.30]
    %w[- : = o] => '&bull;', #       see syslogd(8n), others. [UTek 6130-W2.3]
    %w[- / C] => '&notin;',  #       (etc.)
    %w[- h]  => '&#8463;',   # U210F
    %w[< =]  => '&#8806;',   # U2266
    %w[> =]  => '&#8807;',   # U2267
    %w[< ~]  => '&#8818;',   # U2272
    %w[> ~]  => '&#8819;',   # U2273
    %w[= ~]  => '&#8773;',   # U2245
    %w[< |]  => '&#8814;',   # U226E
    %w[> |]  => '&#8815;',   # U226F
    %w[| ~]  => '&Gamma;',   # see gamma(3) [CLIX-7.6.22] (is actually rendered as ~^H|~ )
    %w[# ^]  => '&#9636;',   # curses "board of squares" equivalent
    %w[- . X |] => '&lowast;', # see eqnchar(7) [Domain/OS SR10.4]
    ['(', '/']  => '&#8467;',  # U2113
    %w[- d |]   => %(<span class="clash">d<span class="pile">&dagger;</span></span>), # see cw(1), etc. [A/UX 3.0.1]
  }

  OVERSTRIKES.default_proc = proc do |_hash, key|
    key.collect! { |c| c.sub(/(.)\cN/) { |s| TYPEBOX[Regexp.last_match[1]] } }
    key.length == 1 and next key[0]
    #warn "unresolved overstrike #{key.inspect}"
    #base = key[0]
    #pile = key[1..-1].chars.collect { |c| %(<span class="pile">#{c}</span>) }.join
    #%(<span class="clash">#{base}#{pile}</span>) # REVIEW: this visual effect only works for two-character clashes?
    raise TypeClashError.new(key), 'unresolved overstrike'
  end
  OVERSTRIKES.freeze # REVIEW: do I really want to freeze this, or make it platform overrideable somehow

  TYPEBOX = {
  	'A' => '&Alpha;',   'G' => '&Gamma;',  'S'  => '&epsilon;',  'O' => '&Theta;',  'E' => '&Lambda;',
	  'X' => '&xi;',      'K' => '&rho;',    'I'  => '&tau;',      'V' => '&psi;',    'Z' => '&Omega;',
  	']' => '&part;',    'B' => '&beta;',   'D'  => '&delta;',    'Q' => '&zeta;',   'T' => '&theta;',
	  'M' => '&mu;',      'J' => '&pi;',     'Y'  => '&sigma;',    'U' => '&#981;',   'H' => '&Psi;',
  	'[' => '&nabla;',   '^' => '&int;',    "\\" => '&gamma;',    'W' => '&Delta;',  'N' => '&eta;',
	  'L' => '&lambda;',  '@' => '&nu;',     'P'  => '&Pi;',       'R' => '&Sigma;',  'F' => '&Phi;',
  	'C' => '&omega;',   '_' => '&not;'
  }

  TYPEBOX.default_proc = proc { |_hash, key| %(<span class="u">typebox (#{key})</span>) }
  TYPEBOX.freeze

  STYLES = {
    start: { bold: '<em>',  underline: '<span class="ul">' },
    end:   { bold: '</em>', underline: '</span>' }
  }.freeze

  @@link_detect = %r{(?<styled_ref>(?:<[^<]+?>)*(?<entry>\S+?)(?:<.+?>)*\((?:<.+?>)*(?<full_section>(?<section>\d.*?)(?<subsection>-.*?)*)(?:<.+?>)*\)(?:<.+?>)*)}
  @@linkify = lambda do |ref|
    %(<a href="../man#{ref[:full_section].downcase}/#{ref[:entry]}.html">#{ref[:styled_ref]}</a>)
  end

  attr_accessor :section, :links

  def initialize(source: '')
    @input_filename = source
    @formats = []
    @superscript = []
    @baseline = []
    @line = :@baseline
    @section = ''
  end

  def print_at(x, char)
    line = instance_variable_get(@line)
    line[x] ||= ''
    line[x] << char
  end

  def superscripts?
    @superscript.any?
  end

  def down!
    @line = :@baseline
  end

  def up!
    @line = :@superscript
  end

  def to_html
    if superscripts?
      # the newline needs to be _inside_ the half-line-height div or else it'll be full line-height
      %(<div class="halfline">#{typeset(@superscript)}\n</div>) +
      %(<div class="halfline">#{typeset(@baseline)}\n</div>)
    else
      typeset(@baseline) + "\n"
    end
  end

  def self.link_detect(regexp)
    @@link_detect = regexp
  end

  def self.linkify(&block)
    @@linkify = block
  end

  private

  def set_style!(style)
    if @formats.include? style
      ''
    else
      @formats << style
      STYLES[:start][style]
    end
  end

  def end_style!(style)
    @formats.delete(style) ? STYLES[:end][style] : ''
  end

  def clear_styles!
    fmt = @formats.reverse.map { |f| STYLES[:end][f] }.join
    @formats = []
    fmt
  end

  def typeset(text_cells)
    line = text_cells.collect do |cell|
      # shortcut normal single characters and whitespace
      # this position was never set (was spaced or tabbed over)
      cell ||= ' '

      # a single character is just output (entitizing &, <, and >)
      # any bold or underlining is turned off.
      cell.length == 1 and next(clear_styles! +
                                cell.sub(/([&<>])/) { |_m| OVERSTRIKES[[Regexp.last_match[1]]] })

      out = ''
      # repeated characters are overstrikes
      # reduce to single instance of each and turn on bold
      # TODO: losing characters out of this (rang, eqnchar(5bsd) [Domain/OS SR10.4])
      #       L^H.^H. is coming out as <em>.</em>, probably damage from col. is it worth fixing? an unbold L and a bold . ?
      # TODO: losing clashes out of bold too (title, mklost+found(1M-SysV) [RISC/os 4.52]
      # REVIEW: is the solution to this (and maybe of underline too?) to sort ahead of OVERSTRIKES?
      out << (cell.gsub!(%r((\S)+(.*)\1+), '\1\2') ? set_style!(:bold) : end_style!(:bold))

      # underscores may be combined with other characters to produce underlines
      # we might get here with a literal underscore, if it was bold - don't turn it into an underline
      # TODO: getting underline on shift-out '_' :: greek(5) [A/UX 3.0.1]
      out << (cell.gsub!(%r(_+), '') ? set_style!(:underline) : end_style!(:underline)) unless cell == '_'

      # compose overstruck characters (may have been piled up in any order)
      # any typebox shift-outs have to be kept with the preceeding character
      begin
        out << OVERSTRIKES[cell.scan(/.\cN?/).sort]#.join]
      rescue TypeClashError => e
        key = e.pile
        warn "#{@input_filename}: #{e.message} #{key.inspect}"
        #base = key[0]
        #pile = key[1..-1].collect { |c| %(<span class="pile">#{c}</span>) }.join
        #out << %(<span class="clash">#{base}#{pile}</span>) # REVIEW: this visual effect only works for two-character clashes
        out << %(<span class="clash">#{key.join('<br />')}</span>)
      end
      out
    end.join

    @links && @links.sort { |a, b| b[0].length <=> a[0].length }.each do |entry, link|
      # allow any number of html tags to appear in the middle of the link text
      # with an extra restriction on <a> tags, so as to not interfere destructively
      # with links we may have already inserted. SR10.4 setprot.hlp will demo failure here.
      # ("any tag not starting with a, and don't allow .*? to encompass more than one tag")
      # TODO: this still backfired in the case of SR10.4 BSD term(7) - sh(1) in the middle of csh(1)
      #       can't assume there will _always_ be a whitespace preceeding a reference
      #       term(7) has space with no comma; inty(1) has comma with no space
      # NOTE: there's some chance we got here with a \t in the entry text (SR10.4 protection/acls.hlp)
      link_text = Regexp.escape(entry).gsub(/([^\\])/, '\1(?:<[^a][^<]*?>)*').gsub(/\\t/, '\s+')
      # NOTE: allow matching underlined refs (e.g. UTek W2.3):
      #       there will be a start tag (<span>) not encompassed by link_text
      # NOTE: AIX PS/2 1.2.1 refs are surrounded by double quotes
      line.sub!(%r{(^|[\s,;.]|(?<!=)")((?:<[^a][^<]*?>)*#{link_text})}) { |_m| %(#{Regexp.last_match[1]}<a href="#{link}">#{Regexp.last_match[2]}</a>) }
    end
    line + clear_styles!
  end

#  def
end
