# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
#

module VMS
  class HelpLibrary

    attr_reader :name, :modules

    def initialize(name, source)
      @name = name # REVIEW is this useful
      @modules = []

      modname = ''
      modtext = []
      while line = source.next_line do
        #warn "tab encountered: #{line.inspect}" if line.include? "\t" # REVIEW if we switch from ::Nroff
        #case line
        #when /^!/ then next # is comment
        next if line.start_with?('!') # is comment
        #when /^1\s+(\S.*)$/ # new module key
        if line.start_with?('1 ', "1\t")
          @modules << HelpLibraryModule.new(1, modname, modtext)
          #modname = Regexp.last_match[1]
          modname = line.partition(/\s+/).last
          modtext = []
        else modtext << line
        end
      end
    rescue StopIteration
      @modules << HelpLibraryModule.new(1, modname, modtext)
    end

    def subsections
      @modules.select { |mod| mod.name.match? /[a-z]/ }
    end

    def commands
      @modules.reject { |mod| mod.name.match? /[a-z]/ }
    end

  end
end
