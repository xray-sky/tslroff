# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 2.0 Platform Overrides
#

module SunOS_2_0

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'skyversion.8'
      # incorrectly recognized as nroff source as the first character is '@'
      require_relative '../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_req_TH, k.method(:req_TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :req_TH, k.method(:_req_TH)
    end
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']W' => 'Sun Release 2.0'
    })
  end

  # REVIEW
  # this is used seemingly to prevent processing the next line
  # as a request. but, it's not in tmac.an or the DWB manual.
  # still used in 2.0, but only for binmail(1)
  def req_li(*args)
    parse("\\&" + next_line)
  end

  def req_TH(*args)
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    req_ds ']D', case args[1]
                 when '1'  then 'USER COMMANDS'
                 when '1C' then 'USER COMMANDS'
                 when '1G' then 'USER COMMANDS'
                 when '1S' then 'SUN-SPECIFIC USER COMMANDS'
                 when '1V' then 'VAX-SPECIFIC USER COMMANDS'
                 when '2'  then 'SYSTEM CALLS'
                 when '3'  then 'SUBROUTINES'
                 when '3C' then 'COMPATIBILITY ROUTINES'
                 when '3F' then 'FORTRAN LIBRARY ROUTINES'
                 when '3M' then 'MATHEMATICAL FUNCTIONS'
                 when '3N' then 'NETWORK FUNCTIONS'
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

    unescape("\\*(]W", output: @state[:footer])
    if args[2]
      req_ds ']L', "Last change: #{args[2]}"
      unescape '\\0\\0\\(em\\0\\0\\*(]L', output: @state[:footer]
    end

    heading << '\\0\\0\\(em\\0\\0\\*(]D'
    super(*args, heading: heading)
  end

end
