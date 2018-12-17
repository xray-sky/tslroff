# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Font class
#

require 'modules/immutable.rb'

class Font
  include Immutable

  @@defaultsize = 12

  attr_reader :family, :face, :size

  def initialize(arg = Hash.new)
    @family = (arg[:family] or :default)
    @face   = (arg[:face]   or :regular)
    @size   = (arg[:size]   or @@defaultsize)
  end

  def inspect
    "family: #{@family.inspect}  size: #{@size.inspect}  face: #{@face.inspect}"
  end

  def self.defaultsize
    @@defaultsize
  end

  alias family= immutable_setter
  alias face=   immutable_setter
  alias size=   immutable_setter
end