class LineBreak
  def to_html
    '<br />'
  end

  def to_s
    "\n"
  end

  def length
    0
  end

  def empty?
    true
  end

  def inspect
    "  <===== line break =====>\n"
  end
end
