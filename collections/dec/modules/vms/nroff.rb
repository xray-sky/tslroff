# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
#
# release notes, etc. - also provides superclass for VMS::Help
#
# TODO
#   needs vt100 escape processing: \e[0;1m, \e[0;4m, \e[m minimum
# √   \e[m - turn off character attributes
# √   \e[0m - turn off character attributes
# √   \e[1m - turn on bold - ordinary release notes typesetting
#     \e[2m - turn on low intensity (> VT100)
# √   \e[4m - turn on underline - ordinary release notes typesetting
#     \e[5m - turn on blink
# √   \e[7m - turn on reverse - used in tpuhelp.hlb
#     \e[8m - turn on invisible (> VT100)
#   \r\n\n line endings? with \r\n for overstruck bold?
#

module VMS
  class Nroff < Nroff

    # constant lookup - this doesn't work because parent method does the lookup TODO
    TYPEBOX = Typesetter::VT100::Symbols
    TYPEBOX.default_proc = proc { |_hash, key| %(<span class="u">typebox (#{key})</span>) }
    TYPEBOX.freeze

    OVERSTRIKES = Nroff::OVERSTRIKES.dup

    OVERSTRIKES.default_proc = proc do |_hash, key|
      key.collect! { |c| c.sub(/(.)\cN/) { TYPEBOX[Regexp.last_match[1]] } }
      key.length == 1 and next key[0]
      raise TypeClashError.new(key), 'unresolved overstrike'
    end

    OVERSTRIKES.freeze # REVIEW do I really want to freeze this, or make it platform overrideable somehow

    class Line < Nroff::Line
      def initialize(file: '', line: 0)
        @overstrikes ||= Nroff::OVERSTRIKES
        super(file: file, line: line)
      end
    end

    def initialize(source, **kwargs)
      # TODO @lines_per_page not entirely satisfactory; kinda want to only break on lf,
      # no matter how many lines. similar issue to reliant unix, but that hack won't work
      # well here since there are no headers/footers in many cases
      # vws033.release_notes likes 54; others like longer
      @lines_per_page = 56
      #@lines_per_page = 61
      #@lines_per_page = 66
      @char_attrs = Array.new(9, false)
      @manual_entry ||= source.file
      super(source, **kwargs)
    end

    # h4x for escapes - acledt uses a few more than this.
    # REVIEW maybe best to do a to_vt method instead of abusing to_lp ?
    def next_line
      super.gsub(/(?:\e\[(?<esc>[0-8;]+)m(?<text>[^\e]+))?(?<reset>\e\[0?m)?/) do
        Regexp.last_match[:esc]&.split(';')&.each do |attr|
          attr == '0' ? clear_char_attrs : @char_attrs[attr.to_i] = true
        end
        warn "char attrs #{@char_attrs.inspect} set" if unsupported_char_attrs?
        (@char_attrs[7] ? "\c&" : '') +
        (Regexp.last_match[:text]&.chars&.map do |char|
          %[#{"_\b" if @char_attrs[4]}#{char}#{"\b#{char}" if @char_attrs[1]}]
        end&.join || '') +
        (@char_attrs[7] ? "\c&" : '').tap { clear_char_attrs if Regexp.last_match[:reset] }
      end.gsub(/\e(?:\[[HJ]|[()][AB012])/, '') # ignore these: home cursor, erase to end of screen, select char sets TODO warn on charset change, so we can figure out if it has to be implemented
    end

    def page_title
      "#{@manual_entry} &mdash; #{@platform} #{@version}"
    end

    protected

    def clear_char_attrs
      @char_attrs.collect! { false }
    end

    def unsupported_char_attrs?
      #@char_attrs[2] || @char_attrs[3] || @char_attrs[5] || @char_attrs[7] || @char_attrs[8]
      @char_attrs[2] || @char_attrs[3] || @char_attrs[5] || @char_attrs[8]
    end

  end
end
