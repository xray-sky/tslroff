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
    formats = Array.new

    tbl = Block.new(type: :table, style: @current_block.style.dup, text: Array.new)
    @blocks << @current_block
    @blocks << tbl
    
    # global formats first. if given, must be terminated by ;
    # REVIEW: is more than one line of globals allowed?
    # REVIEW: this lacks robustness

    globals_regex = Regexp.new('\s*;\s*$')
    if @lines.peek.match(globals_regex)
      @lines.next.sub(globals_regex, '').split.each do |g|    # REVIEW: tab() ?
        case g
        when 'center'    then tbl.style.css[:margin] = 'auto'
        when 'expand'    then tbl.style.css[:width]  = '100%' # REVIEW: this was 85% in old version
        when 'box'       then tbl.style.css[:border] = '1px solid black'
        when 'doublebox' then tbl.style.css[:border] = '3px double black'
        when 'allbox'    then tbl.style.css[:border_collapse] = 'collapse' and tbl.style[:allbox] = true
        when /^tab(.)/   then cell_delim = Regexp.last_match(1)
        else             warn "unimplemented tbl global #{g}"
        end
      end
    end

    # cell format specifications next. 
    # may occupy multiple rows, must be terminated by .
    #
    # we want to rearrange the span and border formats, to simplify applying
    # them to the relevant bit of markup:
    #
    #    s and | formats get merged left
    #    ^ formats get merged up
    
    row = 0
    loop do
      formats[row] = @lines.next.rstrip.gsub(/\s+([sS|])/, '\1').split

      while pos = formats[row].index{ |cell| cell.match(/\^/) } do
        # ^ formats in prior rows ought to result in an empty (but present) cell, 
        # as they will have already been merged up.
        # REVIEW: short format rows may cause NoMethodErrors? (nil.empty?)
        formats[row][pos].sub!(/\^/, '')
        srcrow = row - 1
        while formats[srcrow][pos].empty? do
          # keep going up, past emptied cells
          srcrow -= 1
        end
        formats[destrow][pos] += '^'
      end

      # last row of formats
      if formats[row].last == '.' 
        formats[row].pop
        break
      end

      row += 1
    end

    # table data. terminated by .TE macro
    row = 0
    while @blocks.last.type == :table do
      current_row = Block.new(type: :row, style: @current_block.style.dup, text: Array.new)

      # input lines like this aren't table rows, but cause cell borders to be drawn.
      if @lines.peek.match(/^([_=])$/)
        current_row.style[:row_border] = Regexp.last_match(1)
        @lines.next
      end

      @lines.next.split(cell_delim).each_with_index do |text, cell|
        # looks like row-spanned cells still exist, and need to be tabbed past.
        unless text.empty?          # REVIEW: probably this approach is going to fall down on something
          @current_block = Block.new(type: :cell)
          # if there is no explicit format for this row, the last given row of formats apply.
          row_format = formats.fetch(row, formats.last)
          # if there is no explicit format for this cell, the last given format on this row applies.
          row_format.fetch(cell, row_format.last).split(//).each do |fmt|
            case fmt
            #when /[Aa]/ then # TODO: "center longest line; left adjust remaining lines with respect to centered line" -- how to do this in HTML??
            when /[Bb]/ then @current_block.text.last.font.face = :bold
            when /[Cc]/ then @current_block.style.css[:text_align]   = 'center'
            when /[Ii]/ then @current_block.text.last.font.face = :italic
            when /[Ll]/ then @current_block.style.css[:text_align]   = 'left'
            #when /[Nn]/ # TODO: "numerically adjust - units positions are aligned vertically" -- can this even work in HTML??
            when /[Rr]/ then @current_block.style.css[:text_align]   = 'right'
            when /[Ss]/ then @current_block.style.attributes[:colspan] ? @current_block.style.attributes[:colspan] += 1 : @current_block.style.attributes[:colspan] = 2
            when '^'    then @current_block.style.attributes[:rowspan] ? @current_block.style.attributes[:rowspan] += 1 : @current_block.style.attributes[:rowspan] = 2
            when '|'    then @current_block.style.css[:border_right] = '1px solid black'
            else        warn "unimplemented tbl format #{fmt}"
            end
            case current_row.style[:row_border]
            when '_' then @current_block.style.css[:border_top] = '1px solid black'
            when '=' then @current_block.style.css[:border_top] = '3px double black'
            end
            @current_block.style.css[:border] = '1px solid black' if tbl.style[:allbox]
          end

          parse(text)
          current_row.text << @current_block
        end
      end
      tbl.text << current_row unless @blocks.last.type != :table # forget this "row" if it was a .TE macro
      row += 1
    end
  end
end