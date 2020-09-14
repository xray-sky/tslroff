class Line

  @@typebox = {
	'A' => '&Alpha;',   'G' => '&Gamma;',  'S'  => '&epsilon;',  'O' => '&Theta;',  'E' => '&Lambda;',
	'X' => '&xi;',      'K' => '&rho;',    'I'  => '&tau;',      'V' => '&psi;',    'Z' => '&Omega;',
	']' => '&part;',    'B' => '&beta;',   'D'  => '&delta;',    'Q' => '&zeta;',   'T' => '&theta;',
	'M' => '&mu;',      'J' => '&pi;',     'Y'  => '&sigma;',    'U' => '&#981;',   'H' => '&Psi;',
	'[' => '&nabla;',   '^' => '&int;',    "\\" => '&gamma;',    'W' => '&Delta;',  'N' => '&eta;',
	'L' => '&lambda;',  '@' => '&nu;',     'P'  => '&Pi;',       'R' => '&Sigma;',  'F' => '&Phi;',
	'C' => '&omega;',   '_' => '&not;'
  }

  @@typebox.default_proc = Proc.new { |_hash, key| %(<span class="u">typebox (#{key})</span) }

  attr_accessor :section

  def initialize
    @superscript = Array.new
    @baseline = Array.new
    @line = :@baseline
    @section = ''
  end

  def print_at(x, char)
    line = instance_variable_get(@line)
    line[x] ||= String.new
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

  private

  def typeset(text_cells)
    formats = Array.new
    close_styles = Proc.new { fmt = ''
                              formats.reverse!.reject! do |f|
                                fmt << case f
                                       when :bold then '</em>'
                                       when :underline then '</span>'
                                       end
                              end
                              fmt }

    line = text_cells.collect do |cell|
      # shortcut normal single characters and whitespace
      cell ||= ' '  # this position was never set (was spaced or tabbed over)
      if cell.length == 1
        cell.sub!(/&/, '&amp;')
        cell.sub!(/>/, '&gt;')
        cell.sub!(/</, '&lt;')
        close_styles.call + cell
      else # something extra happens
        out = ''

        # repeated characters are overstrikes
        # reduce to single instance of each and turn on bold
        if cell.gsub!(%r((\S)+(.*)\1+), '\1\2')
          unless formats.include?(:bold)
            formats << :bold
            out << '<em>'
          end
        else
          out << '</em>' if formats.delete(:bold)
        end

        # underscores may be combined with other characters to produce underlines
        if cell.gsub!(%r(_+), '')
          unless formats.include?(:underline)
            formats << :underline
            out << '<span class="ul">'
          end
        else
          out << '</span>' if formats.delete(:underline)
        end

        # compose overstruck characters (may have been piled up in any order)
        # also entitize < and > that were underlined or emboldened
        out << case cell
               when ''          then ' '		# REVIEW is this right? how would I tell? how do we even end up here?
               when '&'         then '&amp;'
               when '>'         then '&gt;'
               when '<'         then '&lt;'
               when /^.$/       then cell       # any other single character: here because bold or underline
               when /[HXI]{3}/  then '&#9764;'  # U25FC see eqnchr(5) [DG/UX 4.30]
               when /['I,]{3}/  then '&int;'    #       see eqnchr(5) [DG/UX 4.30]
               when /[oex]{3}/  then '&bull;'   #       see eqnchr(5) [DG/UX 4.30]
               when /[-\/C]{3}/ then '&notin;'  #       (etc.)
               when /[\/oE]{3}/ then '&exist;'
               when /[-C]{2}/   then '&isin;'
               when /[-n]{2}/   then '&pi;'
               when /[-h]{2}/   then '&#8463;'  # U210F
               when /[-V]{2}/   then '&forall;'
               when /[=<]{2}/   then '&#8806;'  # U2266
               when /[=>]{2}/   then '&#8807;'  # U2267
               when /[~<]{2}/   then '&#8818;'  # U2272
               when /[~>]{2}/   then '&#8819;'  # U2273
               when /[~=]{2}/   then '&#8773;'  # U2245
               when /[-+]{2}/   then '&plusmn;'
               when /[|~]{2}/   then '&Gamma;'  # see gamma(3) [CLIX-7.6.22]
               when /[|+]{2}/   then '&dagger;'
               when /[|-]{2}/   then '&dagger;'
               when /[|=]{2}/   then '&Dagger;'
               when /[|v]{2}/   then '&darr;'
               when /[|^]{2}/   then '&uarr;'
               when /[|<]{2}/   then '&#8814;'  # U226E
               when /[|>]{2}/   then '&#8815;'  # U226F
               when /[\/(]{2}/  then '&#8467;'  # U2113
               when /['e]{2}/   then '&eacute;'
               when /[\/c]{2}/  then '&cent;'
               when /[\/=]{2}/  then '&ne;'
               when /[\/L]{2}/  then '&#0321;'
               when /[\/l]{2}/  then '&#0322;'
               when /[\/O]{2}/  then '&empty;'
               when /[+o]{2}/   then '&oplus;'
               when /[+O]{2}/   then '&oplus;'
               when /[xO]{2}/   then '&otimes;'
               when /[rO]{2}/   then '&reg;'
               when /[cO]{2}/   then '&copy;'
               when /[<a]{2}/   then '&alpha;'
               when /[f,]{2}/   then '&fnof;'
               when /[#^]{2}/   then '&#9636;'  # curses "board of squares" equivalent
               when /(.)\cN/    then @@typebox[Regexp.last_match[1]]
               else
                 warn "unresolved overstrike #{cell.inspect}"
                 base = cell[0]
                 pile = cell[1..-1].chars.collect { |c| %(<span class="pile">#{c}</span>) }.join
                 %(<span class="clash">#{base}#{pile}</span>)
               end
        out
      end
    end.join

    line.gsub!(%r{((<[^<]+?>)*(\S+?)(<.+?>)*\((<.+?>)*((\d.*?)(-.*?)*)(<.+?>)*\)(<.+?>)*)}) {
      %(<a href="../man#{$7.downcase}/#{$3}.#{$6.downcase}.html">#{$1}</a>)
    } if @section == Manual.related_info_heading # TODO the regexp should be reusable in Block context instead of copied & pasted
    line + close_styles.call
  end

end
