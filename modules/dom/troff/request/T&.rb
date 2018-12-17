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


    row = 0
    columns = 0
    formats = Array.new
    key_letters = 'AaCcLlNnRrSs^_='

    format_section.each do |fmtline|

      # suppress newlines and the formats terminator; preserve whitespace
      # enable the use of comma for separating formats for successive rows
      #
      # REVIEW: can anything be done about the cell formats _ or = ?
      # REVIEW: does this lose initial '|' ??

      fmtline.chomp.gsub(/\.\s*$/, '').split(',').each do |fmts|

        warn("table formats include horizontal rule #{Regexp.last_match(1)}") if fmts.match(/([_=])/)

        # key letters (of which only one may appear per cell) may be followed by one or more
        # other format characters (e.g. f, s, w, etc.) each of which may be followed by
        # various types of parameters.

        formats[row] = fmts.scan(/[#{key_letters}][^#{key_letters}]*/)
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

        # hack in some extra row spans to accomodate _ and =
        if formats[row].include?('_') or formats[row].include?('=')
          formats[row].collect! do |column|
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
    formats.define_singleton_method(:columns) { @tbl_cols }
    formats.define_singleton_method(:column?) { @cursor[1] }
    formats.define_singleton_method(:next_row) { @cursor[1] = 0 ; @cursor[0] += 1 unless @cursor[0] == (@tbl_rows - 1) }
    formats.define_singleton_method(:next_col) { @cursor[1] += 1 unless @cursor[1] == @tbl_cols }
    formats.define_singleton_method(:get_row) { self[@cursor[0]] }
    formats.define_singleton_method(:get) { @cursor[1] < @tbl_cols ? self[@cursor[0]].fetch(@cursor[1], "L") : nil }
    formats.define_singleton_method(:box_extend?) do
      extended = []
      if self.get.match(/[_=]/)
        extended << :nw if self[@cursor[0]-1][@cursor[1]-1].include?('|')
        extended << :ne if self[@cursor[0]-1][@cursor[1]].include?('|')
        extended << :sw if self[@cursor[0]+1][@cursor[1]-1].include?('|')
        extended << :se if self[@cursor[0]+1][@cursor[1]].include?('|')
      end
      extended
    end

    formats

  end

  private

  def format_row
  end

end