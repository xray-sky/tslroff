# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 4.0 Platform Overrides
#
# TODO
# √ \fL ? - "Geneva Light"
#   curses(3v) uses \z and \o to poor effect (REVIEW is \o failing in tbl context?)
#       these are meant to be line graphics characters; maybe rewrite them.
#       \z is not working because \(br is _supposed_ to output skinny and
# √     Overstrike centers within the box. maybe I need a different class for \z
#       ...same problems as terminfo(4) [SunOS 5.5.1]

module SunOS_4_0

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'default.1'
      k.instance_variable_set '@manual_entry', '_default'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        ']W' => 'Sun Release 4.0'
      }
    )
  end

  define_method 'SB' do |*args|
    parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
  end

  define_method 'TH' do |*args|
    req_ds "]L Last change: #{args[2]}"
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
                   when '3P' then 'SUNPHIGS LIBRARY' # unbundled
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
                   when '7P' then 'SUNPHIGS LIBRARY' # unbundled
                   when '8'  then 'MAINTENANCE COMMANDS'
                   when '8C' then 'MAINTENANCE COMMANDS'
                   when '8S' then 'MAINTENANCE COMMANDS'
                   when '8V' then 'MAINTENANCE COMMANDS'
                   when 'L'  then 'LOCAL COMMANDS'
                   else 'MISC. REFERENCE MANUAL PAGES'
                   end
    req_ds "]W #{args[3]}" if args[3] and !args[3].empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].empty?

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

  define_method 'TX' do |*args|
    req_ds('Tx ' + case args[0]
                   when 'DOCBOX'   then "Documentation Set"
                   when 'BGBOX'    then "Beginner's Guides Minibox"
                   when 'GSBG'     then "Getting Started with SunOS: Beginner's Guide"
                   when 'SUBG'     then "Setting Up Your SunOS Environment: Beginner's Guide"
                   when 'SHBG'     then "Self Help with Problems: Beginner's Guide"
                   when 'SVBG'     then "SunView\\ 1 Beginner's Guide"
                   when 'MMBG'     then "Mail and Messages: Beginner's Guide"
                   when 'DMBG'     then "Doing More with SunOS: Beginner's Guide"
                   when 'UNBG'     then "Using the Network: Beginner's Guide"
                   when 'GDBG'     then "Games, Demos & Other Pursuits"
                   when 'SABOX'    then "System Administration Manuals Minibox"
                   when 'CHANGE'   then "Release 4.0 Change Notes"
                   when 'INSTALL'  then "Installing the SunOS"
                   when 'ADMIN'    then "System and Network Administration"
                   when 'SECUR'    then "Security Features Guide"
                   when 'PROM'     then "PROM User's Manual"
                   when 'DIAG'     then "Sun System Diagnostics Manual"
                   when 'REFBOX'   then "Reference Manuals Minibox"
                   when 'MANPAGES' then "SunOS Reference Manual"
                   when 'REFMAN'   then "SunOS Reference Manual"
                   when 'SSI'      then "Sun System Introduction"
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
                   when 'CORE'     then "SunCore Reference Manual"
                   when '4ASSY'    then "Sun-4 Assembly Language Reference Manual"
          # non-Sun titles
                   when 'KR'       then "The C Programming Language"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                   end
          )
    parse "\\fI\\*(Tx\\f1#{args[1]}"
  end
end


