# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Solbourne OS/MP Platform Overrides
#
# TODO
#

module Sprite

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.(\d\S*|man)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
    case k.instance_variable_get '@input_filename'
    when /^default\./
      k.instance_variable_set '@manual_entry', '_default'
    when /^index\./
      k.instance_variable_set '@manual_entry', '_index'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        #'Tm' => '&trade;',
        ']l' => '/sprite/lib/ditroff/', # for including tmac.sprite
        ']W' => 'Sprite version 1.0',
        footer: "\\*(]W\\0\\0\\(em\\0\\0\\*(]L"
      }
    )
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # tmac.sprite
  define_method 'AP' do |*args|
    warn "REVIEW - use of .AP #{args.inspect}"
    if args[3] and !args[3].strip.empty?
      send 'TP', args[3]
    elsif args[1] and !args[1].strip.empty?
      send 'TP', "#{@register[')C']}u"
    else
      send 'TP', '15'
    end
    if args[2] and !args[2].strip.empty?
      req_ta "#{@register[')A']}u", "#{@register[')B']}u"
      parse "#{args[0]} \\fI#{args[1]}\\fP   (#{args[2]})"
    else
      req_br
      if args[1] and !args[1].strip.empty?
        parse "#{args[0]} \\fI#{args[1]}\\fP"
      else
        parse "\\fI#{args[0]}\\fP"
      end
    end
    send 'DT'
  end

  # tmac.sprite
  define_method 'AS' do |*args|
    req_nr ')A 10n'
    req_nr ")A #{to_u(__unesc_w("\\w'#{args[1]}'u+3n"))}" if args[0] and !args[0].strip.empty?
    req_nr ")B #{to_u("#{@register[')A'].value}u+15n")}"
    req_nr ")B #{to_u(__unesc_w("\\w'#{args[1]}'u+#{@register[')A'].value}u+3n"))}" if args[1] and !args[1].strip.empty?
    req_nr ")C #{to_u(__unesc_w("#{@register[')B'].value}u+\\w'(in/out)'u+2n"))}"
  end

  # tmac.sprite
  # start/end boxed text
  # TODO
  define_method 'BE' do |*args|
    warn "don't know how to .BE #{args.inspect} yet"
  end

  define_method 'BS' do |*args|
    warn "don't know how to .BS #{args.inspect} yet"
  end

  # tmac.sprite
  define_method 'HS' do |*args|
    send 'PD'
    send 'AS'
    send 'TH', *args
    req_ds "]H #{args[0]}"
    req_ds ']S ' + case args[1]
                   when 'admin'   then 'Administrative Commands'
                   when 'cmds'    then 'User Commands'
                   when 'daemons' then 'Daemons'
                   when 'dev'     then 'Devices'
                   when 'files'   then 'File Formats'
                   when 'lib'     then 'C Library Procedures'
                   when 'tcl'     then 'Tcl Command Language Library'
                   else "UNKNOWN SECTION (#{args[1]})"
                   end
    req_ds ']D \\*(]S'
    req_ds "]L #{File.mtime(@source.filename).strftime('%B %d, %Y')}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
  end

  # tmac.sprite
  define_method 'LG' do |*args|
    req_ps "+1"
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  # replaced by req_HS
  define_method 'TH' do |*args|
    req_ds "]H #{args[0]}"
    req_ds ']D ' + case args[1]
                   when '1'  then 'User Commands'
                   when '1C' then 'User Commands'
                   when '1L' then 'User Commands'
                   when '2'  then 'C Library Procedures'
                   when '3'  then 'C Library Procedures'
                   when '3C' then 'C Library Procedures'
                   when '3F' then 'Fortran Library Procedures'
                   when '3M' then 'Mathematical Library Procedures'
                   when '3N' then 'C Library Procedures'
                   when '3R' then 'RPC Services'
                   when '3S' then 'C Library Procedures'
                   when '3X' then 'C Library Procedures'
                   when '4'  then 'Devices'
                   when '5'  then 'File Formats'
                   when '6'  then 'Games and Demos'
                   when '7'  then 'Tables'
                   when '8'  then 'User Commands'
                   else 'UNKNOWN MANUAL SECTION'
                   end
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?

    heading = "\\*(]H\\0\\0\\(em\\0\\0\\*(]D"
    super(*args, heading: heading)
  end

  define_method 'VE' do |*args|
    # draws a 12pt box rule as right margin character
    warn "can't yet .VE #{args.inspect}"
  end

  define_method 'VS' do |*args|
    # clears box rule margin character
    warn "can't yet .VS #{args.inspect}"
  end
end


