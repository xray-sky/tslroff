class Block
  class Nroff < Block
    def to_html
      # TODO maybe something with a gutter instead of breaking html with multiple id=man
      %(<pre class="n">#{@text.collect(&:to_html).join}</pre>)
    end
  end

  # classification, to allow useful <<
  class Inline < Block
  end

  class Bare < Block::Inline
    def to_html
      @text
    end
  end

  class Comment < Block::Inline
    def to_html
      # TODO as a block, this is breaking up blocks that shouldn't be broke up! as(1) [SunOS 5.5.1]
      # REVIEW is it still?
      %(<!--\n#{@text.to_s}\n-->)
    end
  end

  class Link < Block::Inline
    attr_accessor :href
    def initialize(arg = Hash.new)
      @href = arg[:href]
      super(arg)
    end

    def to_html
      %(<a href="#{@href}">#{@text.collect(&:to_html).join}</a>)
    end
  end

  class Anchor < Block::Inline
    attr_accessor :name
    def initialize(arg = Hash.new)
      @name = arg[:name]
      super(arg)
    end

    def to_html
      %(<a name="##{@name}">#{@text.collect(&:to_html).join}</a>)
    end
  end

  class Header < Block
    def to_html # (was :th)
      %(<div class="title"><h1>#{@text.collect(&:to_html).join}</h1></div>\n<div class="body">\n    <div id="man">\n)
    end
  end

  class Footer < Block
    def to_html # (was :p)
      %(<p class="foot"#{@style}>#{@text.collect(&:to_html).join}</p>\n)
    end
  end

  class Head < Block
    def to_html # (was :sh)
      "<h2#{@style}>#{@text.collect(&:to_html).join}</h2>\n"
    end
  end

  class SubHead < Block
    def to_html # (was :ss)
      "<h3#{@style}>#{@text.collect(&:to_html).join}</h3>\n"
    end
  end

  class SubHeadAlt < Block
    def to_html # (was :ss_alt)
      "<h4#{@style}>#{@text.collect(&:to_html).join}</h4>\n"
    end
  end

  class SubSubHead < Block
    def to_html # (was :subhead)
      %(<p class="subhead"#{@style}>#{@text.collect(&:to_html).join}</p>\n)
    end
  end

  class Monospace < Block
    def to_html # (was :subhead)
      "<pre#{@style}>#{@text.collect(&:to_html).join}</pre>\n"
    end
  end

  class Selenium < Block
    # TODO selenium div is too wide for measuring blocks with text-align:center (e.g. class="foot")
    #      but.. we're not rendering style into selenium div, how are we getting text-align:center??
    #      we are not, something else must be happening
    def to_html # (was :se)
      payload = @text.collect(&:to_html).join
                  .gsub(/(?<!&)#(?!\d+;)/, '&num;') # don't let selenium eat text following a bare # (why does it eat text following a #)
                  .sub(/(\s+)$/) { |s| '&nbsp;' * s.length } # don't let selenium lose trailing whitespace
      %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium"#{@style}>#{payload}</span></div></body></html>)
    end
  end

  class Table < Block
    def to_html # (was :table)
      "<table#{@style}>\n#{@text.collect(&:to_html).join}</table>\n"
    end
  end

  class TableRow < Block
    attr_accessor :boxrule_adjust
    def initialize(arg = Hash.new)
      @boxrule_adjust = arg[:boxrule_adjust]
      super(arg)
    end
    def to_html # (was :row)
      boxrule = ''
      if @boxrule_adjust
        @text.each { |cell| cell.rowspan_inc unless cell.style[:box_rule] }
        boxrule = @boxrule_adjust.to_html
      end
      " <tr#{@style}>#{@text.collect(&:to_html).join}</tr>\n#{boxrule}"
    end
  end

  class TableCell < Block
    def initialize(arg = Hash.new)
      @rowspan = 1
      @colspan = 1
      super(arg)
    end

    def rowspan_inc ; @rowspan += 1 ; end
    def colspan_inc ; @colspan += 1 ; end

    def to_html
      t = @text.collect(&:to_html).join
      # clear left/right padding that is equal to the default from css.
      # doing it here because of the whole-column effect of the w() and the
      # cell-by-cell processing we do in .TS/.T&
      style.css.delete(:padding_left) if style.css[:padding_left] == '0.75em'
      style.css.delete(:padding_right) if style.css[:padding_right] == '0.75em'
      # h4x - style will be immutable by now
      style.attributes[:rowspan] = @rowspan if @rowspan > 1
      style.attributes[:colspan] = @colspan if @colspan > 1

      t.gsub!(/&tblctl_\S+?;/) do |e|
        case e
        when '&tblctl_nl;'  then %(<span style="width:#{style[:numeric_align][:left].call}em;text-align:right;display:inline-block;">)
        when '&tblctl_nr;'  then %(<span style="width:#{style[:numeric_align][:right].call}em;display:inline-block;">)
        when '&tblctl_ctr;' then %(<span style="width:100%;display:inline-block;text-align:center;">)
        # atm we are appending an EndSpan control at the appropriate location. REVIEW why can't we do this all with block classes instead of &tblctl
        else warn "unimplemented #{e}"
        end
      end
      "  <td#{style}>#{t}</td>\n"
    end
  end

  class RowSpan < Block::TableCell
    attr_reader :parent

    def parent=(par)
      @text = par.text
      @style = par.style
      define_singleton_method(:rowspan_inc){ par.rowspan_inc }
      define_singleton_method(:colspan_inc){ par.colspan_inc }
      @parent = par
    end

    def to_html ; '' ; end
  end

  # Same thing, just detectably different for the purpose of skipping/not skipping tabs
  # input tabs skip column spanned cells. row spanned cells must be tabbed past
  class ColSpan < Block::RowSpan
  end

  class Paragraph < Block
    def to_html # (was :p)

      # this used to happen before every block was processed.
      # TODO something better.
      #      something not tied to Block::Paragraph.
      #      something that can be overridden.
      # NOTE Nroff Line class has its own link rewrite
      t = @text.collect(&:to_html).join
      t.gsub!(%r{(?<break>(?:<br />)*)(?<text>(?:<[^<]+?>)*(?<entry>\S+?)(?:<[^<]+?>)*\((?:<[^<]+?>)*(?<fullsec>(?<section>\d.*?)(?:-.*?)*)(?:<[^<]+?>)*\)(?:<[^<]+?>)*)}) do |_m|
        caps = Regexp.last_match
        entry = caps[:entry].sub(/&minus;/, '-')	# this was interfering with link generation - ali(1) [AOS 4.3]
        %(#{caps[:break]}<a href="../man#{caps[:fullsec].downcase}/#{entry}.html">#{caps[:text]}</a>)
      end if style[:linkify]

      "<p#{@style}>\n#{t}\n</p>\n"
    end
  end

  # svg standard display type is block
  class Figure < Block
    def to_html
      #<<~EOD
      #<svg version="1.1" baseProfile="full" id="body" width="8in" height="8in" viewBox="0 0 1 1" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events">)
      #<rect id="background" x="0" y="0" width="1" height="1" stroke="none" fill="white"/>
      #
      #<g id="content" transform="translate(0.22375,0.55312) scale(1,-1) scale(0.00125) " xml:space="preserve" stroke="black" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10.433" stroke-dasharray="none" stroke-dashoffset="0" stroke-opacity="1" fill="none" fill-rule="evenodd" fill-opacity="1" font-style="normal" font-variant="normal" font-weight="normal" font-stretch="normal" font-size-adjust="none" letter-spacing="normal" word-spacing="normal" text-anchor="start">
      #EOD
      <<~EOD
        <svg version="1.1" baseProfile="full" viewBox="0 0 1 1" preserveAspectRatio="none">
        <g xml:space="preserve" fill="none" fill-rule="evenodd" fill-opacity="1"
          stroke="black" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10.433" stroke-dasharray="none" stroke-dashoffset="0" stroke-opacity="1"
          font-style="normal" font-variant="normal" font-weight="normal" font-stretch="normal" font-size-adjust="none" letter-spacing="normal" word-spacing="normal" text-anchor="start">
        #{@text.collect(&:to_svg).join}
        </g>
        </svg>
      EOD
    end
  end

  private

  def get_object_exception_class
    Kernel.const_get("ImmutableBlockError")
  end

end

#else          %(<p style="color:gray;">BLOCK(#{type})<br>#{t}</p>\n)
