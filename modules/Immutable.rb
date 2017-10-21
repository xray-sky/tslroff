# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Immutable objects methods
#

class ImmutableObjectError < RuntimeError

  attr_reader :control

  def initialize(control, *message)
    @control = control
    super("Control object #{control} ==> #{message}")
  end

end

module Immutable
  include Enumerable

  def [](key)
    instance_variable_get("@#{key}")
  end

  def []=(key, val)
    attr = "@#{key}"
    raise ImmutableObjectError, @control if frozen? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def delete(key)
    attr = "@#{key}"
    raise ImmutableObjectError, @control if frozen? and instance_variable_defined?(attr)
    instance_variable_remove(attr)
  end

  def dup
    self.class.new(Hash[((keys + [:control]).collect do |k|
      begin
        [k, self[k].dup]
      rescue TypeError
        [k, self[k]]
      end
    end)])
  end

  def each(&block)
    return enum_for(__callee__) unless block_given?
    keys.each do |k|
      yield [k, self[k]]
    end
    self
  end

  def immutable_setter(val)
    attr = "@#{__callee__.to_s.sub(/=$/, '')}"
    raise ImmutableObjectError, @control, "Attr: #{attr} => Val: #{val}" if frozen? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def freeze
    @frozen = true
  end

  def frozen?
    @frozen
  end

  #def inspect
  #  self.keys.map do |k|
  #    
  #  end.to_hash
  #end

  def keys
    instance_variables.collect do |v|
      v.to_s.sub(/^@/, '').to_sym unless [:@control, :@frozen].include?(v)
    end.compact
  end

  def values
    keys.collect do |v|
      self.v
    end.compact
  end

end