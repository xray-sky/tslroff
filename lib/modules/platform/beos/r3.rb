# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R3 Platform Overrides
#
# HTML format input.
# TODO:
#  shell tools h1 titles (.css('pre').first)
#  page titles
#  symlink rewrite (index.html [*]: encountered unsupported link type, /Volumes/Museum/Manual/in/be/beos/r4/beos/documentation/User's Guide/index.html => 00_FrontMatter/index.html)
#

module BeOS_R3
  def self.extended(k)
    # press releases (and others?) have ^M line endings which are vanishing in nokogiri,
    # causing whitespace collapse
    if k.instance_variable_get('@source_dir').include? 'PressInfo'
      k.instance_variable_get('@source_lines').collect! do |l|
        l.split("\r").join("\n")
      end
      k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join))
    end
    case k.instance_variable_get '@input_filename'
    when 'mailinglists.html'
      k.instance_variable_get('@source').xpath('//body').css('form').each { |form| form['action'] = '' }
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html',
         'BeOS_Software.html'
      k.instance_variable_get('@source_lines').each { |l| l.force_encoding Encoding::ISO_8859_1 }
      k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join))
    when '97-08-04_adamation.html'
      if k.instance_variable_get('@magic') == :Unknown
        k.instance_variable_get('@source').lines.each { |l| l.force_encoding Encoding::ISO_8859_1 }
        k.instance_variable_set('@magic', :HTML)
        k.extend ::HTML
        k.send :source_init
      end
      k.instance_variable_get('@source').xpath('//body').css('a[@href="http//www.bespecific.com"]').each { |a| a.replace a.text }
    end
  end
end
