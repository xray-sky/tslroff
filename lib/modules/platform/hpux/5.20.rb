# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/17/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 5.20 / 5.50 Platform Overrides
#
# REVIEW 5.20 S300/S500 manual differences might just be the TCP stuff added to S300?
#             no. like 300 more pages in s300. the s500 manual does also apparently cover s200, s300, and s800?
#             but s500 pages contain only s500 chatr; s300 pages contain only s200/s300 chatr
#             so I guess we keep them separate.
#
# TODO
#   file modification dates
#   5.20 S300 nroff manuals mixed in; need some nroff methods for that to succeed - title, section detect.. anything else?
#

class HPUX::V5_20
  class Troff < ::HPUX::Troff

    def initialize(source)
      # .cm is not official nor in tmac.an but is apparently used in practice for comments
      #k.define_singleton_method(:req_cm, k.method('req_\"')) if k.methods.include?('req_\"')
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          # uses )H but this is defined directly in }F so I don't see how it could ever not be HP Co.
          footer: "Hewlett-Packard Company\\0\\0\\(em\\0\\0\\*(]W",
          ']L' => '', # explicitly blanked in .TH before being conditionally redefined
          ']W' => File.mtime(@source.path).strftime("%B %d, %Y")
        }
      )
    end

    define_method 'TH' do |*args|
      ds "]D #{args[5]}"
      ds "]L \\^#{args[3]}\\^" if args[3] and !args[3].strip.empty?
      as "]L \" \\|(\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty? # attend: append ]L
      if args[4] == 'HP-UX'
        ds ']L HP-UX'
        ds "]W Version B.1,  #{__unesc_star('\\*(]W')}"
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

# all the same tmac.an

class HPUX::V5_20::S300 < HPUX::V5_20 ; end
class HPUX::V5_20::S500 < HPUX::V5_20 ; end
class HPUX::V5_50 < HPUX::V5_20 ; end
class HPUX::V5_20::S300 < HPUX::V5_20 ; end
class HPUX::V5_20::S500 < HPUX::V5_20 ; end

# not strictly identical, though functionally so

class HPUX::V6_00 < HPUX::V5_20 ; end
