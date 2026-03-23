# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R3 Platform Overrides
#
# HTML format input.
# TODO
#   something's happened to a bunch of the graphics assets - they appear to be present but aren't loading
#   shell tools h1 titles (.css('pre').first)
#   page titles
#   symlink rewrite (index.html [*]: encountered unsupported link type, /Volumes/Museum/Manual/in/be/beos/r4/beos/documentation/User's Guide/index.html => 00_FrontMatter/index.html)
#

class BeOS::R3

  class Manual < ::Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when '97-08-04_adamation.html'
        @source = Source.new file, source_args.merge({magic: 'HTML', encoding: Encoding::ISO_8859_1})
      when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html', 'BeOS_Software.html'
        @source = Source.new file, source_args.merge({encoding: Encoding::ISO_8859_1})
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class HTML < ::BeOS::HTML

    def initialize(source)
      # press releases (and others?) have ^M line endings which are vanishing in nokogiri,
      # causing whitespace collapse
      super(source)
      if source.dir.include? 'PressInfo'
        source.lines.collect! { |l| l.split("\r").join("\n") }
      end
    end

    def source_init
      file = @source.file

      super

      case file
      when 'mailinglists.html'
        @source.xpath('//body').css('form').each { |form| form['action'] = '' }
      when '97-08-04_adamation.html'
        @source.xpath('//body').css('a[@href="http//www.bespecific.com"]').each { |a| a.replace a.text }
      end
    end

  end
end
