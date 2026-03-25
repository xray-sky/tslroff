# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R4 Platform Overrides
#
# HTML format input.
#
# TODO:
#  content too wide faqs/faq-0181.html, several others? (egrep etc. same as r3)
#  shell tools h1 titles (.css('pre').first)
#  page titles
#  symlink rewrite (index.html [*]: encountered unsupported link type, /Volumes/Museum/Manual/in/be/beos/r4/beos/documentation/User's Guide/index.html => 00_FrontMatter/index.html)
#

class BeOS::R4

  class Manual < BeOS::Manual
    def initialize(file, vendor_class: nil, source_args: nil)
      srcargs = source_args.dup || {}
      case File.basename(file)
      when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
        srcargs[:encoding] = Encoding::ISO_8859_1
      end

      super(file, vendor_class: vendor_class, source_args: srcargs, preprocess: :preprocessing)

      case @source.dir
      when /The_Be_FAQs/
        xpath('//body').css('form').each { |form| form['action'] = '' }
        # this spacer gif is messing up the box model
        xpath('//img[@src="../graphics/spacer.gif"]').each { |img| img['width'] = '0' }
      end
    end

  private

    def preprocessing
      @source.patch(/&(nbsp|mdash|lt|gt|copy)(?!;)/, '&\1;', global: true)
    end
  end

  class HTML < BeOS::HTML ; end

end
