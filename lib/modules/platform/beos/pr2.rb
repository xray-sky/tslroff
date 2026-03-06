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

class BeOS::PR2

  class Manual < ::Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'Release Notes'
        @source = Source.new(file, magic: 'Nroff', encoding: Encoding::ISO_8859_1, source_args: source_args)
      when 'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
        @source = Source.new(file, encoding: Encoding::ISO_8859_1, source_args: source_args)
      when 'Upgrading from DR8 or AA'
        @source = Source.new(file, magic: 'Nroff', source_args: source_args)
      when 'rcs.html'
        @source = Source.new(file, magic: 'HTML', source_args: source_args)
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class HTML < ::BeOS::HTML

    def source_init
      file = @source.file
      case file
      when 'Release Notes' # plain text, detected as nroff
        define_singleton_method(:parse_title, proc { 'Release Notes' })
      when 'Upgrading from DR8 or AA' # plain text, detected as nroff
        @source.lines.each do |l|
          # looks like these were meant to be typographer's quotes (single?) but they got mojibaked
          l.force_encoding(Encoding::ASCII_8BIT).tr!("\xB2\xB3", "\x92\x91")
          l.force_encoding(Encoding::Windows_1252).encode!('UTF-8')
        end
        define_singleton_method(:parse_title, proc { 'Upgrading from DR8 or AA' })
      when 'index.html'
        raise ManualIsBlacklisted, 'blank' if @source.dir.match?(/x_/)
      end

      super

      case file
      when '03_support.html'
        @source.xpath('//body').css('a[@href="custservices@beeurope.com"]').each { |a| a.replace a.text }
      end
    end

  end
end
