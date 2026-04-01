# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/17/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 6.20 Platform Overrides
#
# TODO
#   file modification dates
#   rcsfile.4 actually expects to use \(LL
#   looped in sccsfile.4 ??
#
# √ syncer.1m :: use of refer -- .[  .]
#                not actually. looks like mistake in synopsis section
#   wpan.3w :: links ',wmove(3W)' saw a couple other pages with goofy links, e.g. 'stty (1)'
#

class HPUX::V6_20
  class Troff < HPUX::Troff

    def initialize source
      case source.file
      # has "upper-\left". how did that _ever_ work. REVIEW how does troff handle that pathological input?
      when 'wmove.3w' then source.patch_line(17, /\\l/, 'l')
      end
      super source
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          # uses )H but this is defined directly in }F so I don't see how it could ever not be HP Co.
          footer: "Hewlett-Packard Company\\0\\0\\(em\\0\\0\\*(]W",
          'Tm' => '&trade;',
          # REVIEW is this what actually goes in the footer in the printed manual?
          ']V' => File.mtime(@source.path).strftime("%B %d, %Y")
        }
      )
    end

    def TH(*args)
      ds "]D #{args[5]}"
      ds "]L #{args[3]}"
      as "]L \" \\|(\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty? # attend: append ]L
      ds "]W #{send '__unesc_*', '\\*(]V'}"
      if args[4] == 'HP-UX'
        ds ']L HP-UX'
        # TODO REVIEW
        # not really sure what is going on with the second part of this:
        #.\*(]V
        # ??
      end

      # ]D follows the title (if given), centered on its own line.
      unless @named_strings[']D'].empty?
        byline = Block::Footer.new
        byline.style.css[:margin_top] = '0.5em' # TODO not working? getting 4em from css
        unescape "\\f3\\*(]D\\fP", output: byline
        @document << byline
      end

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

  end
end
