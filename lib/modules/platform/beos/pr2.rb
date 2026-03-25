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
# REVIEW Maybe messed up the PR2 source directory
#

class BeOS::PR2

  class Manual < BeOS::Manual
    def initialize(file, vendor_class: nil, source_args: nil, preprocess: nil)
      srcarg = source_args.dup || {}
      case File.basename(file)
      when 'Release Notes', 'Upgrading from DR8 or AA', 'Installing the BeOS',
           'diff.html', 'diff3.html', 'egrep.html', 'fgrep.html', 'sdiff.html'
        srcarg[:encoding] = Encoding::ISO_8859_1
      when 'rcs.html'
        srcarg[:magic] = :HTML
      #when 'index.html'
      #  raise ManualIsBlacklisted, 'blank' if File.dirname(file).match?(/x_/)
      end

      super(file, vendor_class: vendor_class, source_args: srcarg)

      case @source.file
      when '03_support.html'
        xpath('//body').css('a[@href="custservices@beeurope.com"]').each { |a| a.replace a.text }
      when 'Upgrading from DR8 or AA'
        # looks like these were meant to be typographer's quotes (single?) but they got mojibaked
        @source.lines.collect! { |l| l.tr("²³", "’‘") }
      end
    end
  end

  class Nroff < BeOS::Nroff
    def initialize source
      super source
      case @source.file
      when 'Release Notes' # plain text, detected as nroff
        define_singleton_method :parse_title, proc { 'Release Notes' }
      when 'Upgrading from DR8 or AA' # plain text, detected as nroff
        define_singleton_method :parse_title, proc { 'Upgrading from DR8 or AA' }
      end
    end
  end

  class HTML < BeOS::HTML ; end

end
