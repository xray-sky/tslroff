# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS 5.5 Platform Overrides
#
# TODO
#   make the subsection/command overrides properly modular
#     - this implementation is just a hack to test sufficiency
#     - it makes the huge sections appear on their own page, but also puts the links in with the commands.
#       want to separate appearing on a separate page from being included in the COMMANDS links.
#

module VMS_5_5
end

=begin
class VMSHelpLibrary
  def subsections
    @modules.select { |mod| mod.name.match?(/[a-z]/) and !['DECthreads', 'Lexicals', 'RTL Routines', 'Specify', 'System Services', 'V55 NewFeatures'].include?(mod.name) }
  end

  def commands
    @modules.reject { |mod| !['DECthreads', 'Lexicals', 'RTL Routines', 'Specify', 'System Services', 'V55 NewFeatures'].include?(mod.name) and mod.name.match?(/[a-z]/) }
  end
end
=end
