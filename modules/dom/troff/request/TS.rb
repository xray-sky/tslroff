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
  def req_TS(args)
    cell_delim = "\t"

    tbl = Block.new(type: :table, style: @current_block.style.dup, text: Array.new)
    @blocks << @current_block
    @blocks << tbl
    
    # You may specify a single line of options to affect the layout of the whole 
    # table. These must be placed immediately after the .TS line. On this line, you 
    # must separate options with spaces, tabs, or commas. You must end the options 
    # line with a semicolon. All allowable options appear below.

    options_separator  = Regexp.new('(?:,|\s+)')
    options_terminator = Regexp.new(';\s*$')

    if @lines.peek.match(options_terminator)
      @lines.next.sub(options_terminator, '').split(options_separator).each do |option|
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
    req_TAmp(nil)

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
      @lines.next
    end

    # table data. terminated by .TE macro
    while @blocks.last.type == :table do
      current_row = Block.new(type: :row, style: @current_block.style.dup, text: Array.new)
      #warn "#{@state[:tbl_formats].columns} // row format #{@state[:tbl_formats].get_row.inspect} for row"

      # row data
      cells = @lines.next.chomp.split(cell_delim)

      # check for bottom borders:
      # row span control characters (\^) also allowed to appear
      if @lines.peek.chop.match(/^(\s|\\\^|_|=)+$/)
        line = Regexp.last_match(0)
        if line.match(/^([_=])/)
          current_row.style[:bottom_borders] = Array.new(@state[:tbl_formats].columns, Regexp.last_match(1))
        else
          current_row.style[:bottom_borders] = Array.new(@state[:tbl_formats].columns)
          line.split(cell_delim).each_with_index do |fmt, column|
            current_row.style[:bottom_borders][column] = fmt if fmt.match(/[_=]/)
          end
        end
        @lines.next
      end

      next_row = Block.new(type: :row, style: current_row.style.dup, text: Array.new)
      while format = @state[:tbl_formats].get do
        text = cells.shift
        #if text and text.sub!('\^', '') # TODO: this is way too simple; we've already gone past the cell that needs this rowspan set.
        #end
        column = @state[:tbl_formats].column? 
        # looks like row-spanned cells still exist, and need to be tabbed past.
        @current_block = Block.new(type: :cell)
        warn "cell format #{@state[:tbl_formats].get.inspect} for cell: #{text}"
        format.split(//).each do |fmt|
          case fmt
          #when /[Aa]/ then # TODO: "center longest line; left adjust remaining lines with respect to centered line" -- how to do this in HTML??
          when /[Bb]/ then @current_block.text.last.font.face      = :bold
          when /[Cc]/ then @current_block.style.css[:text_align]   = 'center'
          when /[Ii]/ then @current_block.text.last.font.face      = :italic
          when /[Ll]/ then @current_block.style.css[:text_align]   = 'left'
          #when /[Nn]/ # TODO: "numerically adjust - units positions are aligned vertically" -- can this even work in HTML??
          when /[Rr]/ then @current_block.style.css[:text_align]   = 'right'
          when /[Ss]/
            @state[:tbl_formats].next_col
            @current_block.style.attributes[:colspan] ? @current_block.style.attributes[:colspan] += 1 : @current_block.style.attributes[:colspan] = 2
          when '^'
            @current_block.style.css[:vertical_align] = 'middle'
            @current_block.style.attributes[:rowspan] ? @current_block.style.attributes[:rowspan] += 1 : @current_block.style.attributes[:rowspan] = 2
          when '|'    then @current_block.style.css[:border_right] = '1px solid black'
          when '_'
            # there's no text to parse for this cell; it contains only a horizontal rule
            @current_block.style.css[:border_bottom] = '1px solid black'
            @current_block.style.css[:line_height] = '50%'
            next_row.style.css[:line_height] = "50%"
            next_row.text << Block.new(type: :cell, style: @current_block.style.dup)
            @state[:tbl_formats].box_extend?.each do |corner|
              # REVIEW: does this need to work with double-box?
              # TODO: border-collapse causes extra borders to be drawn (because the adjacent
              #       cell is full height), and otherwise it may not align (stbl1) 
              case corner
              when :nw then @current_block.style.css[:border_left] = '1px solid black'
              when :ne then @current_block.style.css[:border_right] = '1px solid black'
              when :sw then next_row.text.last.style.css[:border_left] = '1px solid black'
              when :se then next_row.text.last.style.css[:border_right] = '1px solid black'
              end
            end
            next_row.text.last << '&roffctl_br;'
            text=' '
            #warn "unimplemented rule extend #{@state[:tbl_formats].box_extend?.inspect}" 
          when /\s+/  then nil
          else        warn "unimplemented tbl format #{fmt}"
          end
        end

        # was there a top border to apply here? do it, but only once
        if top_borders
          case top_borders[column]
          when '_' then @current_block.style.css[:border_top] = '1px solid black'
          when '=' then @current_block.style.css[:border_top] = '3px double black'
          end
        end

        # were there any other borders to apply here?
        if current_row.style[:bottom_borders]
          case current_row.style[:bottom_borders][column]
          when '_' then @current_block.style.css[:border_bottom] = '1px solid black'
          when '=' then @current_block.style.css[:border_bottom] = '3px double black'
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
        else
          # even if it starts with a . this was from the middle of a line and is not a request
          parse(text.sub(/^([.'])/, "\\\\\\1")) unless text.nil?
        end
        current_row.text << @current_block
        @state[:tbl_formats].next_col
      end
      top_borders = nil  # suppress this, after the first row.
      #warn "appending row #{current_row.inspect}"
      tbl.text << current_row if @current_block.type == :cell
      warn next_row.inspect
      tbl.text << next_row #sunless next_row.text.empty?
      @state[:tbl_formats].next_row
      warn "===="
      #warn @blocks.last.text.inspect
    end
  end

end