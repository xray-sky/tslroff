# T&.rb
# -------------
#   troff
# -------------
#
#   Alters table formats for subsequent rows
#

module Troff

  def req_TAmp
    formats_terminator = Regexp.new('\.\s*$')
    format_lines = []
    loop do
      break if @line.match?(formats_terminator)
      format_lines << next_line
    end
    @state[:tbl_formats] = Troff.tbl_formats(format_lines)
  end

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
  # REVIEW: "you should put a space or a tab between a 1-letter font name
  #          and whatever follows."
  #
  # TODO: This is still incomplete. See tbl: Technical Discussion §4.2, pp. 7-10
  #       space between columns, vertical spacing, explicit minimum column width,
  #       equal-width and staggered columns, zero-width items

  def self.tbl_formats(format_section)

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

        # create an object to hold the column spacing information. It's not cell-by-cell;
        # if it gets changed "the widest space prevails", so all rows have the same spacing.
        # accomplish this by assigning references to these cells, and being careful to
        # .replace when re-assigning.
        #
        # the space still has to be split half for the right-padding and half for the next
        # column's left padding. tbl gives in en; the css uses em.



        # In order to apply the row (^) and column (S) spans more easily in HTML context,
        # however, we deal with these key letters differently, by shifting an S leftward,
        # and an ^ upward.

        # we might get extra formats with the 's'! -- tbl(1) [SunOS 5.5.1]
        while pos = formats[row].index { |cell| cell.downcase.strip.start_with?('s') } do
          # S formats in prior columns ought to result in an empty (but present) cell,
          # as they will already have been merged left.
          merge_column = pos - 1
          while formats[row][merge_column].empty? do
            merge_column -= 1
          end
          formats[row][merge_column] << " #{formats[row][pos]}" # REVIEW these formats may contradict formats already on the merge cell.
          formats[row][pos] = ''
        end

        while pos = formats[row].index { |cell| cell.match('\^') } do
          # ^ formats in prior rows ought to result in an empty (but present) cell,
          # as they will already have been merged up.
          formats[row][pos].sub!('^', '')
          residual = formats[row][pos]		# it's possible some format remains (e.g. |)
          merge_row = row - 1
          begin
            #while formats[merge_row][pos].empty? do # not empty, surely? '&nil;' instead?
            while formats[merge_row][pos] == '&nil;' do
              # keep going up, past emptied cells
              merge_row -= 1
            end
          rescue NoMethodError
            # REVIEW: short format rows may cause NoMethodErrors? (nil.empty?)
          end
          formats[merge_row][pos] << '^'
          formats[merge_row][pos] << residual unless residual.empty? or formats[merge_row][pos].include?(residual)
          formats[row][pos] = '&nil;' # don't make it totally empty; row spanned cells still have to be tabbed past
        end

        # hack in some extra row spans to accomodate _ and =
        # REVIEW these will be turned into :row_adj ? is that how I made it work?
        if formats[row].include?('_') or formats[row].include?('=')
          formats[row].collect! do |column|
            column << '^' unless column == '_' or column == '='
            column
          end
        end
      end
      row += 1
    end

    # these methods assume the formats array includes placeholders for spanned cells.
    # all span format manipulations must be deferred to format_row, or we'll get into
    # trouble with out-of-bounds accesses, and the "adjust" columns we're tacking on
    # out past the "maximum" column index.
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
    row = Array.new
    row_adj = Block.new(type: :row_adj, text: Array.new)
    loop do
      cell = case fmt = @state[:tbl_formats].get.dup
             when nil     then break
             when ''      then Block.new(type: :colspan_hold)
             when '&nil;' then fmt = '' and Block.new(type: :nil)
             else Block.new(type: :cell)
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
      cur_blk = @current_block
      @current_block = cell
      # sysconf(3c) [SunOS 5.5.1] suggests the size doesn't actually get reset cell-to-cell,
      #                           ..._if there's no size format specified_?
      unescape("#{@state[:escape_char]}f#{@register[:tbl_dfont]}") #.tap{ warn "resetting cell font to default based on #{fmt.inspect}" } if fmt.match?(/[fbi]/) ## I think the font face always resets.
      unescape("#{@state[:escape_char]}s#{@register[:tbl_dsize]}").tap{ warn "resetting cell size to default based on #{fmt.inspect}" } if fmt.include?('p')
      @current_block = cur_blk

      # continue with normal formatting, per documentation
      until fmt.empty? do
        case fmt
        # sizing
        when /^([\.\d]+)/
          #warn "tbl wants to change space between columns to #{Regexp.last_match[1]}"	# TODO? see tbl: tech discussion p.8
          col = row.length
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
        when /^(n)/i  then cell.style[:numeric_align]    = { :left => 0, :right => 0 }
        when /^(c)/i  then cell.style.css[:text_align]   = 'center'
        when /^(l)/i  then nil # I think this could be considered the default. => cell.style.css[:text_align]   = 'left'
        when /^(r)/i  then cell.style.css[:text_align]   = 'right'

        # font changes - the font registers need manipulating so \fP and \s0 work correctly in cell context
        when /^(b)/i
          cell.text.last.font.face      = :bold
          @register['.f'].value = @state[:fpmap]['B']
        when /^(i)/i
          cell.text.last.font.face      = :italic
          @register['.f'].value = @state[:fpmap]['I']
        when /^(f.[A-Z]?)/ # REVIEW why were we accepting two digits? a font position I think is only one.
          # unescape wants to work on @current_block
          # this manipulation should be safe as we haven't frozen any of these blocks, yet
          # REVIEW I think this (correctly) sets \n(.f as a side effect -- it doesn't?
          cur_blk = @current_block
          @current_block = cell
          unescape(@state[:escape_char] + Regexp.last_match[1])
          #@current_block = Block.new(type: :nil)
          #unescape(@state[:escape_char] + 'fP')	# prevent font change from leaking beyond this cell
          @current_block = cur_blk

        when /^(p([-+123]?\d))/ #then req_ps(Regexp.last_match[2])
          # sysconf(3c) [SunOS 5.5.1] has bare 'p' with no number following. tbl doc suggests this
          # is invalid, does nothing. REVIEW does it?
          cur_blk = @current_block
          @current_block = cell
          unescape(@state[:escape_char] + 's' + Regexp.last_match[2])
          #@current_block = Block.new(type: :nil)
          #unescape(@state[:escape_char] + 's0')	# prevent size change from leaking beyond this cell
          @current_block = cur_blk

        # spans
        when /^(s)/i
          cell.style.attributes[:colspan] ? cell.style.attributes[:colspan] += 1 : cell.style.attributes[:colspan] = 2

        when /^(\^)/
          cell.style.attributes[:rowspan] ? cell.style.attributes[:rowspan] += 1 : cell.style.attributes[:rowspan] = 2

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
          row_adj.text << Block.new(type: :cell, text: LineBreak.new)
          # the odd line height split seems to avoid some kind of rendering bug
          # in Safari 15 where rows with a box rule are slightly taller than the
          # other rows?
          cell.style.css[:line_height]   = '49%'
          row_adj.text.last.style.css[:line_height]  = '51%'
          @state[:tbl_formats].box_extend?.each do |corner|
            case corner
            when :nw  then cell.style.css[:border_left]  = '1px solid black'
            when :nw2 then cell.style.css[:border_left]  = '3px double black'
            when :ne  then cell.style.css[:border_right] = '1px solid black'
            when :ne2 then cell.style.css[:border_right] = '3px double black'
            when :sw  then row_adj.text.last.style.css[:border_left]  = '1px solid black'
            when :sw2 then row_adj.text.last.style.css[:border_left]  = '3px double black'
            when :se  then row_adj.text.last.style.css[:border_right] = '1px solid black'
            when :se2 then row_adj.text.last.style.css[:border_right] = '3px double black'
            end
          end
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

    row << row_adj if row_adj.text.any?
    row
  end

end
