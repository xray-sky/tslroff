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
    raise object_exception_class if immutable? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def delete(key)
    attr = "@#{key}"
    raise object_exception_class if immutable? and instance_variable_defined?(attr)
    remove_instance_variable(attr) if instance_variable_defined?(attr)
  end

  def prototype
    # TODO rubocop hates this. figure out what we were after and fix it
    Hash[(keys.collect do |k|
      begin
        [k, self[k].dup]
      rescue TypeError
        [k, self[k]]
      end
    end)]
  end

  def dup
    self.class.new(prototype)
  end

  def ==(other)
    return false unless keys.sort == other.keys.sort
    keys.each do |k|
      return false unless self[k] == other[k]
    end
  end

  def each
    return enum_for(__callee__) unless block_given?
    keys.each do |k|
      yield [k, self[k]]
    end
    self
  end

  def immutable_setter(val)
    attr = "@#{__callee__.to_s.sub(/=$/, '')}"
    raise object_exception_class, "Attr: #{attr} => Val: #{val}" if immutable? and instance_variable_get(attr) != val
    instance_variable_set(attr, val)
  end

  def immutable!
    @immutable = true
  end

  def immutable?
    @immutable
  end

  def keys
    instance_variables.collect do |v|
      v.to_s.sub(/^@/, '').to_sym unless [:@immutable, :@tag, :@css, :@attributes].include?(v)
    end.compact
  end

  def values
    keys.collect do |v|
      send v
    end.compact
  end

  private

  def object_exception_class
    Kernel.const_get("Immutable#{self.class.name}Error")
  end
end
