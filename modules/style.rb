# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Style class
#

require 'modules/immutable.rb'

class Style
  include Immutable

  def initialize(arg = Hash.new)
    @control = arg[:control]
    arg.each do |k, v|
      self[k] = v
    end
  end

  def method_missing(method_sym, *args, &block)
    attr = method_sym.to_s.sub(/@/, '')
    val  = args.join
    attr.sub!(/=$/, '') ? self[attr.to_sym] = val : self[attr.to_sym]
  end
end