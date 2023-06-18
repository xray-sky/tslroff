# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS DR9.1 PR2 Platform Overrides
#
# HTML format input.
#
# TODO:
#   FAQs/bebox.html spills #man (could be shifted left and be fine?)
#   Shell Tools/man1 too wide: - diff, diff3, egrep, fgrep, sdiff
#

module BeOS_PR2
  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'Release Notes'
      # plain text, detected as nroff, but need ::Nroff's to_html method
      k.instance_variable_get('@source').lines.each { |l| l.force_encoding(Encoding::ISO_8859_1).encode!('UTF-8') }
      k.define_singleton_method :to_html, Nroff.instance_method(:to_html)
      k.define_singleton_method :parse_title, proc { 'Release Notes' }
    when 'Upgrading from DR8 or AA'
      # plain text, detected as nroff, but need ::Nroff's to_html method
      k.instance_variable_get('@source').lines.each do |l|
        # looks like these were meant to be typographer's quotes (single?) but they got mojibaked
        l.force_encoding(Encoding::ASCII_8BIT).tr!("\xB2\xB3", "\x92\x91")
        l.force_encoding(Encoding::Windows_1252).encode!('UTF-8')
      end
      k.define_singleton_method :to_html, Nroff.instance_method(:to_html)
      k.define_singleton_method :parse_title, proc { 'Upgrading from DR8 or AA' }
    when '03_support.html'
      k.instance_variable_get('@source').xpath('//body').css('a[@href="custservices@beeurope.com"]').each { |a| a.replace a.text }
    when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
      k.instance_variable_get('@source_lines').each { |l| l.force_encoding Encoding::ISO_8859_1 }
      #k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join)) # REVIEW still necessary?
    when 'index.html'
      raise ManualIsBlacklisted, 'blank' if k.instance_variable_get('@source_dir').match?(/x_/)
    end
  end
end
