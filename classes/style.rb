# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Style class
#
# TODO something (probably not here) to prevent over-precise values from being output
#      (e.g. '0.0949391831209309em') -- ascii(5) [GL2-W2.5]

require 'modules/immutable.rb'

class Style
  include Immutable
  attr_accessor :css, :attributes

  def initialize(arg = Hash.new, exceptionclass = nil)
    @css = Hash.new
    @attributes = Hash.new
    if exceptionclass
      self.define_singleton_method('get_object_exception_class') { exceptionclass }
      self.singleton_class.send(:private, :get_object_exception_class)
    end
    arg.each do |k, v|
      self[k] = v
    end
  end

  def inspect
    <<~MSG
      #{keys.collect { |k| {k=>self[k]}}.inspect if keys.any?}
      attributes: #{@attributes.inspect}
      css:        #{@css.inspect}
      immutable?: #{immutable?.inspect}
    MSG
  end

  def to_s
    attribs = attributes.collect do |attr, value|
      %( #{attr}="#{value}")
    end.join

    styles = css.collect do |style, value|
      "#{style.to_s.gsub(/_/, '-')}:#{value};" unless value.nil?
    end.join
    styles = %( style="#{styles.strip}") unless styles.empty?

    "#{attribs}#{styles}"
  end

  def dup
    self.class.new(prototype, get_object_exception_class)
  end

end
