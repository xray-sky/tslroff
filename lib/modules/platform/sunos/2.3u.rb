# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 2.3U Platform Overrides
#
#  doesn't seem to be an updated macro package in this update-only release
#  fake it with the 1.1 macro package, plus an updated \*(]W
#  REVIEW update this if we ever find the correct tmac.an
#
# TODO
#

module SunOS_2_3U

  def self.extended(k)
    #case k.instance_variable_get '@input_filename'
    #when 'skyversion.8'
    #  # no updated skyversion(8) in 2.2u
    #  # incorrectly recognized as nroff source as the first character is '@'
    #  require_relative '../../dom/troff.rb'
    #  # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
    #  k.define_singleton_method :_init_ds, k.method(:init_ds)
    #  k.define_singleton_method :_TH, k.method(:TH)
    #  k.extend ::Troff
    #  k.define_singleton_method :init_ds, k.method(:_init_ds)
    #  k.define_singleton_method :TH, k.method(:_TH)
    #end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']W' => 'Sun Release 2.3'
    })
  end

  # REVIEW
  # this is used seemingly to prevent processing the next line
  # as a request. but, it's not in tmac.an or the DWB manual.
  # still used in 2.0, but only for binmail(1) - no updated binmail manual in 2.2u
  #def li(*args)
  #  parse("\\&" + next_line)
  #end

  define_method 'TH' do |*args|
    req_ds "]L Last change: #{args[2]}"
    req_ds ']D ' + case args[1]
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

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end
