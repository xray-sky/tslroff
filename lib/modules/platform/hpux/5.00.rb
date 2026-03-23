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

class HPUX::V5_00
  class Troff < ::HPUX::Troff

    alias :LP :P
    alias :cm :'\"'


    #def self.extended(k)
    #  # .cm is not official nor in tmac.an but is apparently used in practice for comments
    #  define_singleton_method :cm, method('\"')
    #end

    def init_ds
      super
      @named_strings.merge!(
        {
          # uses )H but this is defined directly in }F so I don't see how it could ever not be H-P
          footer: "Hewlett-Packard\\0\\0\\(em\\0\\0\\*(]W",
          ']L' => '', # explicitly blanked in .TH before being conditionally redefined
          ']W' => "last mod. #{File.mtime(@source.file).strftime("%B %d, %Y")}"
        }
      )
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    define_method 'TH' do |*args|
      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
      ds "]L \\^#{args[2]}\\^" if args[2] and !args[2].strip.empty?
      ds "]D #{args[3]}"

      heading << '\\0\\0\\(em' unless @named_strings[']D'].empty? and @named_strings[']L'].empty?
      heading << '\\0\\0\\*(]D' unless @named_strings[']D'].empty?
      heading << '\\0\\|\\*(]L' unless @named_strings[']L'].empty?
      super(*args, heading: heading)
    end

  end
end
