class LineBreak

  def to_html
    '<br />'
  end

  def to_s
    "\n"
  end

  def empty?
    false
  end

  def inspect
    "  <===== line break =====>\n"
  end

end
