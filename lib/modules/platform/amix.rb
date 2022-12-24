# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Amiga SVR4 Platform Overrides
#

module AMIX

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.Z$/, '')
    #k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      ']W' => 'Amiga Unix',
      :footer => "\\*(]W\\0\\0\\(em\\0\\0\\*(]L"
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

  # .so with absolute path, headers in /usr/include
  def req_so(name, breaking: nil)
    osdir = @source_dir.dup
    @source_dir << '/../..' if name.start_with?('/')
    super(name)
    @source_dir = osdir
  end

  define_method 'TH' do |*args|
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
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
                   when '3V' then 'SYSTEM V LIBRARY'
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
                   when '7'  then 'PUBLIC FILES, TABLES, AND TROFF MACROS'
                   when '8'  then 'MAINTENANCE COMMANDS'
                   when '8C' then 'MAINTENANCE COMMANDS'
                   when '8S' then 'MAINTENANCE COMMANDS'
                   when '8V' then 'MAINTENANCE COMMANDS'
                   when 'L'  then 'LOCAL COMMANDS'
                   else 'MISC REFERENCE MANUAL PAGES'
                   end
    req_ds "]L Last change: #{args[2]}"
    req_ds "]W #{args[4]}" if args[4] and !args[4].empty?
    req_ds "]D #{args[5]}" if args[5] and !args[5].empty?

    super(*args, heading: heading)
  end

  define_method 'TX' do |*args|
    req_ds('Tx ' + case args[0]
                   when 'DOCBOX'   then "Documentation Set"
                   when 'BGBOX'    then "Beginner's Guides Minibox"
                   when 'GSBG'     then "Getting Started with Amiga Unix: Beginner's Guide"
                   when 'SUBG'     then "Setting Up Your Amiga Unix Environment: Beginner's Guide"
                   when 'SHBG'     then "Self Help with Problems: Beginner's Guide"
                   when 'SVBG'     then "SunView\\ 1 Beginner's Guide"
                   when 'MMBG'     then "Mail and Messages: Beginner's Guide"
                   when 'DMBG'     then "Doing More with Amiga Unix: Beginner's Guide"
                   when 'UNBG'     then "Using the Network: Beginner's Guide"
                   when 'GDBG'     then "Games, Demos & Other Pursuits"
                   when 'SABOX'    then "System Administration Manuals Minibox"
                   when 'CHANGE'   then "Release 4.0 Change Notes"
                   when 'INSTALL'  then "Installing Amiga Unix"
                   when 'ADMIN'    then "System and Network Administration"
                   when 'SECUR'    then "Security Features Guide"
                   when 'PROM'     then "PROM User's Manual"
                   when 'DIAG'     then "Amiga Unix System Diagnostics Manual"
                   when 'SUNDIAG'  then "Sundiag User's Guide"
                   when 'REFBOX'   then "Reference Manuals Minibox"
                   when 'MANPAGES' then "Amiga Unix Reference Manual"
                   when 'REFMAN'   then "Amiga Unix Reference Manual"
                   when 'SSI'      then "Amiga Unix System Introduction"
                   when 'SSO'      then "System Services Overview"
                   when 'TEXT'     then "Editing Text Files"
                   when 'DOCS'     then "Formatting Documents"
                   when 'TROFF'    then "Using \\&\\fLnroff\\fP and \\&\\fLtroff\\fP"
                   when 'INDEX'    then "Global Index"
                   when 'PTBOX'    then "Programmer's Tools Manuals Minibox"
                   when 'CPG'      then "C Programmer's Guide"
                   when 'CREF'     then "C Reference Manual"
                   when 'ASSY'     then "Assembly Language Manual"
                   when 'PUL'      then "Programming Utilities and Libraries"
                   when 'DEBUG'    then "Debugging Tools"
                   when 'NETP'     then "Network Programming"
                   when 'DRIVER'   then "Writing Device Drivers"
                   when 'FPOINT'   then "Floating Point Programmers Guide"
                   when 'SVPG'     then "SunView\\ 1 Programmer's Guide"
                   when 'SVSPG'    then "SunView\\ 1 System Programmer's Guide"
                   when 'PIXRCT'   then "Pixrect Reference Manual"
                   when 'CGI'      then "SunCGI Reference Manual"
                   when 'CORE'     then "Amiga Unix Core Reference Manual"
                   when '4ASSY'    then "Sun-4 Assembly Language Reference Manual"
          # non-Sun titles
                   when 'KR'       then "The C Programming Language"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                   end
    )
    parse "\\fI\\*(Tx\\fP#{args[1]}"
  end

  # some pages call this, but the def is commented out
  # defining it as a no-op suppresses the warning.
  define_method 'UC' do |*args| ; end

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
