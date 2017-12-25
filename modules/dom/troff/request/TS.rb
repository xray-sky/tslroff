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

    # table data. terminated by .TE macro

    row = 0
    while @blocks.last.type == :table do
      current_row = Block.new(type: :row, style: @current_block.style.dup, text: Array.new)

      # input lines like this aren't table rows, but cause cell borders to be drawn.
      # depending on whitespace, they may apply to individual cells or to entire rows.
      
      if @lines.peek.chop.match(/^([\s_=]+)$/)
        line = Regexp.last_match(0)
        if line.match(/^([_=])/)
        warn "foo"
          current_row.style[:cell_borders] = Array.new(Troff.tbl_width(@state[:tbl_formats]), Regexp.last_match(1))
        else
          current_row.style[:cell_borders] = Array.new(Troff.tbl_width(@state[:tbl_formats]))
          line.split(cell_delim).each_with_index do |fmt, cell|
            current_row.style[:cell_borders][cell] = fmt if fmt == '_' || fmt == '='
          end
        end
        @lines.next

        # special case if this was the LAST row of the table:
        if @lines.peek.match(/^.\s*TE\s*$/)
          current_row.style[:cell_borders].each_with_index do |cell, pos|
            case cell
            when '_' then tbl.text.last.text[pos].style.css[:border_bottom] = '1px solid black'
            when '=' then tbl.text.last.text[pos].style.css[:border_bottom] = '3px double black'
            end
          end
        end
      end

      # row data

      @lines.next.split(cell_delim).each_with_index do |text, cell|
        # looks like row-spanned cells still exist, and need to be tabbed past.
        unless text.empty?          # TODO: falls down with whitespace chars (e.g. \^ <TAB>)
          @current_block = Block.new(type: :cell)
          # if there is no explicit format for this row, the last given row of formats apply.
          row_format = @state[:tbl_formats].fetch(row, @state[:tbl_formats].last)
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
          end

          # were there any other borders to apply here?
          if current_row.style[:cell_borders]
            case current_row.style[:cell_borders][cell]
            when '_' then @current_block.style.css[:border_top] = '1px solid black'
            when '=' then @current_block.style.css[:border_top] = '3px double black'
            end
          end
          @current_block.style.css[:border] = '1px solid black' if tbl.style[:allbox]

          parse(text)
          current_row.text << @current_block
        end
      end
      tbl.text << current_row unless @current_block.type != :cell
      row += 1
    end
  end
  
  def self.tbl_width(formats)
    cols = 0
    formats.each do |row|
      cols = row.count if row.count > cols
    end
    cols
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
    # In order to apply the row (^) and column (S) spans more easily in HTML context,
    # however, we deal with these key letters differently, by shifting an S leftward, 
    # and an ^ upward.
    #
    

    row = 0
    formats = Array.new
    key_letters = 'AaCcLlNnRr^_='

    format_section.each do |fmtline|

      # suppress newlines, optional whitespace, and the formats terminator;
      # enable the use of comma for separating formats for successive rows
      #
      # REVIEW: can anything be done about the cell formats _ or = ?

      fmtline.chomp.gsub(/(?:\s+|\.\s*$)/, '').split(',').each do |fmts|
        warn("table formats include horizontal rule #{Regexp.last_match(1)}") if fmts.match(/([_=])/)
        formats[row] = fmts.scan(/[#{key_letters}][^#{key_letters}]*/)

        # merge any ^ key letters upward
        while pos = formats[row].index { |cell| cell.match(/\^/) } do
          # ^ formats in prior rows ought to result in an empty (but present) cell, 
          # as they will have already been merged up.
          # REVIEW: short format rows may cause NoMethodErrors? (nil.empty?)
          formats[row][pos].sub!(/\^/, '')
          srcrow = row - 1
          while formats[srcrow][pos].empty? do
            # keep going up, past emptied cells
            srcrow -= 1
          end
          formats[srcrow][pos] += '^'
        end
        
      end
      row += 1
    end
    formats
  end
end