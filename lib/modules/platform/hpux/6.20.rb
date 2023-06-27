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

module HPUX_6_20

  def self.extended(k)
    # .cm is not official nor in tmac.an but is apparently used in practice for comments
    #k.define_singleton_method(:req_cm, k.method('req_\"')) if k.methods.include?('req_\"')
    case k.instance_variable_get '@input_filename'
    when 'wmove.3w' # has "upper-\left". how did that _ever_ work. REVIEW how does troff handle that pathological input?
      k.instance_variable_get('@source').lines[16].sub!(/\\l/, 'l')
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        # uses )H but this is defined directly in }F so I don't see how it could ever not be HP Co.
        footer: "Hewlett-Packard Company\\0\\0\\(em\\0\\0\\*(]W",
        'Tm' => '&trade;',
        # REVIEW is this what actually goes in the footer in the printed manual?
        ']V' => File.mtime(@source.filename).strftime("%B %d, %Y")
      }
    )
  end

  define_method 'TH' do |*args|
    req_ds "]D #{args[5]}"
    req_ds "]L #{args[3]}"
    req_as "]L \" \\|(\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty? # attend: append ]L
    req_ds "]W #{__unesc_star('\\*(]V')}"
    if args[4] == 'HP-UX'
      req_ds ']L HP-UX'
      # TODO REVIEW
      # not really sure what is going on with the second part of this:
      #.\*(]V
      # ??
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
