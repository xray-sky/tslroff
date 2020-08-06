# nroff.rb
# ---------------
#    nroff source
# ---------------
#

module Nroff


  def source_init

    Dir.glob("#{File.dirname(__FILE__)}/nroff/*.rb").each do |i|
      require i
    end

    require "modules/platform/#{self.platform.downcase}.rb"
    self.extend Kernel.const_get(self.platform.to_sym)

    @tab_width = 8
    @lines_per_page = 66
    # watch for alphabetic text starting in first column, which would be a title or section head
    @heading_detection = %r(^([A-Z][A-Za-z\s]+)$)
    load_version_overrides

  end

  def to_html

    alt_typebox_shift  = false
    escape_shift       = false
    platen_position    = 1      # top of page, with room for one backward half-linefeed
    printhead_position = 0      # leftmost column
    section            = ''     # give this life outside the following loop

    loop do
      begin
        input_line = @lines.next

        unformat(input_line).match(@heading_detection)
        section = Regexp.last_match[1].chomp if Regexp.last_match

        input_line.each_char do |char|

          page = platen_position / (2 * @lines_per_page)
          @document[page] ||= Block.new(type: :nroff, text: [])

          line = (platen_position - 2 * @lines_per_page * page) / 2
          @document[page].text[line] ||= Line.new

          text = @document[page].text[line]
          text.section = section
          platen_position % 2 == 0 ? text.up! : text.down!

          # REVIEW I wonder if these control characters ought to be programmable
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
              text.print_at(printhead_position, char)
              text.print_at(printhead_position, "\cN") if alt_typebox_shift
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
