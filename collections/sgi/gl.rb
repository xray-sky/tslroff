# frozen_string_literal: true
#
# SGI GL1/GL2 Platform Overrides
#
# All versions use basically the same macros.
# The only real variation is in font size, and we don't care about that.
#

require_relative 'modules/gl/troff'
require_relative 'modules/gl1_w2.1'
require_relative 'modules/gl2_w2.3'
require_relative 'modules/gl2_w2.4'
require_relative 'modules/gl2_w2.5'
require_relative 'modules/gl2_w2.5r1'
require_relative 'modules/gl2_w3.3.1'
require_relative 'modules/gl2_w3.5r1'
require_relative 'modules/gl2_w3.6'

module GL2

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1d'  then "<strong>#{sec}.</strong> IRIS GL Demos"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1w'  then "<strong>#{sec}.</strong> mex Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2v'  then "<strong>#{sec}.</strong> System V Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3b'  then "<strong>#{sec}.</strong> 4.3BSD Compatibility Routines"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'  then "<strong>#{sec}.</strong> IRIX GL Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'   then "<strong>#{sec}.</strong> Special Files"
    when '5'   then "<strong>#{sec}.</strong> File Formats"
    when '5v'  then "<strong>#{sec}.</strong> System V File Formats"
    when '6'   then "<strong>#{sec}.</strong> Games and Demos"
    when '7'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else sec
    end
  end

end

# module aliases
GL1 = GL2
