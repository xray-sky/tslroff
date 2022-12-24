# encoding: US-ASCII
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

module HPUX_5_20

  def self.extended(k)
    # .cm is not official nor in tmac.an but is apparently used in practice for comments
    #k.define_singleton_method(:req_cm, k.method(:req_BsQuot)) if k.methods.include?(:req_BsQuot)
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']L' => '', # explicitly blanked in .TH before being conditionally redefined
      ']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      # uses )H but this is defined directly in }F so I don't see how it could ever not be HP Co.
      :footer => "Hewlett-Packard Company\\0\\0\\(em\\0\\0\\*(]W"
    })
  end

  define_method 'TH' do |*args|
    req_ds "]D #{args[5]}"
    req_ds "]L \\^#{args[3]}\\^" if args[3] and !args[3].strip.empty?
    req_as "]L \" \\|(\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty? # attend: append ]L
    if args[4] == 'HP-UX'
      req_ds ']L HP-UX'
      req_ds "]W Version B.1,  #{__unesc_star('\\*(]W')}"
    end

    # ]D follows the title (if given), centered on its own line.
    unless @state[:named_string][']D'].empty?
      byline = Block::Footer.new
      byline.style.css[:margin_top] = '0.5em' # TODO not working? getting 4em from css
      unescape "\\f3\\*(]D\\fP", output: byline
      @document << byline
    end

    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end

# all the same tmac.an

module HPUX_5_20_S300
  def self.extended(k)
    k.extend HPUX_5_20
  end
end

module HPUX_5_20_S500
  def self.extended(k)
    k.extend HPUX_5_20
  end
end

module HPUX_5_50
  def self.extended(k)
    k.extend HPUX_5_20
  end
end

module HPUX_5_50_S300
  def self.extended(k)
    k.extend HPUX_5_20
  end
end

module HPUX_5_50_S500
  def self.extended(k)
    k.extend HPUX_5_20
  end
end
