# frozen_string_literal: true
#

class Nroff
  class Line
    STYLES = {
      start: { bold: '<em>',  underline: '<span class="ul">' },
      end:   { bold: '</em>', underline: '</span>' }
    }.freeze

    attr_accessor :section, :links

    def initialize(file: '', line: 0)
      @input_filename = file
      @input_line_number = line
      @formats = []
      @superscript = []
      @baseline = []
      @line = :@baseline
      @section = ''
    end

    def print_at(x, char)
      line = instance_variable_get(@line)
      line[x] ||= String.new
      line[x] << char
    end

    def superscripts?
      @superscript.any?
    end

    def down!
      @line = :@baseline
    end

    def up!
      @line = :@superscript
    end

    def to_html
      if superscripts?
        # the newline needs to be _inside_ the half-line-height div or else it'll be full line-height
        %(<div class="halfline">#{typeset(@superscript)}\n</div><div class="halfline">#{typeset(@baseline)}\n</div>)
      else
        "#{typeset @baseline}\n"
      end
    end

    private

    def style!(style)
      if @formats.include? style
        ''
      else
        @formats << style
        STYLES[:start][style]
      end
    end

    def end_style!(style)
      @formats.delete(style) ? STYLES[:end][style] : ''
    end

    def clear_styles!
      fmt = @formats.reverse.map { |f| STYLES[:end][f] }.join
      @formats = []
      fmt
    end

    def typeset(text_cells)
      line = text_cells.collect do |cell|
        # shortcut normal single characters and whitespace
        # this position was never set (was spaced or tabbed over)
        cell ||= ' '

        # a single character is just output (entitizing &, <, and >)
        # any bold or underlining is turned off.
        cell.length == 1 and next(clear_styles! +
                                  cell.sub(/([&<>])/) { |_m| Nroff::OVERSTRIKES[[Regexp.last_match[1]]] })

        out = String.new
        # repeated characters are overstrikes
        # reduce to single instance of each and turn on bold
        # TODO losing characters out of this (rang, eqnchar(5bsd) [Domain/OS SR10.4])
        #      L^H.^H. is coming out as <em>.</em>, probably damage from col. is it worth fixing? an unbold L and a bold . ?
        # TODO losing clashes out of bold too (title, mklost+found(1M-SysV) [RISC/os 4.52]
        # REVIEW is the solution to this (and maybe of underline too?) to sort ahead of OVERSTRIKES?
        out << (cell.gsub!(%r((\S)+(.*)\1+), '\1\2') ? style!(:bold) : end_style!(:bold))

        # underscores may be combined with other characters to produce underlines
        # we might get here with a literal underscore, if it was bold - don't turn it into an underline
        # TODO getting underline on shift-out '_' :: greek(5) [A/UX 3.0.1]
        out << (cell.gsub!(%r(_+), '') ? style!(:underline) : end_style!(:underline)) unless cell == '_'

        # compose overstruck characters (may have been piled up in any order)
        # any typebox shift-outs have to be kept with the preceeding character
        begin
          out << Nroff::OVERSTRIKES[cell.scan(/.\cN?/).sort]
        rescue Nroff::TypeClashError => e
          key = e.pile
          warn "#{@input_filename} [#{@input_linenumber}]:  #{e.message} #{key.inspect}"
          out << %(<span class="clash">#{key.join('<br />')}</span>)
        end
        #out
      end.join

      @links&.sort { |a, b| b[0].length <=> a[0].length }&.each do |entry, link|
        # allow any number of html tags to appear in the middle of the link text
        # with an extra restriction on <a> tags, so as to not interfere destructively
        # with links we may have already inserted. SR10.4 setprot.hlp will demo failure here.
        # ("any tag not starting with a, and don't allow .*? to encompass more than one tag")
        # TODO this still backfired in the case of SR10.4 BSD term(7) - sh(1) in the middle of csh(1)
        #      can't assume there will _always_ be a whitespace preceeding a reference
        #      term(7) has space with no comma; inty(1) has comma with no space
        # NOTE there's some chance we got here with a \t in the entry text (SR10.4 protection/acls.hlp)
        link_text = Regexp.escape(entry).gsub(/([^\\])/, '\1(?:<[^a][^<]*?>)*').gsub(/\\t/, '\s+')
        # NOTE allow matching underlined refs (e.g. UTek W2.3):
        #       here will be a start tag (<span>) not encompassed by link_text
        # NOTE AIX PS/2 1.2.1 refs are surrounded by double quotes
        line.sub!(%r{(^|[\s,;.]|(?<!=)")((?:<[^a][^<]*?>)*#{link_text})}) { |_m| %(#{Regexp.last_match[1]}<a href="#{link}">#{Regexp.last_match[2]}</a>) }
      end
      line + clear_styles!
    end

  end
end
