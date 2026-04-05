# frozen_string_literal: true
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

  class Manual < BeOS::Manual
    def initialize(file, vendor_class: nil, source_args: nil)
      srcargs = source_args.dup || {}
      case File.basename(file)
      when '97-08-04_adamation.html'
        srcargs.merge!({magic: :HTML, encoding: Encoding::ISO_8859_1})
      when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html', 'BeOS_Software.html'
        srcargs[:encoding] = Encoding::ISO_8859_1
      end

      # this is a nice try and gets the lines split correctly, but it doesn't go far enough for nokogiri
      #source_args[:record_separator] = "\r" if File.dirname(file).include? 'PressInfo'

      super(file, vendor_class: vendor_class, source_args: srcargs, preprocess: :preprocessing)

      case @source.dir
      when /faqs/
        # this spacer gif is messing up the box model
        xpath('//img[@src="../../graphics/spacer.gif"]').each { |img| img['width'] = '0' }
      end

      case @source.file
      when 'mailinglists.html'
        xpath('//body').css('form').each { |form| form['action'] = '' }
      when '97-08-04_adamation.html'
        xpath('//body').css('a[@href="http//www.bespecific.com"]').each { |a| a.replace a.text }
      end
    end

  private

    def preprocessing
      # press releases (and others?) have ^M line endings which are vanishing in nokogiri,
      # causing whitespace collapse
      @source.lines.collect! { |l| l.split("\r").join("\n") } if @source.dir.include? 'PressInfo'
    end
  end

  class HTML < BeOS::HTML ; end

end
