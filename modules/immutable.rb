# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Immutable objects methods
#

module Immutable
  include Enumerable

  def self.included(baseclass)
    # Create an ImmutableObject exception class for the class that's been extended
    Object.const_set("Immutable#{baseclass}Error", Class.new(RuntimeError))
  end

  def [](key)
    instance_variable_get("@#{key}")
  end

  def []=(key, val)
    attr = "@#{key}"
    raise get_object_exception_class if frozen? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def delete(key)
    attr = "@#{key}"
    raise get_object_exception_class if frozen? and instance_variable_defined?(attr)
    instance_variable_remove(attr)
  end

  def dup
    self.class.new(Hash[(keys.collect do |k|
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
    raise get_object_exception_class, "Attr: #{attr} => Val: #{val}" if frozen? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def freeze
    @frozen = true
  end

  def frozen?
    @frozen
  end

  def keys
    instance_variables.collect do |v|
      v.to_s.sub(/^@/, '').to_sym unless [:@frozen, :@css, :@attributes].include?(v)
    end.compact
  end

  def values
    keys.collect do |v|
      self.v
    end.compact
  end

  private

  def get_object_exception_class
    Kernel.const_get("Immutable#{self.class.name}Error")
  end
end