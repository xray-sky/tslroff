class Block
  class Bare < Block
    def to_html
      @text
    end
  end

  class Nroff < Block
    def to_html
      # TODO maybe something with a gutter instead of breaking html with multiple id=man
      %(<div class="body"><div id="man"><pre class="n">#{@text.collect(&:to_html).join}</pre></div></div>)
    end
  end

  class Comment < Block
    def to_html
      # TODO as a block, this is breaking up blocks that shouldn't be broke up! as(1) [SunOS 5.5.1]
      # REVIEW is it still?
      %(<!--\n#{@text.to_s}\n-->)
    end
  end

  class Header < Block
    def to_html
      # TODO (was :th)
      # make this delayed processing until the end, to give all the various
      # named strings a chance to be overwritten.
      %(<div class="title"><h1>#{@text.collect(&:to_html).join}</h1></div>\n<div class="body">\n    <div id="man">\n)
    end
  end

  class Footer < Block
    def to_html
      # TODO (was :p)
      %(<p class="foot">#{@text.collect(&:to_html).join}</p>\n)
    end
  end

  class Head < Block
    def to_html # (was :sh)
      "<h2>#{@text.collect(&:to_html).join}</h2>\n"
    end
  end

  class SubHead < Block
    def to_html # (was :ss)
      "<h3>#{@text.collect(&:to_html).join}</h3>\n"
    end
  end

  class SubHeadAlt < Block
    def to_html # (was :ss_alt)
      "<h4>#{@text.collect(&:to_html).join}</h4>\n"
    end
  end

  class SubSubHead < Block
    def to_html # (was :subhead)
      %(<p class="subhead">#{@text.collect(&:to_html).join}</p>\n)
    end
  end

  class ConstantSpace < Block
    def to_html # (was :subhead)
      "<pre>#{@text.collect(&:to_html).join}</pre>\n"
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
      %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium"#{@style.to_s}>#{payload}</span></div></body></html>)
    end
  end

  class Table < Block
    def to_html # (was :table)
      "<table#{style.to_s}>\n#{@text.collect(&:to_html).join}</table>\n"
    end
  end

  class TableRow < Block
    def to_html # (was :row)
      " <tr#{style.to_s}>#{@text.to_html}</tr>\n"
    end
  end

  #when :row_adj then "</tr>\n<tr#{style.to_s}>\n#{t}" # for adjusting tbl rows after _ and =

  class TableCell < Block
    def to_html
      t = @text.to_html
      # clear left/right padding that is equal to the default from css.
      # doing it here because of the whole-column effect of the w() and the
      # cell-by-cell processing we do in .TS/.T&
      style.css.delete(:padding_left) if style.css[:padding_left] == '0.75em'
      style.css.delete(:padding_right) if style.css[:padding_right] == '0.75em'
      t.gsub!(/&tblctl_\S+?;/) do |e|
        case e
        when '&tblctl_nl;'  then %(<span style="width:#{style[:numeric_align][:left].call}em;text-align:right;display:inline-block;">)
        when '&tblctl_nr;'  then %(<span style="width:#{style[:numeric_align][:right].call}em;display:inline-block;">)
        when '&tblctl_ctr;' then %(<span style="width:100%;display:inline-block;text-align:center;">)
        else warn "unimplemented #{e}"
        end
      end
      "  <td#{style.to_s}>#{t}</td>\n"
    end
  end

  class RowSpanHold < Block::TableCell
    # TODO
    # Is it possible to do something here with an instance method
    # to cause border_bottom to be passed upward to the parent cell?
    # maybe instantiate a parent cell relationship so that this cell
    # holds a _reference_ to the correct style?
    #
    # REVIEW Maybe these don't need to be different, in that case
    def to_html ; '' ; end
  end

  class ColSpanHold < Block::TableCell
    # TODO
    # Is it possible to do something here with an instance method
    # to cause border_right to be passed leftward to the parent cell?
    # maybe instantiate a parent cell relationship so that this cell
    # holds a _reference_ to the correct style?
    #
    # REVIEW Maybe these don't need to be different, in that case
    # REVIEW might _need_ them to be the same thing, because this
    #        way we can't have a cell that holds space for both
    #        row and column spans at once
    def to_html ; '' ; end
  end

  class Paragraph < Block
    def to_html
      "<p#{style.to_s}>\n#{@text.to_s}\n</p>\n"
    end
  end

  class Synopsis < Block::Paragraph
    def initalize(arg = Hash.new)
      super(arg)
      css[:class] = 'synopsis'
    end
  end

  private

  def get_object_exception_class
    Kernel.const_get("ImmutableBlockError")
  end

end

#else          %(<p style="color:gray;">BLOCK(#{type})<br>#{t}</p>\n)
