# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS DR9.1 PR2 Platform Overrides
#
# HTML format input.
#
# TODO
#   FAQs/bebox.html spills #man (could be shifted left and be fine?)
#   Shell Tools/man1 too wide: - diff, diff3, egrep, fgrep, sdiff
#   rewritten links are (at least in Installing the BeOS)
#     - happening ugly for external links
#     - failing to happen for file:/// links
#

class Source
  def magic
    case File.basename(@filename)
    when 'Release Notes', 'Upgrading from DR8 or AA' then 'Nroff'
    when 'rcs.html' then 'HTML'
    else @magic
    end
  end
end

module BeOS_PR2
  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'Release Notes' # plain text, detected as nroff
      k.instance_variable_get('@source').lines.each { |l| l.force_encoding(Encoding::ISO_8859_1).encode!('UTF-8') }
      k.define_singleton_method(:parse_title, proc { 'Release Notes' })
    when 'Upgrading from DR8 or AA' # plain text, detected as nroff
      k.instance_variable_get('@source').lines.each do |l|
        # looks like these were meant to be typographer's quotes (single?) but they got mojibaked
        l.force_encoding(Encoding::ASCII_8BIT).tr!("\xB2\xB3", "\x92\x91")
        l.force_encoding(Encoding::Windows_1252).encode!('UTF-8')
      end
      k.define_singleton_method(:parse_title, proc { 'Upgrading from DR8 or AA' })
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
      k.instance_variable_get('@source').lines.each { |l| l.force_encoding Encoding::ISO_8859_1 }
    when 'index.html'
      raise ManualIsBlacklisted, 'blank' if k.instance_variable_get('@source_dir').match?(/x_/)
    end
  end

  def source_init
    super
    case @input_filename
    when '03_support.html' then @source.xpath('//body').css('a[@href="custservices@beeurope.com"]').each { |a| a.replace a.text }
    end
  end
end
