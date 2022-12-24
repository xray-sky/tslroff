# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 3.0 Platform Overrides
#

module SunOS_3_0

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'skyversion.8'
      # incorrectly recognized as nroff source as the first character is '@'
      require_relative '../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_TH, k.method(:TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :TH, k.method(:_TH)
    #when 'default.1'
    #  k.instance_variable_set '@manual_entry', '_default'
    #when 'erf.3m'
    #  src = k.instance_variable_get '@source'
    #  # troff switches font size to do the baseline shift, and I can't get that in html.
    #  # the ouput shift is in em, at the (smaller) size of the outputted text.
    #  src.lines[30].gsub!(/\\s10/, "\\s12")
    #  src.lines[30].gsub!(/(\\u)/, '\\v@-0.5v@')
    #  src.lines[30].gsub!(/(\\d)/, '\\v@0.5v@')
    #when 'lgamma.3m' # REVIEW gamma.3m? (doesn't exist, so isn't a problem?)
    #  src = k.instance_variable_get '@source'
    #  # troff switches font size to do the baseline shift, and I can't get that in html.
    #  # the ouput shift is in em, at the (smaller) size of the outputted text.
    #  src.lines[26].gsub!(/\\s10/, "\\s12")
    #  src.lines[26].gsub!(/(\\u)/, '\\v@-0.5v@')
    #  src.lines[26].gsub!(/(\\d)/, '\\v@0.5v@')
    #when 'mc68881version.8'
    #  # incorrectly recognized as nroff source as the first character is '@'
    #  require_relative '../../dom/troff.rb'
    #  # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
    #  k.define_singleton_method :_init_ds, k.method(:init_ds)
    #  k.define_singleton_method :_TH, k.method(:TH)
    #  k.extend ::Troff
    #  k.define_singleton_method :init_ds, k.method(:_init_ds)
    #  k.define_singleton_method :TH, k.method(:_TH)
    #when 'list', 'Makefile', 'rfiles', 'ufiles', 'vfiles'
    #  raise ManualIsBlacklisted, 'not a manual entry'
    #when 'eqn.eqn', 'eqnchar.eqn'
    #  raise ManualIsBlacklisted, 'eqn preprocessed entries'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']W' => 'Sun Release 3.0\(*b' # ß, eh?
    })
  end

  # REVIEW
  # this is used seemingly to prevent processing the next line
  # as a request. but, it's not in tmac.an or the DWB manual.
  def li(*args)
    parse("\\&" + next_line)
  end

  define_method 'TH' do |*args|
    req_ds "]L Last change: #{args[2]}"
    req_ds ']D ' + case args[1]
                   when '1'  then 'USER COMMANDS'
                   when '1C' then 'USER COMMANDS'
                   when '1G' then 'USER COMMANDS'
                   when '1S' then 'SUN-SPECIFIC USER COMMANDS'
                   when '1V' then 'VAX-SPECIFIC USER COMMANDS'
                   when '2'  then 'SYSTEM CALLS'
                   when '3'  then 'C LIBRARY FUNCTIONS'
                   when '3C' then 'COMPATIBILITY ROUTINES'
                   when '3F' then 'FORTRAN LIBRARY ROUTINES'
                   when '3M' then 'MATHEMATICAL FUNCTIONS'
                   when '3N' then 'NETWORK FUNCTIONS'
                   when '3R' then 'RPC SERVICES'
                   when '3S' then 'STANDARD I/O LIBRARY'
                   when '3X' then 'MISCELLANEOUS FUNCTIONS'
                   when '4'  then 'SPECIAL FILES'
                   when '4F' then 'SPECIAL FILES'
                   when '4I' then 'SPECIAL FILES'
                   when '4N' then 'SPECIAL FILES'
                   when '4P' then 'SPECIAL FILES'
                   when '4S' then 'SPECIAL FILES'
                   when '4V' then 'SPECIAL FILES'
                   when '5'  then 'FILE FORMATS'
                   when '6'  then 'GAMES AND DEMOS'
                   when '7'  then 'TABLES'
                   when '8'  then 'MAINTENANCE COMMANDS'
                   when '8C' then 'MAINTENANCE COMMANDS'
                   when '8S' then 'MAINTENANCE COMMANDS'
                   else 'UNKNOWN SECTION OF THE MANUAL'
                   end

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end


