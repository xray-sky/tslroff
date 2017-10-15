# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Font class
#

require "modules/Immutable.rb"

class Font
  include Immutable

  @@defaultsize = 12

  attr_reader   :family, :face, :size

  def initialize ( arg = Hash.new )
    self.family = (arg[:family] or :default)
    self.face   = (arg[:face]   or :regular)
    self.size   = (arg[:size]   or @@defaultsize)
    @control    =  arg[:control]
    #@control.freeze
  end

  alias_method :family=, :immutable_setter
  alias_method :face=,   :immutable_setter
  alias_method :size=,   :immutable_setter

end


  #%w( family face size ).each do |attr|
  #  define_method("#{attr}=") do |value|
  #    if self.frozen?
  #      raise ImmutableObjectError(self.class.name) unless instance_variable_get("@"+attr.to_s) == value
  #    end
  #    instance_variable_set("@"+attr.to_s, value)
  #  end  
  #end

