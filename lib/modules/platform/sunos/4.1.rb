# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS 4.1.4 Platform Overrides
#
# tmac.an defines \n(PN as the current page number and messes with it in }F
#
# TODO
#   olit widget set pages are crazy with macros, and give according output
#    - e.g. AbbrevMenuButton(3w)
#    - also probably these should end up in man3w (based on .TH), instead of man3 (based on filename)
#   xview.7 -- wants LB font (geneva light bold, presumably, but referred to as "Listing Font")
#

module SunOS_4_1

  def self.extended(k)
    k.instance_variable_set '@lines_per_page', nil
    case k.instance_variable_get '@input_filename'
    when 'ce_db_build.1', 'ce_db_merge.1' # nroff input; no title line
      k.define_singleton_method(:get_title) { { section: '1' } }
      # TODO also has see also link w/ whitespace (e.g. "ref (section)")
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
        ']W' => 'Sun Release 4.1'
      }
    )
  end

  define_method 'SB' do |*args|
    parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
  end

  define_method 'TH' do |*args|
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
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
    req_ds "]W #{args[3]}" if args[3] and !args[3].empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].empty?

    req_ds "]L Last change: #{args[2]}"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

  define_method 'TX' do |*args|
    req_ds('Tx ' + case args[0]
                   when 'GSBG'     then 'Getting Started '
                   when 'SUBG'     then 'Customizing SunOS'
                   when 'SHBG'     then 'Basic Troubleshooting'
                   when 'SVBG'     then 'SunView User\'s Guide'
                   when 'MMBG'     then 'Mail and Messages'
                   when 'DMBG'     then 'Doing More with SunOS'
                   when 'UNBG'     then 'Using the Network'
                   when 'GDBG'     then 'Games, Demos & Other Pursuits'
                   when 'CHANGE'   then 'SunOS 4.1 Release Manual'
                   when 'INSTALL'  then 'Installing SunOS 4.1'
                   when 'ADMIN'    then 'System and Network Administration'
                   when 'SECUR'    then 'Security Features Guide'
                   when 'PROM'     then 'PROM User\'s Manual'
                   when 'DIAG'     then 'Sun System Diagnostics'
                   when 'SUNDIAG'  then 'Sundiag User\'s Guide'
                   when 'MANPAGES' then 'SunOS Reference Manual'
                   when 'REFMAN'   then 'SunOS Reference Manual'
                   when 'SSI'      then 'Sun System Introduction'
                   when 'SSO'      then 'System Services Overview'
                   when 'TEXT'     then 'Editing Text Files'
                   when 'DOCS'     then 'Formatting Documents'
                   when 'TROFF'    then 'Using \\&\\fBnroff\\fP and \\&\\fBtroff\\fP'
                   when 'INDEX'    then 'Global Index'
                   when 'CPG'      then 'C Programmer\'s Guide'
                   when 'CREF'     then 'C Reference Manual'
                   when 'ASSY'     then 'Assembly Language Reference'
                   when 'PUL'      then 'Programming Utilities and Libraries'
                   when 'DEBUG'    then 'Debugging Tools'
                   when 'NETP'     then 'Network Programming'
                   when 'DRIVER'   then 'Writing Device Drivers'
                   when 'STREAMS'  then 'STREAMS Programming'
                   when 'SBDK'     then 'SBus Developer\'s Kit'
                   when 'WDDS'     then 'Writing Device Drivers for the SBus'
                   when 'FPOINT'   then 'Floating-Point Programmer\'s Guide'
                   when 'SVPG'     then 'SunView\\ 1 Programmer\'s Guide'
                   when 'SVSPG'    then 'SunView\\ 1 System Programmer\'s Guide'
                   when 'PIXRCT'   then 'Pixrect Reference Manual'
                   when 'CGI'      then 'SunCGI Reference Manual'
                   when 'CORE'     then 'SunCore Reference Manual'
                   when '4ASSY'    then 'Sun-4 Assembly Language Reference'
                   when 'SARCH'    then '\\s-1SPARC\\s0 Architecture Manual'
          # non-Sun titles
                   when 'KR'       then "The C Programming Language"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                   end
          )
    parse "\\fI\\*(Tx\\f1#{args[1]}"
  end

end

# all literally identical

module SunOS_4_1_1
  def self.extended(k)
    k.extend SunOS_4_1
  end
end

module SunOS_4_1_2
  def self.extended(k)
    k.extend SunOS_4_1
  end
end

module SunOS_4_1_3
  def self.extended(k)
    k.extend SunOS_4_1
  end
end

module SunOS_4_1_3B
  def self.extended(k)
    k.extend SunOS_4_1
  end
end

module SunOS_4_1_3_U1
  def self.extended(k)
    k.extend SunOS_4_1
  end
end

module SunOS_4_1_4
  def self.extended(k)
    k.extend SunOS_4_1
  end
end
