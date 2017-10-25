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
    self.family = (arg[:family] or :default)
    self.face   = (arg[:face]   or :regular)
    self.size   = (arg[:size]   or @@defaultsize)
    @control    =  arg[:control]
  end

  def self.defaultsize
    @@defaultsize
  end

  alias family= immutable_setter
  alias face=   immutable_setter
  alias size=   immutable_setter
end