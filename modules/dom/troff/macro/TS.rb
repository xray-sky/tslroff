# TS.rb
# -------------
#   troff
# -------------
#
#   Starts table (tbl) processing
#
# this is some hairy ish.
#

module Troff
  def req_TS(*args)
    cell_delim = "\t"

    tbl = blockproto(:table)
    tbl.text = Array.new
    @document << tbl

    # REVIEW: probably this is better as a totally generic reusable utility routine?
    partial = Proc.new { |str|
      # divert the width; don't let it get into the output stream.
      hold_block = @current_block
      @current_block = Block.new(type: :bare)
      unescape("\\w'#{str}'")
      w = to_u(@current_block.text.pop.text.strip).to_i
      @current_block = hold_block
      w
    }

    # You may specify a single line of options to affect the layout of the whole
    # table. These must be placed immediately after the .TS line. On this line, you
    # must separate options with spaces, tabs, or commas. You must end the options
    # line with a semicolon. All allowable options appear below.

    options_separator  = Regexp.new('(?:,\s*|\s+)')
    options_terminator = Regexp.new(';\s*$')

    if @lines.peek.match(options_terminator)
      @lines.tap { @register['.c'].value += 1 }.next.sub(options_terminator, '').split(options_separator).each do |option|
        case option
        when 'center'    then tbl.style.css[:margin] = 'auto'
        when 'expand'    then tbl.style.css[:width]  = '100%' # REVIEW: this was 85% in old version
        when 'box'       then tbl.style.css[:border] = '1px solid black'
        when 'doublebox' then tbl.style.css[:border] = '3px double black'
        when 'allbox'    then tbl.style.css[:border_collapse] = 'collapse' and tbl.style[:allbox] = true
        when /^tab\s*\((.)\)/   then cell_delim = Regexp.last_match(1)
        #when /^delim\s*\((..)\)/     then # TODO: -- recognizes . and . as eqn delimiters
        #when /^linesize\s*\((\d+)\)/ then # TODO: -- sets lines or rules in n point type
        else warn "unimplemented tbl global #{option.inspect}"
        end
      end
    end

    # the format section is mandatory
    req_TAmp

    # initialize numeric alignment data before block gets frozen
    tbl[:nalign] = Array.new(@state[:tbl_formats].columns) { Array.new(2,0) }

    # check to see if the first input line contains only whitespace and _ or =;
    # input lines like this aren't table rows, but cause cell borders to be drawn.
    # depending on whitespace, they may apply to individual cells or to entire rows.
    #
    # special case first line as top borders -- all subsequent rule lines handled as bottom borders

    if @lines.peek.chop.match(/^([\s_=]+)$/)
      line = Regexp.last_match(0)
      if line.match(/^([_=])/)
        top_borders = Array.new(@state[:tbl_formats].columns, Regexp.last_match(1))
      else
        top_borders = Array.new(@state[:tbl_formats].columns)
        line.split(cell_delim).each_with_index do |fmt, column|
          top_borders[column] = fmt if fmt.match(/[_=]/)
        end
      end
      @lines.tap { @register['.c'].value += 1 }.next
    end

    #row = 0
    rowspan_active = Array.new(@state[:tbl_formats].columns, nil)
    rowspan_hold   = Array.new(@state[:tbl_formats].columns, nil)

    # table data. terminated by .TE macro
    while @document.last.type == :table do

      line = @lines.tap { @register['.c'].value += 1 } .next.chomp

      # includes a text block?
      if line.sub!(/T{$/, '')
        additional = @lines.collect_through do |l|
                       @register['.c'].value += 1
                       l.start_with?('T}')
                     end
        additional[-1].sub!(/^T}/, '')
        line << additional.join		# TODO wrong, because the lines may contain requests! - boot(8) [GL2-W2.5]
      end

      # skip row processing if this is a request line
      if Troff.req?(line)
        parse(line)
        break if @current_block.type == :p     # encountered .TE
        next
      end

      # row data
      current_row = Block.new(type: :row, text: format_row)
      cells = line.split(cell_delim)

      # check for bottom borders:
      # row span control characters (\^) also allowed to appear
      #
      # if .TE is the last line of the file, we'll get a StopIteration from peek
      # and it won't actually get processed.
      begin
        if @lines.peek.chop.match(/^(\s|\\\^|_|=)+$/)	# TODO: allow changed field separator
          line = Regexp.last_match(0)
          if line.match(/^([_=])$/)
            current_row.text.each do |cell|
              cell.style.css[:border_bottom] = case Regexp.last_match(1)
                                               when '_' then '1px solid black'
                                               when '=' then '3px double black'
                                               end
            end
          else
            line.split(cell_delim).each_with_index do |fmt, column|
              current_row.text[column].style.css[:border_bottom] = case Regexp.last_match(1)
                                                                   when '_' then '1px solid black'
                                                                   when '=' then '3px double black'
                                                                   end if fmt.match(/([_=])/)
            end
          end
          # if there's rowspan characters in the text, there'll be a line for this row in formats. skip it.
          @state[:tbl_formats].next_row if line.match(/\\\^/)
          @lines.tap { @register['.c'].value += 1 }.next
        end
      rescue StopIteration => e
        # ignore it.
      end

      current_row.text.each_with_index do |cell, column|
        break if cell.type == :row_adj # past the normal cells and into :row_adj

        @current_block = cell
        text = cells.shift

        # fudge the contents of this cell to ensure the row doesn't get collapsed
        @current_block << LineBreak.new and text='' if cell.style[:box_rule]

        # handle cells that've been spanned downward
        # move bottom_border lines in the text; spanned cells have to be tabbed past
        if (text and text.sub!(/^\\\^$/, '')) or cell.type == :nil
          rowspan_active[column] ||= true
          rowspan_hold[column] ||= tbl.text.last.text[column] # this is why there's a special Block type :row_adj for box rules, rather than inserting those rows directly
          # the spans are already known if they were done in the formats
          # if they are in the text, they need to be figured out
          rowspan_hold[column].style.attributes[:rowspan] ? rowspan_hold[column].style.attributes[:rowspan] += 1 : rowspan_hold[column].style.attributes[:rowspan] = 2 unless cell.type == :nil
          rowspan_hold[column].style.css[:vertical_align] = 'middle'
          # propagate styles up, too. so far, border_bottom is the only one that's been set
          # top borders & allbox will have already been set on whatever cell it's being spanned to
          rowspan_hold[column].style.css[:border_bottom] = @current_block.style.css[:border_bottom] if @current_block.style.css[:border_bottom]
          # suppress this cell from being output; whatever else happens to it is immaterial
          # but it needs to remain in the tbl to keep the other columns correct
          @current_block.type = :nil
        end

        # looks like row-spanned cells still exist, and need to be tabbed past.
        # but there won't be a format for them, because all the spans were merged left.
        (cell.style.attributes[:colspan] - 1).times { cells.shift } if cell.style.attributes[:colspan]

        # was there a top border to apply here? do it, but only once
        # TODO: refactor this
        if top_borders
          case top_borders[column]
          when '_' then @current_block.style.css[:border_top] = '1px solid black'
          when '=' then @current_block.style.css[:border_top] = '3px double black'
          end
        end

        @current_block.style.css[:border] = '1px solid black' if tbl.style[:allbox]

        # REVIEW: there is a fundamental conflict between the _ that draws a rule (which
        # must appear as a cell - stbl1) and a row with one column's worth of text that's
        # spanned to the end of the row (which must not appear as cells - stbl3)

        unless text.nil?
          unescape(text)

          if @current_block.style[:numeric_align]

            # prefer to align on \& (has been parsed to &zwj;) -- this gets removed if present
            # otherwise align on rightmost dot adjacent to a number (REVIEW: not clear if this counts either side; assume just right-hand-side for now)
            # if full-numeric and no dot, align least significant digit.

            @current_block.style[:numeric_align][:left]  = Proc.new { to_em(tbl[:nalign][column][0].to_s + 'u') }
            @current_block.style[:numeric_align][:right] = Proc.new { to_em(tbl[:nalign][column][1].to_s + 'u') }

            (left, right) = case @current_block.text.last.text.strip
                            when /^(.*)&zwj;(.*)$/ then   Regexp.last_match[1,2]
                            when /^(.*)(\.\d+)$/   then   Regexp.last_match[1,2]   # REVIEW: "the rightmost dot adjacent to a digit"
                            when /^(\d+)$/         then [ Regexp.last_match[1], '' ]
                            else                        [ text, :noalign ]
                            end

            unless left.empty?
              w = partial.call(left)
              tbl[:nalign][column][0] = w if w > tbl[:nalign][column][0]
            end

            unless right.empty? || right == :noalign
              w = partial.call(right)
              tbl[:nalign][column][1] = w if w > tbl[:nalign][column][1]
            end

            if right == :noalign
              @current_block.text.last.text = "&tblctl_ctr;#{left}&roffctl_endspan;"
            else
              @current_block.text.last.text = "&tblctl_nl;#{left}&roffctl_endspan;&tblctl_nr;#{right}&roffctl_endspan;"
            end

          end
          rowspan_hold[column] = nil unless rowspan_active[column]
        end
        rowspan_active[column] = nil
      end
      top_borders = nil  # suppress this, after the first row. TODO: still needed?
      tbl.text << current_row if @current_block.type == :cell and !current_row.empty?
    end
  end

end
