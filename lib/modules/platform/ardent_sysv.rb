# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ardent SysV Platform Overrides
#
# TODO
#   do something to prevent bsd manual from overwriting non-bsd manual
#

class Ardent_SysV
  class Troff < ::Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*(]W",
          'Dd' => 'Dor&eacute;',
          'Tm' => '&trade;',
          ']W' => File.mtime(@source.path).strftime('%B %d, %Y')
        }
      )
    end

    def init_nr
      @register[':m'] = Troff::Register.new(to_u '6v')
      @register[')M'] = Troff::Register.new(to_u '3.6m')
    end

    def init_ta
      @tabstops = %w[3.6m 7.2m 10.8m 14.4m 18m 21.6m 25.2m 28.8m 32.4m 36m 39.6m 43.2m 46.8m].collect { |t| to_u(t).to_i }
      true
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    # end of document processing (print final page number, etc.)
    # don't care.
    def ee(*_args) ; end
    define_method 'Ee' do |*_args| ; end

    # assorted index processing
    # don't care.
    def iX(*_args) ; end
    define_method 'IX' do |*_args| ; end

    define_method 'PD' do |*args|
      nr "PD " + ((args[0] and !args[0].strip.empty?) ? "#{args[0]}v" : '.4v')
    end

    define_method 'PM' do |*args|
      warn ".PM #{args.inspect} - testing"
      ph = Block.new(text: Text.new(font: Font::I.new))
      pm = Block.new(text: Text.new(font: Font::B.new))
      ph.style.css[:text_align] = 'center'
      pm.style.css[:text_align] = 'center'

      case args[0]
      when '', nil
        return '' # REVIEW I think that's how this goes. nothing => nothing. something, but different, default case
      when 'CI-II'
        ph.text.text = [ VerticalSpace.new(height: '2'), 'CI-II' ]
        pm.text.text = [
          'Not for disclosure to AT&amp;T Information Systems.', LineBreak.new,
          'Subject to FCC separation requirements under Computer Inquiry II.', VerticalSpace.new(height: '2')
        ]
      when 'P', 'BPP', 'BR'
        ph.text.text = [ VerticalSpace.new(height: '2'), 'AT&amp;T BELL LABORATORIES &mdash; PROPRIETARY (RESTRICTED)' ]
        pm.text.text = [
          'Solely for authorized persons having a need to know', LineBreak.new,
          'pursuant to G.E.I. 2.2', VerticalSpace.new(height: '2')
        ]
      when 'ILL'
        pm.text.text = [
          'THIS DOCUMENT CONTAINS PROPRIETARY INFORMATION OF', LineBreak.new,
          'AT&amp;T BELL LABORATORIES AND IS NOT TO BE DISCLOSED,', LineBreak.new,
          'REPRODUCED, OR PUBLISHED WITHOUT WRITTEN CONSENT.', LineBreak.new,
          'THIS DOCUMENT MUST BE RENDERED ILLEGIBLE WHEN BEING DISCARDED.', VerticalSpace.new(height: '2')
        ]
      else # also explicitly for 'BP', 'BPN'
        ph.text.text = [ VerticalSpace.new(height: '2'), 'AT&amp;T BELL LABORATORIES &mdash; PROPRIETARY' ]
        pm.text.text = [ 'Use pursuant to G.E.I. 2.2', VerticalSpace.new(height: '2') ]
      end

      @document << ph
      @document << pm
      @document << blockproto
    end

    define_method 'TH' do |*args|
      ds "]L (\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty?
      ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

      heading = "#{args[0]}"
      # tmac.an has it without the extra space, but this is an nroff affordance
      #heading << "(#{args[1]})" if args[1] and !args[1].strip.empty?
      heading << "\\^(\\^#{args[1]}\\^)" if args[1] and !args[1].strip.empty?
      heading << '\\0\\0\\(em\\0\\0\\*(]D'
      heading << ' \\|\\*(]L' unless @named_strings[']L'].empty?
      # REVIEW consider moving ]D to footer; removing parens from ]L and separating by \(em

      super(*args, heading: heading)
    end

  end
end
