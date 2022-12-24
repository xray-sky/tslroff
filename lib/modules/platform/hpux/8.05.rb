# encoding: US-ASCII
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

module HPUX_8_05

  def self.extended(k)
    # .cm is not official nor in tmac.an but is apparently used in practice for comments
    #k.define_singleton_method(:cm, k.method('req_\\"')) if k.methods.include?('req_\\"')
  end

  def init_ds
    super
    @state[:named_string].merge!({
      'Tm' => '&trade;',
      ')H' => '', # .TH sets this to \&. Some pages define it.
      #']V' => "Formatted:\\0\\0#{File.mtime(@source.filename).strftime("%B %d, %Y")}",
      # REVIEW is this what actually goes in the footer in the printed manual?
      ']V' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      :footer => "\\*()H\\0\\0\\(em\\0\\0\\*(]W"
    })
  end

  define_method 'TH' do |*args|
    req_ds "]W #{__unesc_star('\\*(]V')}"
    req_ds "]L #{args[3]}"
    req_ds "]O #{args[2]}"

    # ]O follows the title (if given), centered on its own line.
    unless @state[:named_string][']O'].empty?
      #space = true
      byline = Block::Footer.new
      byline.style.css[:margin_top] = '0.5em' # TODO not working? getting 4em from css
      unescape "\\f3\\*(]O\\fP", output: byline
      @document << byline
    end
    #req_sp('1.5v') if space # probably this is overkill, actually

    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    heading << '\\0\\|\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end
