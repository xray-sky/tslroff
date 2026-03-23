# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/17/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 8.05 Platform Overrides
#
# TODO
# √ does )H have a value in the footer? - on some pages
#   be nice somehow to prevent the extraneous \0\0\(em\0\0 if )H doesn't get defined...
#    - maybe I can define an end of processing macro to do it
#

class HPUX::V8_05
  class Troff < ::HPUX::Troff

    def initialize(source)
      # .cm is not official nor in tmac.an but is apparently used in practice for comments
      #k.define_singleton_method(:cm, k.method('req_\\"')) if k.methods.include?('req_\\"')
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*()H\\0\\0\\(em\\0\\0\\*(]W",
          'Tm' => '&trade;',
          ')H' => '', # .TH sets this to \&. Some pages define it.
          #']V' => "Formatted:\\0\\0#{File.mtime(@source.filename).strftime("%B %d, %Y")}",
          # REVIEW is this what actually goes in the footer in the printed manual?
          ']V' => File.mtime(@source.file).strftime("%B %d, %Y")
        }
      )
    end

    define_method 'TH' do |*args|
      ds "]W #{__unesc_star('\\*(]V')}"
      ds "]L #{args[3]}"
      ds "]O #{args[2]}"

      # ]O follows the title (if given), centered on its own line.
      unless @named_strings[']O'].empty?
        #space = true
        byline = Block::Footer.new
        byline.style.css[:margin_top] = '0.5em' # TODO not working? getting 4em from css
        unescape "\\f3\\*(]O\\fP", output: byline
        @document << byline
      end
      #sp('1.5v') if space # probably this is overkill, actually

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
      heading << '\\0\\|\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

  end
end
