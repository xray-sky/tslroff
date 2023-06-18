# encoding: US-ASCII
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

module BeOS_R4
  def self.extended(k)
    if k.instance_variable_get('@source_dir').include?('The_Be_FAQs')
      k.instance_variable_get('@source').xpath('//body').css('form').each { |form| form['action'] = '' }
    end
    case k.instance_variable_get '@input_filename'
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
      k.instance_variable_get('@source_lines').each { |l| l.force_encoding Encoding::ISO_8859_1 }
      #k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join))
    else
      k.instance_variable_get('@source_lines').each do |l|
        l.gsub!(/&(nbsp|mdash|lt|gt|copy)(?!;)/, '&\1;')
      end
      #k.instance_variable_set('@source', Nokogiri::HTML(source_lines.join))
    end
  end
end
