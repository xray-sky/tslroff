module Tbl

  # The format section specifies the layout of the columns. Each line in the format
  # section corresponds to one line of table data except the last format line,
  # which corresponds to all following data lines up to any additional .T& command
  # line. Each format line contains a key letter for each column of the table.
  #
  # In the format section, you may separate key letters with spaces or tabs to
  # improve readability, but spaces or tabs are not necessary. A dot (.) indicates
  # the end of key letters and should follow the last key letter before data is
  # entered on the lines below.
  #
  # Column descriptors missing from the end of a format line are assumed to be L.
  # That is, if you have more columns of data than descriptors to specify them,
  # the data in the unspecified columns are left-justified. The longest line in
  # the format section defines the number of columns in the table. tbl ignores
  # columns in the data if there are not corresponding key letters in the format
  # section.
  #
  # You may give successive line formats on the same line, separated by commas.
  #
  # The format section is mandatory.
  #
  #
  # The official key letters are:
  #
  #key_letters = 'AaCcLlNnRrSs^'
  #
  # plus _ and =, which may be substituted for a key letter to get a horizontal
  # rule through that cell. Nearby vertical rules are extended to meet.
  #
  # REVIEW "you should put a space or a tab between a 1-letter font name
  #         and whatever follows."
  #
  # TODO This is still incomplete. See tbl: Technical Discussion §4.2, pp. 7-10
  #      space between columns, vertical spacing, explicit minimum column width,
  #      equal-width and staggered columns, zero-width items

  def self.formats(format_section)

    row = 0
    columns = 0
    formats = Array.new
    key_letters = 'AaCcLlNnRrSs^_='

    format_section.each do |fmtline|

      # suppress newlines and the formats terminator; preserve whitespace
      # enable the use of comma for separating formats for successive rows

      fmtline.chomp.gsub(/\.\s*$/, '').split(',').each do |fmts|

        # key letters (of which only one may appear per cell) may be followed by one or more
        # other format characters (e.g. f, s, w, etc.) each of which may be followed by
        # various types of parameters.
        # special case to prevent collecting the fR from a font request as an R primary format - sccs-prs(1) [SunOS 5.5.1]
        #              or the n unit from a minimum width (appearing in parentheses) as a numeric alignment - prtdiag(1m) [SunOS 5.5.1]

        fmts.sub!(/^(\|{0,2})(.+)/, '\2')
        border_left = Regexp.last_match(1)

        formats[row] = fmts.scan(/\|?[#{key_letters}](?:fR|n\)|[^#{key_letters}])*/)
        formats[row][0] = "#{border_left}#{formats[row][0]}"

        # TODO don't allow this to change after initial format (i.e. during subsequent .T&)
        columns = formats[row].count if formats[row].count > columns

      end
      row += 1
    end

    # these methods assume the formats array includes placeholders for spanned cells.
    formats.instance_variable_set(:@tbl_rows, formats.count)
    formats.instance_variable_set(:@tbl_cols, columns)
    formats.instance_variable_set(:@cursor, [ 0, 0 ])
    formats.define_singleton_method(:columns)  { @tbl_cols }
    formats.define_singleton_method(:row?)     { @cursor[0] }
    formats.define_singleton_method(:column?)  { @cursor[1] }
    formats.define_singleton_method(:next_row) { @cursor[1] = 0 ; @cursor[0] += 1 unless @cursor[0] == (@tbl_rows - 1) }
    formats.define_singleton_method(:next_col) { @cursor[1] += 1 unless @cursor[1] == @tbl_cols }
    formats.define_singleton_method(:get_row)  { self[@cursor[0]] }
    formats.define_singleton_method(:get)      { @cursor[1] < @tbl_cols ? self[@cursor[0]].fetch(@cursor[1], "L") : nil }
    formats.define_singleton_method(:box_extend?) do
      extended = []
      if self.get.match(/[_=]/)
        # these will be acted on before the | has been moved
        # TODO: it's not great this method depends on program state/flow
        extended << if self[@cursor[0]+1][@cursor[1]-1].include?('||')
                      :sw2
                    elsif self[@cursor[0]+1][@cursor[1]-1].include?('|')
                      :sw
                    end
        extended << if !self[@cursor[0]+1][@cursor[1]].index('||', 1).nil?
                      :se2
                    elsif !self[@cursor[0]+1][@cursor[1]].index('|', extended.include?(:sw2) ? 2 : 1).nil?
                      :se
                    end
        # these will be acted on after the | has been moved
        extended << if self[@cursor[0]-1][@cursor[1]].start_with?('||')
                      :nw2
                    elsif self[@cursor[0]-1][@cursor[1]].start_with?('|')
                      :nw
                    end
        extended << if !self[@cursor[0]-1][@cursor[1]].index('||', 1).nil?
                      :ne2
                    elsif !self[@cursor[0]-1][@cursor[1]].index('|', extended.include?(:nw2) ? 2 : 1).nil?
                      :ne
                    end
      end
      extended
    end
    formats
  end

  private

  def format_row
    row = Block::TableRow.new(text: [])
    row_adj = Block::TableRow.new(text: [])

    # Font size resets every row. REVIEW ...probably?
    # I'm rather confused about when font/size resets/doesn't reset
    # sysconf(3c) [SunOS 5.5.1] is evidence that an \s carries across a full
    #                           row, in the absence of a countervailing format
    # Sample Table 7 is evidence that it doesn't continue to the next row;
    # Sample Table 2 is evidence that a cell with no size format doesn't
    #                continue the previous cell's size
    #
    # REVIEW need to study the troff generated by tbl
    req_ps "#{@register[:tbl_dsize]}"

    loop do
      cell = case fmt = @state[:tbl_formats].get.dup
             when nil   then break
             when /^s/i then Block::ColSpan.new
             when /\^/  then fmt = '' and Block::RowSpan.new
             else Block::TableCell.new
             end

      # hack to get a border_left (for box extend case; does it ever also appear for
      # real-world tbl formatting?) the way the formats are parsed means we'll never
      # get this unless it's the first character on the line, or I've moved it there
      cell.style.css[:border_left] = case Regexp.last_match(1)
                                     when '|'  then '1px solid black'
                                     when '||' then '3px double black'
                                     end if fmt.sub!(/^(\|{1,2})/, '')

      # standard format: whatever was in effect at the time of .TS -- chrtbl(1m) [SunOS 5.5.1]
      # this will get overridden by this cell's format, if warranted
      # prevent font changes from leaking outside the cell
      #
      # sysconf(3c) [SunOS 5.5.1] suggests the size doesn't actually get reset cell-to-cell,
      #                           ..._if there's no size format specified_?
      # but Sample Table 2 definitely has the size reset every cell. We might have to
      # do some horrible whatever to hack a full row of format changes given an \s in the input
      unescape("#{@state[:escape_char]}f#{@register[:tbl_dfont]}", output: cell) #.tap{ warn "resetting cell font to default based on #{fmt.inspect}" } if fmt.match?(/[fbi]/) ## I think the font face always resets.
      unescape("#{@state[:escape_char]}s#{@register[:tbl_dsize]}", output: cell) #.tap{ warn "resetting cell size to default based on #{fmt.inspect}" } if fmt.include?('p')

      # continue with normal formatting, per documentation
      until fmt.empty? do
        case fmt
        # sizing
        when /^([\.\d]+)/
          col = row.text.length
          spc = Regexp.last_match[1].to_f
          @state[:tbl_colspc][col] ||= spc
          @state[:tbl_colspc][col] = spc if spc > @state[:tbl_colspc][col]
        when /^(w\(?([\d.]+(?:[uicpmnv])?)\)?)/i		# minimum column width
         cell.style.css[:min_width] = to_em(to_u(Regexp.last_match[2], default_unit: 'n')).to_s + "em"
        when /^(e)/	# TODO this doesn't really work, since e only works on columns marked e, and not all may be
          # TODO (maybe): all columns marked 'e' get equal width - gethitcode(3g) [GL2-W2.5]
          warn "tbl wants equal width columns"
          #cell.style.css[:width] = "#{1.0 / @state[:tbl_formats].columns]}%"

        # alignments
        when /^(a)/i  then warn "unimplemented tbl alignment #{Regexp.last_match(1)}" # TODO: "center longest line; left adjust remaining lines with respect to centered line" -- how to do this in HTML?? how is it different in practice from L?
        when /^(n)/i  then cell.style[:numeric_align]    = { :left => 0, :right => 0 }.tap { warn "review table use of numeric alignment in column #{row.count}" }
        when /^(c)/i  then cell.style.css[:text_align]   = 'center'
        when /^(l)/i  then nil # I think this could be considered the default. => cell.style.css[:text_align]   = 'left'
        when /^(r)/i  then cell.style.css[:text_align]   = 'right'

        # font changes - the font registers need manipulating so \fP and \s0 work correctly in cell context
        when /^(b)/i
          unescape "#{@state[:escape_char]}fB", output: cell
        when /^(i)/i
          unescape "#{@state[:escape_char]}fI", output: cell
        when /^(f.[A-Z]?)/ # REVIEW why were we accepting two digits? a font position I think is only one.
          # this manipulation should be safe as we haven't frozen any of these blocks, yet
          # REVIEW I think this (correctly) sets \n(.f as a side effect -- it doesn't?
          fontreq = Regexp.last_match[1]
          fontreq.insert(1, '(') if fontreq.length == 3 # avoid messing with last_match
          unescape "#{@state[:escape_char]}#{fontreq}", output: cell

        when /^(p([-+123]?\d))/ #then req_ps(Regexp.last_match[2])
          # sysconf(3c) [SunOS 5.5.1] has bare 'p' with no number following. tbl doc suggests this
          # is invalid, does nothing. REVIEW does it?
          unescape @state[:escape_char] + 's' + Regexp.last_match[2], output: cell

        # spans
        when /^(s)/i
          cell.parent = row.terminal_text_obj
          cell.colspan_inc

        #when /^(\^)/
        #  row spanning happens in .TS, where we can get at the previous row

        # box rules
        when /^(\|{1,2})/
          current_row = @state[:tbl_formats].row?
          current_col = @state[:tbl_formats].column?
          if current_row > 0 and current_col < (@state[:tbl_formats].columns - 1) and @state[:tbl_formats][current_row - 1][current_col + 1].chars.select { |c| ['_', '='].include?(c) }.any? # that's a lot of work to avoid a regexp, which would foul up the last_match at the bottom of the case statement
            @state[:tbl_formats][current_row][current_col + 1].prepend(Regexp.last_match(1))
          else
            cell.style.css[:border_right] = case Regexp.last_match(1)
                                            when '|'  then '1px solid black'
                                            when '||' then '3px double black'
                                            end
          end
        when /^(_|=)/
          cell.style[:box_rule] = true
          boxrule_cell = Block::TableCell.new(text: LineBreak.new)
          # the odd line height split seems to avoid some kind of rendering bug
          # in Safari 15 where rows with a box rule are slightly taller than the
          # other rows? because the rule takes up some space? maybe?
          cell.style.css[:line_height] = '49%'
          boxrule_cell.style.css[:line_height] = '49%'
          @state[:tbl_formats].box_extend?.each do |corner|
            case corner
            when :nw  then cell.style.css[:border_left]  = '1px solid black'
            when :nw2 then cell.style.css[:border_left]  = '3px double black'
            when :ne  then cell.style.css[:border_right] = '1px solid black'
            when :ne2 then cell.style.css[:border_right] = '3px double black'
            when :sw  then boxrule_cell.style.css[:border_left]  = '1px solid black'
            when :sw2 then boxrule_cell.style.css[:border_left]  = '3px double black'
            when :se  then boxrule_cell.style.css[:border_right] = '1px solid black'
            when :se2 then boxrule_cell.style.css[:border_right] = '3px double black'
            end
          end
          row_adj << boxrule_cell
          cell.style.css[:border_bottom] = case Regexp.last_match(1)
                                           when '_' then '1px solid black'
                                           when '=' then '3px double black'
                                           end

        # otherwise
        when /^(\s+)/ then nil  # spaces that haven't been claimed by above are ignored
        when /^(.)/             # this serves as an 'else' clause
          warn "unimplemented tbl format #{fmt}"
          nil
        end
        fmt.sub!(Regexp.last_match(1), '')
      end
      @state[:tbl_formats].next_col
      row << cell
    end

    #req_ft('R')
    # reset font and size to default - this didn't seem to be working in all circumstances? sysconf(3c) [SunOS 5.5.1]
    #req_ps(Font.defaultsize)

    @state[:tbl_formats].next_row

    #row << row_adj if row_adj.text.any?
    row.boxrule_adjust = row_adj if row_adj.text.any?
    row
  end

  def next_line_tbl
    resc = Regexp.escape @state[:escape_char] || '' # escapes might be disabled; in which case we needn't bother matching them
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
    when /^ *$/ then '' # treat a line of all whitespace same as an empty line.
    when /^.\s*T&/       # special case for format change.
      parse line
      @state[:tbl_bottom_rules] = @state[:tbl_top_rules].dup
      @state[:tbl_top_rules] = nil
      next_line_tbl
    when /^\./           # is a request. process it. do over.
      parse line
      next_line_tbl
    when /^(\s*#{resc}\^|\s*#{resc}?_|\s*=)+$/   # TODO allow changed field separator - prtdiag(1m) [SunOS 5.5.1] has \_ \_ \_ that is accepted
      # TODO _ or = followed by a space (before the tab) are literal _ or =, not borders
      rules = Regexp.last_match(0).split(@state[:tbl_cell_delim])
      @state[:tbl_formats].next_row if rules.length > 1 # ditch the format given for this row... _if it has tabs_
      # based on Documenter's Workbench sample table 3 maybe we want bottom borders if there was a row span
      # REVIEW this is arbitrary, and probably we'll find out there's no correct decision.
      if rules.detect { |r| r.match? /^(\s*#{resc}\^)/ }
        @state[:tbl_bottom_rules] = rules.tap { |n| warn "bottom border change line #{n.inspect}" }
      else
        @state[:tbl_top_rules] = rules.tap { |n| warn "top border change line #{n.inspect}" }
      end
      next_line_tbl
    else
      line
    end
  end

end
