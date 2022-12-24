# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Solbourne OS/MP Platform Overrides
#
# TODO
#   some strange doings in section 3 of the OW3.0 manual
#

module OS_MP

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S*)$/, '')
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
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      ']W' => 'Solbourne Computer, Inc.',
      :footer => "\\*(]W"
    })
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # index info - what even makes sense to do with this
  define_method 'IX' do |*args| ; end

  define_method 'SB' do |*args|
    parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
  end

  define_method 'TH' do |*args|
    req_ds ']D ' + case args[1]
                   when '1'  then 'USER COMMANDS'
                   when '1C' then 'USER COMMANDS'
                   when '1G' then 'USER COMMANDS'
                   when '1S' then 'USER COMMANDS'
                   when '1V' then 'USER COMMANDS'
                   when '2'  then 'SYSTEM CALLS'
                   when '2V' then 'SYSTEM CALLS'
                   when '3'  then 'C LIBRARY FUNCTIONS'
                   when '3C' then 'COMPATIBILITY FUNCTIONS'
                   when '3F' then 'FORTRAN LIBRARY ROUTINES'
                   when '3K' then 'KERNEL VM LIBRARY FUNCTIONS'
                   when '3L' then 'LIGHTWEIGHT PROCESSES LIBRARY'
                   when '3M' then 'MATHEMATICAL LIBRARY'
                   when '3N' then 'NETWORK FUNCTIONS'
                   when '3R' then 'RPC SERVICES LIBRARY'
                   when '3S' then 'STANDARD I/O FUNCTIONS'
                   when '3V' then 'C LIBRARY FUNCTIONS'
                   when '3X' then 'MISCELLANEOUS LIBRARY FUNCTIONS'
                   when '4'  then 'DEVICES AND NETWORK INTERFACES'
                   when '4F' then 'PROTOCOL FAMILIES'
                   when '4I' then 'DEVICES AND NETWORK INTERFACES'
                   when '4M' then 'DEVICES AND NETWORK INTERFACES'
                   when '4N' then 'DEVICES AND NETWORK INTERFACES'
                   when '4P' then 'PROTOCOLS'
                   when '4S' then 'DEVICES AND NETWORK INTERFACES'
                   when '4V' then 'DEVICES AND NETWORK INTERFACES'
                   when '5'  then 'FILE FORMATS'
                   when '5V' then 'FILE FORMATS'
                   when '6'  then 'GAMES AND DEMOS'
                   when '7'  then 'ENVIRONMENTS, TABLES, AND TROFF MACROS'
                   when '7V' then 'ENVIRONMENTS, TABLES, AND TROFF MACROS'
                   when '8'  then 'MAINTENANCE COMMANDS'
                   when '8C' then 'MAINTENANCE COMMANDS'
                   when '8S' then 'MAINTENANCE COMMANDS'
                   when '8V' then 'MAINTENANCE COMMANDS'
                   when 'L'  then 'LOCAL COMMANDS'
                   else 'MISC REFERENCE MANUAL PAGES'
                   end
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"

    super(*args, heading: heading)
  end

  define_method 'TX' do |*args|
    req_ds('Tx ' + case args[0]
                   when 'DOCBOX'   then 'Documentation Set'
                   when 'BGBOX'    then 'Beginner\'s Guides'
                   when 'GSBG'     then 'Getting Started with OS/MP: Beginner\'s Guide'
                   when 'SUBG'     then 'Setting Up Your OS/MP Environment: Beginner\'s Guide'
                   when 'SHBG'     then 'Self Help with Problems: Beginner\'s Guide'
                   when 'SVBG'     then 'SunView\ 1 User\'s Guide'
                   when 'MMBG'     then 'Mail and Messages'
                   when 'DMBG'     then 'Doing More with OS/MP: Beginner\'s Guide'
                   when 'UNBG'     then 'Using the Network Beginner\'s Guide'
                   when 'GDBG'     then 'Games, Demos & Other Pursuits'
                   when 'SABOX'    then 'Administration Guides'
                   when 'CHANGE'   then 'OS/MP Release Notes'
                   when 'INSTALL'  then 'OS/MP Release Notes'
                   when 'ADMIN'    then 'System and Network Administration'
                   when 'SECUR'    then 'Security Features Guide'
                   when 'PROM'     then 'PROM User\'s Manual'
                   when 'DIAG'     then 'Solbourne System Diagnostics Manual'
                   when 'SUNDIAG'  then 'Sundiag User\'s Guide'
                   when 'MANPAGES' then 'UNIX User\'s Reference Manual'
                   when 'REFMAN'   then 'UNIX Programmer\'s Reference Manual'
                   when 'SSI'      then 'Series4 and Series5 Hardware Overview'
                   when 'SSO'      then 'Solbourne System Services Overview'
                   when 'TEXT'     then 'Editing Text Files'
                   when 'DOCS'     then 'Formatting Documents'
                   when 'TROFF'    then 'Using \\&\\fBnroff\\fP and \\&\\fBtroff\\fP'
                   when 'INDEX'    then 'on-line help \\f3lookup\\f1\\|(1)'
                   when 'CPG'      then 'C Programmer\'s Guide'
                   when 'CREF'     then 'C Reference Manual'
                   when 'ASSY'     then 'Assembly Language Manual'
                   when 'PUL'      then 'Programming Utilities and Libraries'
                   when 'DEBUG'    then 'Debugging Tools'
                   when 'NETP'     then 'Network Programming'
                   when 'DRIVER'   then 'Solbourne Device Drivers Manual'
                   when 'STREAMS'  then 'STREAMS Programming'
                   when 'SBDK'     then 'SBus Developer\'s Kit'
                   when 'WDDS'     then 'Writing Device Drivers for the SBus'
                   when 'FPOINT'   then 'Floating-Point Programmer\'s Guide'
                   when 'SVPG'     then 'SunView\\ 1 Programmer\'s Guide'
                   when 'SVSPG'    then 'SunView\\ 1 System Programmer\'s Guide'
                   when 'PIXRCT'   then 'Pixrect Reference Manual'
                   when 'CGI'      then 'SunCGI Reference Manual'
                   when 'CORE'     then 'SunCore Reference Manual'
                   when '4ASSY'    then 'Assembly Reference Manual'
                   when 'SARCH'    then '\\s-1SPARC\\s0 Architecture Manual'
                 # non-Sun titles
                   when 'KR'       then 'The C Programming Language'
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                   end
    )
    parse "\\fI\\*(Tx\\f1#{args[1]}"
  end

  # some pages call this, but the def is commented out all the way back to 0.3
  # defining it as a no-op suppresses the warning.
  define_method 'UC' do |*args| ; end

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


