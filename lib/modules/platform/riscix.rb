# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Acorn RISCix Platform Overrides
#

module RISCiX

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1]
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => 'UNIX Programmer\'s Manual',
      #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      ']W' => '7th Edition',
      :footer => "\\*(]W"
    })
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_PD
    super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # "some support to get the RCS format date into a more normal text form (dd/mm/yy)"
  define_method 'dA' do |*args|
    send 'rR', *(args[0]&.split('/'))
  end

  # "puts new date format in string Da"
  define_method 'rR' do |*args|
    req_ds "Da #{args[2]}/#{args[1]}/#{args[0]}"
  end

  # "An Acorn specific macro to put revision number / date
  #  into the footer of the manual page from information
  #  provided by RCS. The argument is of form:
  #  .AH $Revision: 1.5 $ $Date: 88/10/20 11:12:34 $"
  define_method 'AH' do |*args|
    send 'dA', args[4]
    req_ds "]L Revision #{args[1]} of \\*(Da"
  end

  define_method 'AT' do |*args|
    req_ds(']W ' + case args[0]
                   when '3' then '7th Edition'
                   when '4' then 'System III'
                   when '5'
                     case args[1]
                     when '' then 'System V'
                     else "System V Release #{args[1]}"
                     end
                   else '7th Edition'
                   end)
  end

  define_method 'DE' do |*args|
    req_fi
    send 'RE'
    req_sp '.5'
  end

  define_method 'DS' do |*args|
    send 'RS'
    req_nf
    req_sp
  end

  # indexing and other undefined macros. ignore.
  define_method 'BY' do |*args| ; end
  define_method 'iX' do |*args| ; end
  define_method 'IX' do |*args| ; end # defined in tmac.s
  define_method 'SB' do |*args| ; end # REVIEW this one looks like we lost content
  define_method 'TX' do |*args| ; end
  define_method 'UX' do |*args| ; end # defined in tmac.s

  define_method 'TH' do |*args|
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

  define_method 'UC' do |*args|
    req_ds(']W ' + case args[0]
                   when '3' then '3rd Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end)
  end

  # good news - margin characters don't seem to be used anywhere in the Sun manual
  define_method 'VE' do |*args|
    # .if '\\$1'4' .mc \s12\(br\s0
    # draws a 12pt box rule as right margin character
    warn "can't yet .VE #{args.inspect}"
  end

  define_method 'VS' do |*args|
    # .mc
    # clears box rule margin character
    warn "can't yet .VS #{args.inspect}"
  end
end
