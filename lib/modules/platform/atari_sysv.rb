# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Atari SysV Platform Overrides
#
# TODO
# √ 1.1-06 xterm.1 and a lot of ue12 has base indent of only 2
#   ue12 cc(1) detects title line in SEE ALSO
#

module Atari_SysV

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
    k.instance_variable_set '@heading_detection', %r{^\s{2,3}(?<section>[A-Z][A-Za-z\s]+)$}
    k.instance_variable_set '@title_detection', %r{^\s{2,3}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}		# REVIEW now what?
    k.instance_variable_set '@lines_per_page', 67
  end

# looks like none of this matters much, as the provided pages are all nroff format except for X11.
  def init_ds
    super
    @state[:named_string].merge!({
      'U'  => 'Baker',
      #'Tm' => '&trade;',
      # "for UniSoft"
      'sA' => '\\s-1UNIX\\s+1',
      'sS' => '\\s-1USL UNIX\\s+1',
      'sl' => '\\s-1UNIX\\s+1 System V/68 or V/88 Release 4',
      'sL' => '\\s-1UNIX\\s-1\\u\\(rg\\d\\s+2 System V/68 or V/88 Release 4',
      's3' => '\\s-1UNIX\\s-1\\u\\(rg\\d\\s+2 System V/68 and V/88 Release 4',
      's4' => 'UniSoft \\s-1UNIX\\s+1 System V Release 4.0 for the 68040',
      's5' => 'UniSoft \\s-1UNIX\\s+1 System V Release 4.0 for the 88100',
      's6' => 'UniSoft \\s-1UNIX\\s+1 System V Release 4.0 68K',
      's7' => 'UniSoft \\s-1UNIX\\s+1 System V Release 4.0 88K',
      'v4' => 'UniSoft \\s-1UNIX\\s+1 System V Release 4.0',
      's1' => '\\s-1UNIX\\s+1 System V/68',
      's2' => '\\s-1UNIX\\s+1 System V/88',
      'hC' => 'Motorola',
      'hs' => '\\s-1M\\s068000 or \\s-1M\\s088000 family of processors',
      'hl' => 'supported DeltaSeries and DeltaServer reference platforms',
      'h1' => '\\s-1M\\s068000 family of processors',
      'h2' => '\\s-1M\\s068000 family of processors',
      'h3' => '\\s-1M\\s088000 family of processors',
      'h4' => '\\s-1M\\s068000 family of processors',
      'rp' => 'reference platform',
      ']D' => '', # explicitly blanked by .TH before conditionally re-defining
      ']L' => '', # explicitly blanked by .TH before conditionally re-defining
      ']W' => "(last mod. #{File.mtime(@source.filename).strftime("%B %d, %Y")})",
      :footer => "\\*(]W"
    })
  end

  def init_ta
    @state[:tabs] = [ '3.6m', '7.2m', '10.8m', '14.4m', '18m', '21.6m', '25.2m', '28.8m',
                      '32.4m', '36m', '39.6m', '43.2m', '46.8m' ].collect { |t| to_u(t).to_i }
    true
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # end of everything macros; irrelevant for us
  def ee(*args) ; end
  define_method 'Ee' do |*args| ; end

  define_method 'DT' do |*args|
    init_ta
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
    req_ds "]L (\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty?
    req_ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

    heading = "#{args[0]}"
    # tmac.an has it without the extra space, but this is an nroff affordance
    #heading << "(#{args[1]})" if args[1] and !args[1].strip.empty? # peculiar
    heading << "\\^(\\^#{args[1]}\\^)" if args[1] and !args[1].strip.empty?
    heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?
    heading << ' \\|\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end

