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
  class HelpLibraryModule

    attr_reader :depth, :text

    def initialize(depth, name, helptext)
      #warn "#{'   ' * (depth-1)}new: #{depth} #{name}"
      @name = name.strip # occasionally will get trailing whitespace that messes up the anchors
      @depth = depth
      @subsections = []
      @text = []

      newname = ''
      modtext = []
      helptext.each do |line|
        case line
        #when /^#{@depth+1}\s+(\S.*)$/, /^(\/\S.*)/ # new submodule key or qualifier
        when /^#{@depth+1}\s+(\S.*)$/ # new submodule key
          @subsections << HelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
          newname = Regexp.last_match[1]
          modtext = []
        else (newname.empty? ? @text : modtext) << line
        end
      end
      @subsections << HelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?

      # qualifiers
      newname = ''
      modtext = @text
      @text = []
      modtext.each do |line|
        case line
        when /^(\/\S.*)/ # new qualifier
          @subsections << HelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
          newname = Regexp.last_match[1]
          modtext = []
        else (newname.empty? ? @text : modtext) << line
        end
      end
      @subsections << HelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
    end

    def name
      subsection? ? @name.tr('_', ' ') : @name
    end

    def linkname
      # REVIEW add : to characters to split after? see µ4.4 DEBUG DEPOSIT/ASCII:n
      qualifier? ? @name.sub(/^(\/.+?)[= \[].*$/, '\1') : name # might get something like /[NO]TERMINATE
    end

    def qualifier?
      @name.start_with?('/')
    end

    def subsection?
      !qualifier? and @name.match?(/[a-z]/)
    end

    def command?
      !subsection? and !qualifier?
    end

    def qualifiers
      @subsections.select(&:qualifier?)
    end

    def subsections
      @subsections.select(&:subsection?)
    end

    def commands
      @subsections.select(&:command?)
    end

    def all_subsections
      @subsections
    end

  end
end
