# nroff.rb
# ---------------
#    nroff source
# ---------------
#
# REVIEW: add anchors menu for detected headings ?

Dir.glob("#{File.dirname(__FILE__)}/nroff/*.rb").each do |i|
  require i
end

module Nroff
  attr_reader :input_line_number

  def self.extended(k)
    k.instance_variable_set '@tab_width', 8
    k.instance_variable_set '@lines_per_page', 66
    k.instance_variable_set '@related_info_heading', 'SEE ALSO'

    # watch for alphabetic text starting in first column, which would be a title or section head
    k.instance_variable_set '@heading_detection', %r{^(?<section>[A-Z][A-Za-z\s]+)$}
    #k.instance_variable_set '@title_detection', %r{^((\S+?)\(((\S+?)(-\S+)*)\))}		# TODO supposedly this doesn't always match correctly. rrestore.ffs(1) [RISC/os 4.52]
    k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}		# REVIEW now what?
    k.instance_variable_set '@summary_heading', %r{^NAME$}  # REVIEW works for UNIX manual entries.

    k.instance_variable_set '@input_line_number', 0
  end

  def source_init
    parse_title
  end

  def to_html
    alt_typebox_shift  = false
    escape_shift       = false
    platen_position    = 1      # top of page, with room for one backward half-linefeed
    printhead_position = 0      # leftmost column
    section            = ''

    loop do
      input_line = @lines.next
      @input_line_number += 1

      plaintext = unformat(input_line.chomp)
      #@summary << plaintext.strip if section =~ (@summary_heading) # REVIEW too simple? - yes. unix style find NAME section & use text from following lines; aegis style no section to detect, use first line to match pattern directly
      section = plaintext.match(@heading_detection) { |head| head[:section] } || section unless input_line == @title_line

      input_line.each_char do |char|

        page = @lines_per_page ? platen_position / (2 * @lines_per_page) : 0
        @document[page] ||= Block::Nroff.new(text: [])

        line = (platen_position - 2 * (@lines_per_page || 0) * page) / 2
        @document[page].text[line] ||= Line.new(source: @input_filename)

        text = @document[page].text[line]
        text.section = section
        # bit lame to do this every character, but this is where the Line is
        # TODO incorrectly detecting links in title line - chgrp(1) [UTek W2.3]
        if section == @related_info_heading and !text.links
          text.links = detect_links(plaintext)
        end

        platen_position % 2 == 0 ? text.up! : text.down!

        # REVIEW I wonder if these control characters ought to be programmable
        #        not if col(1) is involved - VT(\013), SI (\016), SO (\017), and ESC-7, 8, and 9 only
        #   TODO but Aegis makes use of its own escape sequences for pad font selection;
        #        and presumably we'll have to deal with color codes in VM/ESA online help?
        # TODO support VT as alternate form of full reverse linefeed
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
            warn "processing unknown control character #{char.inspect}" if char.bytes.detect { |b| b<32 }
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

  private

  def unformat(line)
    # kill carriage control, underlining (where _ is printed first),
    # bold and other character overstrike effects, and line-at-a-time overstrike effects
    # assumes normal text printed first in line-at-a-time overstrike, which may not be true (DG/UX 4.30)
    # REVIEW might need to be done one at a time, in sequence, to be properly effective.
    # TODO make this return sensible english text no matter the order overstrikes occur
    line.gsub(%r((\e.|_\cH|\cH.|\cM.*)), '')
    rescue ArgumentError => e
      if e.message.match?(/invalid byte sequence/)
        warn "#{e.message} parsing #{line.inspect}"
      else
        raise
      end
  end

  def detect_links(line)
    # make sure we break detection on space or punctuation, in order to correctly
    # detect around missing whitespace ("dlty(1),lty(1)" - inty(1) [Domain/OS SR10.4 BSD])
    line.scan(/(?<=[\s,.;])((\S+?)\((\d.*?)\))/).map do |text, ref, section|
      [text, "../man#{section.downcase}/#{ref}.html"]
    end.to_h
  end

  def get_title
    loop do
      @title_line = @lines.next
      plaintext = unformat(@title_line)
      break if plaintext.match(@title_detection)
    end
    Regexp.last_match
  ensure
    @lines.rewind
  end

  def parse_title
    title = get_title or warn "reached end of document without finding title!"
    @manual_section   = title&.[](:section)&.downcase
    @output_directory = "man#{@manual_section}" if @manual_section
    title
  end
end
