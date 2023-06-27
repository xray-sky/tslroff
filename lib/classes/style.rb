# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Style class
#
# TODO something (probably not here) to prevent over-precise values from being output
#      (e.g. '0.0949391831209309em') -- ascii(5) [GL2-W2.5]

require_relative '../modules/immutable'

class Style
  include Immutable
  attr_accessor :css, :attributes

  def initialize(arg = {}, exceptionclass = nil)
    @css = {}
    @attributes = {}
    if exceptionclass
      define_singleton_method('object_exception_class') { exceptionclass }
      singleton_class.send(:private, :object_exception_class)
    end
    arg.each do |k, v|
      self[k] = v
    end
  end

  def inspect
    <<~MSG
      #{keys.collect { |k| { k=>self[k] } }.inspect if keys.any?}
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
    self.class.new(prototype, object_exception_class)
  end
end
