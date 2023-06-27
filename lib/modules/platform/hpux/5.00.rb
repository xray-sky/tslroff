# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 5.00 Platform Overrides
#
# TODO
#   file modification dates
#

module HPUX_5_00

  def self.extended(k)
    # .cm is not official nor in tmac.an but is apparently used in practice for comments
    k.define_singleton_method(:req_cm, k.method('req_\"')) if k.methods.include?('req_\"')
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        # uses )H but this is defined directly in }F so I don't see how it could ever not be H-P
        footer: "Hewlett-Packard\\0\\0\\(em\\0\\0\\*(]W",
        ']L' => '', # explicitly blanked in .TH before being conditionally redefined
        ']W' => "last mod. #{File.mtime(@source.filename).strftime("%B %d, %Y")}"
      }
    )
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'TH' do |*args|
    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    req_ds "]L \\^#{args[2]}\\^" if args[2] and !args[2].strip.empty?
    req_ds "]D #{args[3]}"

    heading << '\\0\\0\\(em' unless @state[:named_string][']D'].empty? and [:named_string][']L'].empty?
    heading << '\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?
    heading << '\\0\\|\\*(]L' unless @state[:named_string][']L'].empty?
    super(*args, heading: heading)
  end

end
