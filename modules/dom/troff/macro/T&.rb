# T&.rb
# -------------
#   troff
# -------------
#
#   Alters table formats for subsequent rows
#

module Troff

  def req_TAmp(_args)
    formats_terminator = Regexp.new('\.\s*$')
    @state[:tbl_formats] = Troff.tbl_formats(@lines.collect_through { |l| l.match(formats_terminator) })
  end

  def self.tbl_formats(format_section)

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

        formats[row] = fmts.scan(/\|?[#{key_letters}][^#{key_letters}]*/)
        columns = formats[row].count if formats[row].count > columns   # TODO: don't allow this to change after initial format (i.e. during subsequent .T&)

        # In order to apply the row (^) and column (S) spans more easily in HTML context,
        # however, we deal with these key letters differently, by shifting an S leftward, 
        # and an ^ upward.

        while pos = formats[row].index { |cell| cell.downcase.strip == 's' } do
          # S formats in prior columns ought to result in an empty (but present) cell,
          # as they will already have been merged left.
          formats[row][pos].sub!(/[Ss]/, '')
          merge_column = pos - 1
          while formats[row][merge_column].empty? do
            merge_column -= 1
          end
          formats[row][merge_column] << 's'
        end

        while pos = formats[row].index { |cell| cell.match('\^') } do
          # ^ formats in prior rows ought to result in an empty (but present) cell, 
          # as they will already have been merged up.
          formats[row][pos].sub!('^', '')
          merge_row = row - 1
          begin
            while formats[merge_row][pos].empty? do
              # keep going up, past emptied cells
              merge_row -= 1
            end
          rescue NoMethodError
            # REVIEW: short format rows may cause NoMethodErrors? (nil.empty?)
          end
          formats[merge_row][pos] << '^'
        end

        # move some | to get clean box extends, if necessary
        #if @formats[row].include?('_') or formats[row].include?('=')

        # hack in some extra row spans to accomodate _ and =
        if formats[row].include?('_') or formats[row].include?('=')
          formats[row].collect! do |column|
          #  if formats[row-1][column-1].include?('|')
          #    formats[row-1][column-1].sub!('|', '')
          #    formats[row-1][column] = '|' + formats[row-1][column]
          #  end
            column << '^' unless column == '_' or column == '='
            column
          end
        end

      end
      row += 1
    end

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
    row = Array.new(@state[:tbl_formats].columns)
    row.collect! do
      cell = Block.new(type: :cell)
      break unless @state[:tbl_formats].get
      format = @state[:tbl_formats].get.dup # the .sub! call will erase the formats right out of @state!
      # hack to get a border_left (for box extend case; does it ever also appear for real-world tbl formatting?)
      # the way the formats are parsed means we'll never get this unless it's the first character on the line, or I've moved it there
      cell.style.css[:border_left] = case Regexp.last_match(1)
                                     when '|'  then '1px solid black'
                                     when '||' then '3px double black'
                                     end if format.sub!(/^(\|{1,2})/, '')
      # continue with normal formatting, per documentation
      until format.empty? do
        case format
        # alignments
        when /^(a)/i  then warn "unimplemented tbl alignment #{Regexp.last_match(1)}" # TODO: "center longest line; left adjust remaining lines with respect to centered line" -- how to do this in HTML?? how is it different in practice from L?
        when /^(n)/i  then cell.style[:numeric_align]    = true
        when /^(c)/i  then cell.style.css[:text_align]   = 'center'
        when /^(l)/i  then nil # I think this could be considered the default. => cell.style.css[:text_align]   = 'left'
        when /^(r)/i  then cell.style.css[:text_align]   = 'right'

        # font changes
        when /^(b)/i  then cell.text.last.font.face      = :bold
        when /^(i)/i  then cell.text.last.font.face      = :italic
        when /^(f\d{1,2})/
          # unescape wants to work on @current_block
          # this manipulation should be safe as we haven't frozen any of these blocks, yet
          cur_blk = @current_block
          @current_block = cell
          unescape("\\" + Regexp.last_match[1])
          @current_block = cur_blk
        when /^(p([-+123]?\d))/
          cur_blk = @current_block
          @current_block = cell
          unescape("\\s" + Regexp.last_match[2])
          @current_block = cur_blk

        # spans
        when /^(s)/i
          row.pop      # REVIEW: is modifying iterable inside loop like this reliable?? seems to work.
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
          if row.last.nil? or row.last.text.last.type != :row_adj
            row << Block.new(type: :row_adj, text: Block.new(type: :cell, text: Text.new(text: "&roffctl_br;")))
          else
            row.last.text << Block.new(type: :cell, text: Text.new(text: "&roffctl_br;"))
          end
          cell.style.css[:line_height]   = '50%'
          row.last.text.last.style.css[:line_height]  = '50%'
          @state[:tbl_formats].box_extend?.each do |corner|
            case corner
            when :nw  then cell.style.css[:border_left]  = '1px solid black'
            when :nw2 then cell.style.css[:border_left]  = '3px double black'
            when :ne  then cell.style.css[:border_right] = '1px solid black'
            when :ne2 then cell.style.css[:border_right] = '3px double black'
            when :sw  then row.last.text.last.style.css[:border_left]  = '1px solid black'
            when :sw2 then row.last.text.last.style.css[:border_left]  = '3px double black'
            when :se  then row.last.text.last.style.css[:border_right] = '1px solid black'
            when :se2 then row.last.text.last.style.css[:border_right] = '3px double black'
            end
          end
          cell.style.css[:border_bottom] = case Regexp.last_match(1)
                                           when '_' then '1px solid black'
                                           when '=' then '3px double black'
                                           end

        # otherwise
        when /^(\s+)/ then nil  # spaces that haven't been claimed by above are ignored
        when /^(.)/             # this serves as an 'else' clause
          warn "unimplemented tbl format #{format}"
          nil
        end
        format.sub!(Regexp.last_match(1), '')
      end
      @state[:tbl_formats].next_col
      cell
    end
    @state[:tbl_formats].next_row
    row
  end

end