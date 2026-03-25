class Font

  # Roman
  class R < Font
    # prevent losing styles (e.g. font size - see eqn sub/superscripts) on R fonts
    def tag ; css_styles ? 'span' : nil ; end
    def css_class ; nil ; end
  end

  class I < Font
    def tag ; 'em' ; end
    def css_class ; nil ; end
  end

  class B < Font
    def tag ; 'strong' ; end
    def css_class ; nil ; end
  end

  class BI < Font
    def tag ; 'strong' ; end
    def css_class ; nil ; end
    def css_style ; 'font-style:italic;' ; end
  end

  # Courier Monospace
  class C < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;) ; end
  end

  class CW < Font::C ; end

  class CI < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;font-style:italic;) ; end
  end

  class CB < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;font-weight:bold;) ; end
  end

  # Helvetica
  class H < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Sans',sans-serif;) ; end
  end

  class HI < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Sans',sans-serif;font-style:italic;) ; end
  end

  class HB < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Sans',sans-serif;font-weight:bold;) ; end
  end

  class HX < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Sans',sans-serif;font-weight:bold;font-style:oblique;) ; end
  end

  # Geneva Light - used (at least) in exports(5) [SunOS 3.5]
  class L < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Bright',sans-serif;) ; end
  end

  class LI < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Bright',sans-serif;font-style:italic;) ; end
  end

  class LB < Font
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Bright',sans-serif;font-weight:bold;) ; end
  end

end
