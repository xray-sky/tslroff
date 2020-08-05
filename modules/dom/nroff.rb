# nroff.rb
# ---------------
#    nroff source
# ---------------
#


module Nroff

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

  def source_init

    Dir.glob("#{File.dirname(__FILE__)}/nroff/*.rb").each do |i|
      require i
    end

    require "modules/platform/#{self.platform.downcase}.rb"
    self.extend Kernel.const_get(self.platform.to_sym)

    @tab_width = 8
    @lines_per_page = 66
    load_version_overrides

  end

  def to_html

    alt_typebox_shift = false
    escape_shift = false
    printhead_position = 0  # leftmost column
    platen_position   = 1  # top of page, with room for one backward half-linefeed
    section = ''

    loop do
      begin
        input_line = @lines.next

        # watch for text starting in first column, which would be a title or section head
        unformat(input_line).match(/^([A-Z][A-Za-z\s]+)$/)
        section = Regexp.last_match[1].chomp if Regexp.last_match

        input_line.each_char do |char|

          page_ptr = platen_position / (2 * @lines_per_page)
          @document[page_ptr] ||= Block.new(type: :nroff, text: [])
          line_ptr = (platen_position - 2 * @lines_per_page * page_ptr) / 2
          @document[page_ptr].text[line_ptr] ||= Line.new
          line = @document[page_ptr].text[line_ptr]
          line.section = section
          platen_position % 2 == 0 ? line.up! : line.down!

          case char
          when ' '   then printhead_position += 1
          when "\n"  then platen_position += 2 and printhead_position = 0
          when "\cH" then printhead_position -= 1 unless printhead_position.zero?   # ignore a backspace in leftmost column
          when "\cI" then printhead_position += (@tab_width - printhead_position % @tab_width)
          when "\cM" then printhead_position = 0
          when "\cN" then alt_typebox_shift = true
          when "\cO" then alt_typebox_shift = false
          when "\c[" then escape_shift = true
          else
            if escape_shift
              case char
              when '7' then platen_position -= 2 unless (platen_position < 2 and warn "tried to backfeed off the @document?" and true)
              when '8' then platen_position -= 1 unless (platen_position < 1 and warn "tried to half-backfeed off the @document?" and true)
              when '9' then platen_position += 1
              else warn "processing unknown escape sequence [#{char}"
              end
              escape_shift = false
            else
              line.print_at(printhead_position, char)
              line.print_at(printhead_position, "\cN") if alt_typebox_shift
              printhead_position += 1
            end
          end
        end
      rescue StopIteration
        return @document.collect(&:to_html).join
      end
    end
  end

  private

  def unformat(line)
    # kill carriage control, underlining (where _ is printed first),
    # bold and other character overstrike effects, and line-at-a-time overstrike effects
    # assumes normal text printed first in line-at-a-time overstrike, which may not be true (DG/UX 4.30)
    # REVIEW might need to be done one at a time, in sequence, to be properly effective.
    line.gsub(%r((\e.|_\cH|\cH.|\cM.*)), '')
  end

end
