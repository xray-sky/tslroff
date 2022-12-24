# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX V7 Platform Overrides
#
# TODO
#

module UNIX_V7

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => "UNIX Programmer's Manual",
      ']W' => "7th Edition",
      # uses )H but this is defined directly in }F so I don't see how it could ever not be H-P
      :footer => "\\*(]W"
    })
  end

  define_method 'TH' do |*args|
    req_ds "]L #{args[2]}"

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end
