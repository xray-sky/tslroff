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

class Source
  def magic
    case File.basename(@filename)
    when '97-08-04_adamation.html' then 'HTML'
    else @magic
    end
  end
end

module BeOS_R3
  def self.extended(k)
    # press releases (and others?) have ^M line endings which are vanishing in nokogiri,
    # causing whitespace collapse
    if k.instance_variable_get('@source_dir').include? 'PressInfo'
      k.instance_variable_get('@source').lines.collect! do |l|
        l.split("\r").join("\n")
      end
    end
    case k.instance_variable_get '@input_filename'
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html',
         'BeOS_Software.html', '97-08-04_adamation.html'
      k.instance_variable_get('@source').lines.each { |l| l.force_encoding Encoding::ISO_8859_1 }
    end
  end

  def source_init
    super
    case @input_filename
    when 'mailinglists.html' then  @source.xpath('//body').css('form').each { |form| form['action'] = '' }
    when '97-08-04_adamation.html' then @source.xpath('//body').css('a[@href="http//www.bespecific.com"]').each { |a| a.replace a.text }
    end
  end
end
