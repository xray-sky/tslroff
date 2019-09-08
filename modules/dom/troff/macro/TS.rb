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

    tbl = Block.new(type: :table, style: @current_block.style.dup, text: Array.new)
    @document << @current_block
    @document << tbl

    # You may specify a single line of options to affect the layout of the whole
    # table. These must be placed immediately after the .TS line. On this line, you
    # must separate options with spaces, tabs, or commas. You must end the options
    # line with a semicolon. All allowable options appear below.

    options_separator  = Regexp.new('(?:,|\s+)')
    options_terminator = Regexp.new(';\s*$')

    if @lines.peek.match(options_terminator)
      @lines.tap { @state[:register]['.c'].value += 1 }.next.sub(options_terminator, '').split(options_separator).each do |option|
        case option
        when 'center'    then tbl.style.css[:margin] = 'auto'
        when 'expand'    then tbl.style.css[:width]  = '100%' # REVIEW: this was 85% in old version
        when 'box'       then tbl.style.css[:border] = '1px solid black'
        when 'doublebox' then tbl.style.css[:border] = '3px double black'
        when 'allbox'    then tbl.style.css[:border_collapse] = 'collapse' and tbl.style[:allbox] = true
        when /^tab\s*\((.)\)/   then cell_delim = Regexp.last_match(1)
        #when /^delim\s*\((..)\)/     then # TODO: -- recognizes . and . as eqn delimiters
        #when /^linesize\s*\((\d+)\)/ then # TODO: -- sets lines or rules in n point type
        else warn "unimplemented tbl global #{option}"
        end
      end
    end

    # the format section is mandatory
    req_TAmp

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
      @lines.tap { @state[:register]['.c'].value += 1 }.next
    end

    #row = 0
    rowspan_active = Array.new(@state[:tbl_formats].columns, nil)
    rowspan_hold   = Array.new(@state[:tbl_formats].columns, nil)

    # table data. terminated by .TE macro
    while @document.last.type == :table do
      current_row = Block.new(type: :row, style: @current_block.style.dup, text: format_row)

      # row data
      cells = @lines.tap { @state[:register]['.c'].value += 1 }.next.chomp.split(cell_delim)

      # check for bottom borders:
      # row span control characters (\^) also allowed to appear
      #
      # if .TE is the last line of the file, we'll get a StopIteration from peek
      # and it won't actually get processed.
      begin
        if @lines.peek.chop.match(/^(\s|\\\^|_|=)+$/)
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
          # there'll be a format line for this guy. skip it.
          @state[:tbl_formats].next_row
          @lines.tap { @state[:register]['.c'].value += 1 }.next
        end
      rescue StopIteration => e
        # ignore it.
      end

      current_row.text.each_with_index do |cell, column|
        break if cell.type != :cell # past the normal cells and into :row_adj
        @current_block = cell
        text = cells.shift

        # fudge input text for box rule cells, so a <br> is output and they render
        text = ' ' if cell.style[:box_rule]

        # handle cells that've been spanned downward
        if text and text.sub!(/^\\\^$/, '')
          rowspan_active[column] ||= true
          rowspan_hold[column] ||= tbl.text.last.text[column] # this is why there's a special Block type :row_adj for box rules, rather than inserting those rows directly
          rowspan_hold[column].style.attributes[:rowspan] ? rowspan_hold[column].style.attributes[:rowspan] += 1 : rowspan_hold[column].style.attributes[:rowspan] = 2
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

        if column.zero?
          parse(text)
          # REVIEW: is this sufficient to suppress a non-printing request line?
          break if @current_block.text.empty? and cells[1].nil?
          rowspan_hold[column] = nil unless rowspan_active[column]
        else
          # even if it starts with a . this was from the middle of a line and is not a request
          unless text.nil?
            parse(text.sub(/^([.'])/, "\\\\\\1"))
            # TODO: refactor - there won't be numeric alignment in column zero!
            if @current_block.style[:numeric_align]
              # prefer to align on \& (has been parsed to &zwj;) -- this gets removed if present
              # otherwise align on rightmost dot adjacent to a number (REVIEW: not clear if this counts either side; assume just right-hand-side for now)
              # if full-numeric and no dot, align least significant digit.
              # TODO: this doesn't quite cause column widths to expand as one would expect,
              #       when given items that align too far off-center. but it's a reasonable approximation for now
              #       right-hand-side can be forced to expand with &nbsp; but it's not necessarily one-to-one with lhs chars
              unless @current_block.text.last.text.sub!(/^(.*)&zwj;(.*)$/, '&roffctl_tbl_nl;\1&roffctl_endspan;&roffctl_tbl_nr;\2&roffctl_endspan;')
                @current_block.text.last.text.sub!(/^(\d+)\s*$/, '&roffctl_tbl_nl;\1&roffctl_endspan;&roffctl_tbl_nr;&nbsp;&roffctl_endspan;')
                @current_block.text.last.text.sub!(/^(.*)(\.\d.*)$/, '&roffctl_tbl_nl;\1&roffctl_endspan;&roffctl_tbl_nr;\2&roffctl_endspan;')
              end
            end
            rowspan_hold[column] = nil unless rowspan_active[column]
          end
        end
        rowspan_active[column] = nil
      end
      top_borders = nil  # suppress this, after the first row. TODO: still needed?
      tbl.text << current_row if @current_block.type == :cell and !current_row.empty?
    end
  end

end
