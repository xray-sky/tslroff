# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HP-UX 5.00 Platform Overrides
#
# TODO
# √ file modification dates
#   kana8 / roman8 mojibaked on tape
#

module HPUX
  module V5_00

    class Source < Source
      def initialize(file, **kwargs, &block)
        #case File.basename file
        #when 'kana8.7'  then kwargs[:encoding] = Encoding::SJIS
        ##when 'roman8.5' then kwargs[:encoding] = Encoding::ROMAN8 # but, this is not an available encoding
        #when 'roman8.7'
        #  define_singleton_method :stream_decompress do
        #    %(|gzip -dc '#{@path}' | iconv -f HP-ROMAN8 -t UTF-8)
        #  end
        #end
        super
        case File.basename file
        when 'block_move.3g'
          patch_line  1, /"$/, ''
          patch_line 50, /^\./, '.\\"' # REVIEW temporary until .if with no args can be investigated
        end
      end
    end

    class Troff < Troff

      alias :LP :P

      def init_ds
        super
        @named_strings.merge!(
          {
            # uses )H but this is defined directly in }F so I don't see how it could ever not be H-P
            footer: "Hewlett-Packard\\0\\0\\(em\\0\\0\\*(]W".+@,
            ']L' => '', # explicitly blanked in .TH before being conditionally redefined
            ']W' => "last mod. #{File.mtime(@source.path).strftime("%B %d, %Y")}"
          }
        )
      end

      def init_TH
        #super
        @register['IN'] = Troff::Register.new(@base_indent)
      end

      # .cm is not official nor in tmac.an but is apparently used in practice for comments
      #alias :cm :'\"'
      def cm(*_args) ; end

      def TH(*args)
        heading = "#{args[0]}\\^(\\^#{args[1]}\\^)".+@
        ds "]L \\^#{args[2]}\\^" if args[2] and !args[2].strip.empty?
        ds "]D #{args[3]}"

        heading << '\\0\\0\\(em' unless @named_strings[']D'].empty? and @named_strings[']L'].empty?
        heading << '\\0\\0\\*(]D' unless @named_strings[']D'].empty?
        heading << '\\0\\|\\*(]L' unless @named_strings[']L'].empty?
        super(*args, heading: heading)
      end

    end

    def self.name_for_section(sec)
      HPUX.name_for_section(sec)
    end

  end
end
