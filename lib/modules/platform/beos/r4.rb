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

module BeOS_R4
  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
      k.instance_variable_get('@source').lines.each { |l| l.force_encoding Encoding::ISO_8859_1 }
    else
      k.instance_variable_get('@source').lines.each { |l| l.gsub!(/&(nbsp|mdash|lt|gt|copy)(?!;)/, '&\1;') }
    end
  end

  def source_init
  super
  @source.xpath('//body').css('form').each { |form| form['action'] = '' } if @source_dir.include?('The_Be_FAQs')
end
