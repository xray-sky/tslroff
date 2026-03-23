class Font
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
  class C < Font # Courier Monospace
    # ask for Courier specifically; don't delegate to browser monospace pref.
    #def tag ; 'tt' ; end
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;) ; end
  end
  class CW < Font::C ; end # Courier Monospace
  class CI < Font # Courier Monospace
    # ask for Courier specifically; don't delegate to browser monospace pref.
    #def tag ; 'tt' ; end
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;font-style:italic;) ; end
  end
  class CB < Font # Courier Monospace
    # ask for Courier specifically; don't delegate to browser monospace pref.
    #def tag ; 'tt' ; end
    def css_class ; nil ; end
    def css_style ; %(font-family:'CMU Typewriter',monospace;font-weight:bold;) ; end
  end
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
  class L < Font # used (at least) in exports(5) [SunOS 3.5]
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
