# TS.rb
# -------------
#   troff
# -------------
#
#   Starts table (tbl) processing
#
# this is some hairy ish.
#

EndOfTable = Class.new(RuntimeError)

module Troff
  def req_TS(*args)
    warn "processing tbl -"
    resc = Regexp.quote @state[:escape_char]
    @state[:tbl_cell_delim] = "\t"
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

    # save the current font and size registers somewhere; these will be the table defaults
    # chrtbl(1) [SunOS 5.5.1]
    @register[:tbl_dfont] = @register['.f'].dup
    @register[:tbl_dsize] = @register['.s'].dup

    # tbl should respect current indent and doesn't automatically get paragraph spacing. apparently.
    # we have to add the css base margin, since we use padding to get a page margin for other blocks,
    # but table padding goes _inside_ the border.
    #
    # <table> is 4em currently, based on <p> 2em + 2em padding - change this if the css changes.
    tbl.style.css[:margin_left] = "#{to_em(@register['.i'].to_s + '+2m')}em"
    tbl.style.css.delete(:margin_left) if @register['.i'] == (@state[:base_indent] + to_u('2m').to_f)

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
        when 'center'    then tbl.style.css[:margin] = 'auto'
        when 'expand'    then tbl.style.css[:width]  = '100%' # REVIEW: this was 85% in old version
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
    req_TAmp

    # initialize numeric alignment data before block gets frozen
    tbl[:nalign] = Array.new(@state[:tbl_formats].columns) { Array.new(2,0) }

    #row = 0
    rowspan_active = Array.new(@state[:tbl_formats].columns, nil)
    rowspan_hold   = Array.new(@state[:tbl_formats].columns, nil)

    # table data. terminated by .TE macro
    loop do

      line = next_line_tbl

      # apply held rules to either the bottom of the last row, or the top of the next

      if @state[:tbl_bottom_rules]
        tbl.text.last.text.each_with_index do |cell, column|
          cell.style.css[:border_bottom] = case @state[:tbl_bottom_rules][column] || @state[:tbl_bottom_rules][0]
                                           when ''  then next
                                           when '_', "\\_" then '1px solid black'
                                           when '=', "\\=" then '3px double black'
                                           when "\\^"
                                             # eh?
                                             warn "spanning column #{column} up"
                                             rowspan_active[column] ||= true
                                             rowspan_hold[column] ||= tbl.text.last.text[column] # this is why there's a special Block type :row_adj for box rules, rather than inserting those rows directly
                                             rowspan_hold[column].style.attributes[:rowspan] ? rowspan_hold[column].style.attributes[:rowspan] += 1 : rowspan_hold[column].style.attributes[:rowspan] = 2 unless cell.type == :nil
                                             rowspan_hold[column].style.css[:vertical_align] = 'middle'
                                             cell.type = :nil
                                             next
                                           else warn "applying invalid rule from #{@state[:tbl_bottom_rules].inspect}"
                                           end
        end
        @state[:tbl_bottom_rules] = nil
      end


      current_row = Block.new(type: :row, text: format_row)


      if @state[:tbl_top_rules]
        current_row.text.each_with_index do |cell, column|
          cell.style.css[:border_top] = case @state[:tbl_top_rules][column] || @state[:tbl_top_rules][0]
                                        when ''  then next
                                        when '_', "\\_" then '1px solid black'
                                        when '=', "\\=" then '3px double black'
                                        when "\\^"
                                          # eh?
                                          rowspan_active[column] ||= true
                                          rowspan_hold[column] ||= tbl.text.last.text[column] # this is why there's a special Block type :row_adj for box rules, rather than inserting those rows directly
                                          rowspan_hold[column].style.attributes[:rowspan] ? rowspan_hold[column].style.attributes[:rowspan] += 1 : rowspan_hold[column].style.attributes[:rowspan] = 2 unless cell.type == :nil
                                          rowspan_hold[column].style.css[:vertical_align] = 'middle'
                                          cell.type = :nil
                                          next
                                        else warn "applying invalid rule from #{@state[:tbl_top_rules].inspect}"
                                        end
        end
        @state[:tbl_top_rules] = nil
      end

      # row data
      cells = line.split(@state[:tbl_cell_delim]) # we will get [] if we have input a blank line (see history(1) note, below)
      current_row.text.each_with_index do |cell, column|
        break if cell.type == :row_adj # past the normal cells and into :row_adj

        @current_block = cell
        text = cells.shift # TODO we will get nil if we have input a blank line (see history(1) note, below)

        # we need to set the font registers based on the cell's format, because otherwise
        # :last_xx is going to be whatever happened in format_row for the rightmost cell
        # REVIEW in trouble here if the standard font positions get rearranged
        @register['.s'].value = cell.text.last.font.size # TODO this is where size is being reset between cells for sysconf(3c) [SunOS 5.5.1] :: [125]
                                                         # -- what can be done?? perhaps just a rewrite. but then how to detect it's happened on other pages?
        @register['.f'].value = case cell.text.last.font.face
                                when :sans then 5
                                when :boldit then 4
                                when :bold then 3
                                when :italic then 2
                                when :regular then 1
                                else warn "trouble setting \\n(.f based on table cell style #{cell.text.last.font.face.inspect}"
                                end

        # fudge the contents of this cell to ensure the row doesn't get collapsed
        @current_block << LineBreak.new and text='' if cell.style[:box_rule] or text.nil?#.tap { |n| warn "tbl empty cell" if n }

        # handle cells that've been spanned downward
        # move bottom_border lines in the text; spanned cells have to be tabbed past

        if (text and text.sub!(/^\\\^$/, '')) or cell.type == :nil
          rowspan_active[column] ||= true
          rowspan_hold[column] ||= tbl.text.last.text[column] # this is why there's a special Block type :row_adj for box rules, rather than inserting those rows directly

          # the spans are already known if they were done in the formats
          # if they are in the text, they need to be figured out
          rowspan_hold[column].style.attributes[:rowspan] ? rowspan_hold[column].style.attributes[:rowspan] += 1 : rowspan_hold[column].style.attributes[:rowspan] = 2 unless cell.type == :nil
          rowspan_hold[column].style.css[:vertical_align] = 'middle'

          # suppress this cell from being output; whatever else happens to it is immaterial
          # but it needs to remain in the tbl to keep the other columns correct
          @current_block.type = :nil
        end

        # looks like row-spanned cells still exist, and need to be tabbed past.
        # we did something to how the cells come back from format_row, so row-spanned
        # cells no longer exist once we get this far.

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
              parse(text) # REVIEW is this going to put us in trouble with @current_block? - yes. but, seems ok so far? 20220722
            end
            cells = (text.split(@state[:tbl_cell_delim])[1..-1] || []).tap {|n| warn "replacing cells #{cells.inspect} after blockmode with #{n.inspect}" }
          else
            unescape(text)
          end

          if @current_block.style[:numeric_align]

            # prefer to align on \& (has been parsed to &zwj;) -- this gets removed if present
            # otherwise align on rightmost dot adjacent to a number
            # (REVIEW not clear if this counts either side; assume just right-hand-side for now)
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
      tbl.text << current_row
    end
  rescue EndOfTable => e
    # encountered .TE with held box rules. apply them as bottom borders on the last table row.
    if @state[:tbl_top_rules]
      tbl.text.last.text.each_with_index do |cell, column|
        cell.style.css[:border_bottom] = case @state[:tbl_top_rules][column] || @state[:tbl_top_rules][0]
                                         when ''  then next
                                         when '_' then '1px solid black'
                                         when '=' then '3px double black'
                                         # REVIEW no code path here for \^ -- does it matter?
                                         else warn "applying invalid rule from #{@state[:tbl_bottom_rules]}"
                                         end
      end
      @state[:tbl_top_rules] = nil
    end

    @current_block = blockproto
    # restore fonts from before .TS, unlike other macros
    unescape("#{@state[:escape_char]}f#{@register[:tbl_dfont]}#{@state[:escape_char]}s#{@register[:tbl_dsize]}")
    @register.delete(:tbl_dfont)
    @register.delete(:tbl_dsize)
    @document << @current_block
  end

  def next_line_tbl
    resc = Regexp.escape @state[:escape_char]
    line = next_line

    # we can have gotten one of three things:
    #
    # 1. a request. NOTE: ' does not cause a request during tbl processing.
    # 2. a line specifying top/bottom borders, possibly also including row span indicators.
    # 3. "normal" cell text, separated by @cell_delim, possibly
    #
    # this method tries to deal with 1 and 2, so the regular method can deal simply with
    # formatting cells.

    case line
    when /^\s*$/ then '' # treat a line of all whitespace same as an empty line.
    when /^.\s*T&/       # special case for format change.
      parse line
      @state[:tbl_bottom_rules] = @state[:tbl_top_rules].dup
      @state[:tbl_top_rules] = nil
      next_line_tbl
    when /^\./           # is a request. process it. do over.
      parse line
      next_line_tbl
    when /^(\s*#{resc}?\^|\s*#{resc}?_|\s*=)+$/   # TODO allow changed field separator - prtdiag(1m) [SunOS 5.5.1] has \_ \_ \_ that is accepted
      rules = Regexp.last_match(0)#.tap { |n| warn "format/bottom border change line #{n.inspect}" }
      @state[:tbl_top_rules] = rules.split(@state[:tbl_cell_delim])
      @state[:tbl_formats].next_row if @state[:tbl_top_rules].length > 1 # ditch the format given for this row... _if it has tabs_
      next_line_tbl
    else
      line
    end
  end
end
