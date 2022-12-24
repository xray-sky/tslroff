class Font
  class R < Font
    def tag ; nil ; end
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
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-family:'Courier New',Courier,monospace;) ; end
  end
  class CW < Font::C ; end # Courier Monospace
  class CI < Font # Courier Monospace
    # ask for Courier specifically; don't delegate to browser monospace pref.
    #def tag ; 'tt' ; end
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-style:italic;font-family:'Courier New',Courier,monospace;) ; end
  end
  class CB < Font # Courier Monospace
    # ask for Courier specifically; don't delegate to browser monospace pref.
    #def tag ; 'tt' ; end
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-weight:bold;font-family:'Courier New',Courier,monospace;) ; end
  end
  class H < Font
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; 'font-family:Helvetica,Geneva,Arial,sans-serif;' ; end
  end
  class HI < Font
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; 'font-family:Helvetica,Geneva,Arial,sans-serif;font-style:italic;' ; end
  end
  class HB < Font
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; 'font-family:Helvetica,Geneva,Arial,sans-serif;font-weight:bold;' ; end
  end
  class L < Font # used (at least) in exports(5) [SunOS 3.5]
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-family:'Helvetica Light','Geneva Light','Arial Light',sans-serif;) ; end
  end
  class LI < Font
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-style:italic;font-family:'Helvetica Light','Geneva Light','Arial Light',sans-serif;) ; end
  end
  class LB < Font
    def tag ; 'span' ; end
    def css_class ; nil ; end
    def css_style ; %(font-weight:bold;font-family:'Helvetica Light','Geneva Light','Arial Light',sans-serif;) ; end
  end
end
