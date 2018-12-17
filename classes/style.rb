# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Style class
#

require 'modules/immutable.rb'

class Style
  include Immutable
  attr_accessor :css, :attributes
  attr_writer   :exceptionclass
  
  def initialize(arg = Hash.new, exceptionclass = nil)
    @css = Hash.new
    @attributes = Hash.new
    if exceptionclass
      define_method get_object_exception_class { exceptionclass }
      private :get_object_exception_class
    end
    arg.each do |k, v|
      self[k] = v
    end
  end

  def inspect
    "attributes: #{@attributes.inspect}\ncss:        #{@css.inspect}"
  end

  def method_missing(method_sym, *args, &block)
    attr = method_sym.to_s.sub(/@/, '')
    val  = args.join
    attr.sub!(/=$/, '') ? self[attr.to_sym] = val : self[attr.to_sym]
  end

  def to_s
    attribs = attributes.collect do |attr, value|
      %( #{attr}="#{value}")
    end.join
    
    styles = css.collect do |style, value|
      "#{style.to_s.gsub(/_/, '-')}:#{value};"
    end.join
    styles = %( style="#{styles.strip}") unless styles.empty?
    
    "#{attribs}#{styles}"
  end

end