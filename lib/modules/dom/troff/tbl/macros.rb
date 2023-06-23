# .TS
#
#   Starts table (tbl) processing
#
# TODO
#   bail somehow if we have a .TE with table already processed through tbl (NEWS-os, AOS)
#

class EndOfTbl < RuntimeError ; end

module Troff
  define_method 'T&' do |*args|
    formats_terminator = Regexp.new('\.\s*$')
    format_lines = []
    loop do
      break if @line.match?(formats_terminator)
      format_lines << next_line
    end
    @state[:tbl_formats] = Tbl.formats(format_lines)
  end

  define_method 'TE' do |*_args|
    raise EndOfTbl
  end

  define_method 'TS' do |*args|
    warn "processing tbl -"
    resc = Regexp.quote @state[:escape_char]
    @state[:tbl_cell_delim] = "\t"
    tbl = blockproto(Block::Table)
    tbl.text = Array.new
    @document << tbl

    # REVIEW: probably this is better as a totally generic reusable utility routine?
    partial = Proc.new { |str|
      # divert the width; don't let it get into the output stream.
      blk = Block::Bare.new
      # gets jacked if there are single quotes in str
      #unescape("\\w'#{str}'")
      unescape "#{@state[:escape_char]}w\x00#{str}\x00", output: blk
      to_u(blk.text.pop.text.strip).to_i
    }

    # save the current font and size registers somewhere; these will be the table defaults
    # chrtbl(1) [SunOS 5.5.1]
    @register[:tbl_dfont] = @register['.f'].dup
    @register[:tbl_dsize] = @register['.s'].dup

    # tbl should respect current indent and doesn't automatically get paragraph spacing. apparently.
    # we have to add the css base margin, since we use padding to get a page margin for other blocks,
    # but table padding goes _inside_ the border.
    #
    # <table> is 4em currently, based on <p> 2em + 2em padding - change this if the css changes.
    tbl.style.css[:margin_left] = "#{to_em(to_u(@register['.i'].to_s + '+2m'))}em" unless @register['.i'] == @state[:base_indent]

    # a lot of the tables in e.g. SunOS 5 manuals are text layout - no borders
    # fudge the style to get leftmost column text margins to line up
    # this class will be cleared if any cell on the leftmost column has a visible left border
    tbl.style.attributes[:class] = 'flushleft'

    # You may specify a single line of options to affect the layout of the whole
    # table. These must be placed immediately after the .TS line. On this line, you
    # must separate options with spaces, tabs, or commas. You must end the options
    # line with a semicolon. All allowable options appear below.

    options_separator  = Regexp.new('(?:,\s*|\s+)')
    options_terminator = Regexp.new(';\s*$')

    if @lines.peek.match(options_terminator)	# some of these options may take parameters that could be separated by whitespace - like tab()
      next_line.gsub(/(tab)\s+\(/, "\\1(").sub(options_terminator, '').split(options_separator).each do |option|
        case option
        when 'center'    then tbl.style.css[:margin] = 'auto' # REVIEW this causes wide tables to take the entire width of #man - lex(1) [SunOS 5.5.1]
        when 'expand'    then warn "tbl global 'expand'" ; tbl.style.css[:width]  = '85%' # REVIEW this was 85% in old version, then I had it at 100% for a while; some HPUX tables go the entire width of #man, so I put it back to 85%.
        when 'box'       then tbl.style.css[:border] = '1px solid black' and tbl.style.attributes.delete(:class)
        when 'doublebox' then tbl.style.css[:border] = '3px double black' and tbl.style.attributes.delete(:class)
        when 'allbox'    then tbl.style.css[:border_collapse] = 'collapse' and tbl.style[:allbox] = true and tbl.style.attributes.delete(:class)
        when /^tab\((.)\)/   then @state[:tbl_cell_delim] = Regexp.last_match(1)	# TODO not going to see this if there's a space between, because it's been split already
        #when /^delim\s*\((..)\)/     then # TODO: -- recognizes . and . as eqn delimiters
        #when /^linesize\s*\((\d+)\)/ then # TODO: -- sets lines or rules in n point type
        else warn "unimplemented tbl global #{option.inspect}"
        end
      end
    end

    # the format section is mandatory
    send 'T&'

    # initialize numeric alignment and data before block gets frozen
    tbl[:nalign] = Array.new(@state[:tbl_formats].columns) { Array.new(2,0) }

    # initialize array to track column spacing (default, 3n)
    @state[:tbl_colspc] = Array.new(@state[:tbl_formats].columns, nil)

    resc = Regexp.quote @state[:escape_char]

    # table data. terminated by .TE macro
    loop do

      line = next_line_tbl

      # apply held rules to either the bottom of the last row, or the top of the next
      if @state[:tbl_bottom_rules]
        tbl.terminal_string.each_with_index do |cell, column|
          cell.style.css[:border_bottom] = case @state[:tbl_bottom_rules][column] || @state[:tbl_bottom_rules][0]
                                           when '', "\\^"  then next # bottom border. no upward row spanning involved.
                                           when '_', "\\_" then '1px solid black'
                                           when '=', "\\=" then '3px double black'
                                           else warn "applying invalid rule from #{@state[:tbl_bottom_rules].inspect}"
                                           end
        end
        @state.delete(:tbl_bottom_rules)
      end

      # format the new row
      current_row = format_row

      if @state[:tbl_top_rules]
        current_row.text.each_with_index do |cell, column|
          cell.style.css[:border_top] = case @state[:tbl_top_rules][column] || @state[:tbl_top_rules][0]
                                        when ''  then next
                                        when '_', "\\_" then '1px solid black'
                                        when '=', "\\=" then '3px double black'
                                        else warn "applying invalid rule from #{@state[:tbl_top_rules].inspect}"
                                        end
        end
        @state.delete(:tbl_top_rules)
      end

      # row data
      #cells = line.split(@state[:tbl_cell_delim]) # we will get [] if we have input a blank line (see history(1) note, below)
      # delims can be hidden by preceeding them with an escape char
      cells = line.split(/(?<!(?<!#{resc})#{resc})#{@state[:tbl_cell_delim]}/) # we will get [] if we have input a blank line (see history(1) note, below)
      current_row.text.each_with_index do |cell, column|

        if cell.is_a? Block::ColSpan
          cell.parent = current_row.text[column-1]
          next
        end

        @current_block = cell
        text = cells.shift # TODO we will get nil if we have input a blank line (see history(1) note, below)

        # we need to set the font registers based on the cell's format, because otherwise
        # :last_xx is going to be whatever happened in format_row for the rightmost cell
        @register['.f'].value = @state[:fonts].invert[cell.terminal_font.face] || 0.tap { warn "trouble setting \\n(.f based on table cell style #{cell.terminal_font.face.inspect} -- falling back to position 0" }
        @register['.s'].value = cell.terminal_font.size # TODO this is where size is being reset between cells for sysconf(3c) [SunOS 5.5.1] :: [125]
                                                         # -- what can be done?? perhaps just a rewrite. but then how to detect it's happened on other pages?


        # fudge the contents of this cell to ensure the row doesn't get collapsed
        @current_block << LineBreak.new and text='' if cell.style[:box_rule] or text.nil?

        # handle cells that've been spanned downward
        # move bottom_border lines in the text; spanned cells have to be tabbed past
        if (text and text.sub!(/^\\\^$/, ''))
            cell = Block::RowSpan.new
            current_row.text[column] = cell # REVIEW will I need to somehow preserve styles from the old cell? borders? etc?
            @current_block = cell
          end

        if cell.is_a? Block::RowSpan
          cell.parent = tbl.terminal_string[column]
          cell.rowspan_inc
          cell.style.css[:vertical_align] = 'middle'
        end

        # REVIEW there is a fundamental conflict between the _ that draws a rule (which
        # must appear as a cell - stbl1) and a row with one column's worth of text that's
        # spanned to the end of the row (which must not appear as cells - stbl3)
        @current_block.style.css[:border] = '1px solid black' if tbl.style[:allbox]

        # remove the table flush-left class if any cell in the leftmost column
        # has a visible left border
        tbl.style.attributes.delete(:class) if (column.zero? and cell.style.css[:border_left])

        unless text.nil?
          if text.sub!(/T{$/, '')
            loop do
              text = next_line
              break if text.sub!(/^T}/, '')
              warn "tbl parsing #{text.inspect} in block context"
              parse(text) # REVIEW is this going to put us in trouble with @current_block? - yes.
              # we might get a request that dorks with @current_block (.ad)
              # followed by one which outputs to @current_block (.sp)
              # ...like in syncloop(1m) [SunOS 5.5.1] : 110-112
              # => restore @current_block to cell context
              @current_block = cell
            end
            cells = (text.split(@state[:tbl_cell_delim])[1..-1] || []).tap {|n| warn "replacing cells #{cells.inspect} after blockmode with #{n.inspect}" }
          else
            unescape(text) # TODO tbl adds \R (repeated character, to fill cell width). Watch for this; hopefully we don't need to implement it.
          end

          if @current_block.style[:numeric_align]

            # prefer to align on \& (has been parsed to &zwj;) -- this gets removed if present
            # otherwise align on rightmost dot adjacent to a number
            # (REVIEW not clear if this counts either side; assume just right-hand-side for now)
            # if full-numeric and no dot, align least significant digit.

            @current_block.style[:numeric_align][:left]  = Proc.new { to_em(tbl[:nalign][column][0].to_s + 'u') }
            @current_block.style[:numeric_align][:right] = Proc.new { to_em(tbl[:nalign][column][1].to_s + 'u') }

            (left, right) = case @current_block.terminal_string.strip
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
              # why was this assigning, instead of appending?
              @current_block.terminal_string = "&tblctl_ctr;#{left}"
              @current_block << EndSpan.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
            else
              # ditto?
              @current_block.terminal_string = "&tblctl_nl;#{left}"
              @current_block << EndSpan.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
              @current_block << "&tblctl_nr;#{right}"
              @current_block << EndSpan.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
            end

          end
        end
      end
      tbl.text << current_row
    end
  rescue EndOfTbl => e
    # encountered .TE with held box rules. apply them as bottom borders on the last table row.
    if @state[:tbl_top_rules]
      tbl.terminal_string.each_with_index do |cell, column|
        cell.style.css[:border_bottom] = case @state[:tbl_top_rules][column] || @state[:tbl_top_rules][0]
                                         when '', "\\^"  then next # bottom border. no upward row spanning involved.
                                         when '_' then '1px solid black'
                                         when '=' then '3px double black'
                                         else warn "applying invalid rule from #{@state[:tbl_top_rules]}"
                                         end
      end
      @state.delete(:tbl_top_rules)
    end

    # apply non-standard column spacing, if there was any
    if @state[:tbl_colspc].compact.any?
      tbl.text.each do |row|
        row.text.each_with_index do |cell, column|
          space = @state[:tbl_colspc][column]
          next unless space
          pad = to_em(to_u("#{space/2}", default_unit: 'n'))
          cell.style.css[:padding_right] = "#{pad}em"
          # some joker might've tried to set the column spacing on the rightmost
          # column. like in sysV-make(1) [SunOS 5.5.1]
          row.text[column+1].style.css[:padding_left] = "#{pad}em" if row.text[column+1]
        end
      end
    end

    @current_block = blockproto
    # restore fonts from before .TS, unlike other macros
    unescape("#{@state[:escape_char]}f#{@register[:tbl_dfont]}#{@state[:escape_char]}s#{@register[:tbl_dsize]}")
    @register.delete(:tbl_dfont)
    @register.delete(:tbl_dsize)
    @document << @current_block
  end
end
