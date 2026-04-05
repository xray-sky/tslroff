# frozen_string_literal: true
#
# motion.rb
# -------------
#   troff
# -------------
#
#   \d - forward (down) 1/2 em vertical motion
#   \h - local horizontal motion
#   \k - store horizontal position
#   \r - reverse (up) 1 em vertical motion
#   \u - reverse (up) 1/2 em vertical motion
#   \v - local vertical motion
#

class Troff

  #   \d - forward (down) 1/2 em vertical motion
  def esc_d(*)
    esc_v %('0.5m')
  end

  #   \h - local horizontal motion
  #
  #   negative values shift carriage toward left margin
  #
  #   The absolute position indicator | may be prepended to a number N to generate the
  #   distance to the vertical or horizontal place N. (§1.3, p.21)
  #
  # TODO
  #   => apparently this applies to all horizontal and vertical requests. (UGH)
  #      .ll, .in, .ti, .ta, .lt, .p, .mc, \h, \l
  #      .pl, .wh, .ch, .dt, .sp, .sv, .ne, .rt, \v, \x, \L
  #
  #
  # TODO   trying to \w a lonely \h fails, as there's no text component and
  #        selenium considers it unrenderable -- spline(1g) [GL2 W2.5]
  #        pathological interactions with .ds and \* ========> so.... now what?
  #
  # TODO need to clear horizontal shift after tab, break, block, etc. once it's
  #      happened, it's stuck on forever. ascii(5) - [GL2-W2.5]
  #       - solve this by differentiating leftward and rightward shifts; making
  #      rightward motion insert an empty span (like a thin space) and a
  #      leftward motion by putting an explicit (narrower) width on the span? - collect examples
  #
  # TODO default unit 'm'

  def esc_h(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = __unesc_w(s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')) # we may have come here without having getargsed
    if req_str.match?(/^[-\w.]+/)
      warn "horizontal motion: #{req_str.inspect}"
      new_style = Style.new(@current_block.terminal_text_style.dup)
      current_shift = new_style[:horizontal_shift] || 0
      new_shift = to_em("#{current_shift}m+#{req_str}").to_f
      if new_shift == 0
        apply { @current_block.terminal_text_style.delete(:horizontal_shift) }
      else
        apply { @current_block.terminal_text_style[:horizontal_shift] = new_shift }
      end
    elsif req_str.start_with?('|')
      req_str.slice!(0)
      warn "attempting to \\h to absolute pos #{req_str.inspect}" # TODO/REVIEW maybe this can, for practical purposes, be handled like a tab? - ar(4) [SunOS 5.5.1]
      warn "^^^ not from beginning of line!" unless broke? # TODO this warning is tripping apparently incorrectly on lex(1) [SunOS 5.5.1] since we're in nofill and just had a linebreak. why?
      new_shift = to_em(req_str.to_s).to_f
      if new_shift.zero?
        apply { @current_block.terminal_text_style.delete(:horizontal_shift) }
      elsif nofill?
        warn ">>> treating it like a tab of #{new_shift}em due to nofill" # TODO tbl outputs \h for column positioning. we should treat this as a tab _from last \h_ in that case. somehow.
        insert_tab width: new_shift
      else
        apply { @current_block.terminal_text_style[:horizontal_shift] = new_shift }
      end
    else
      warn "don't know how to \\h #{req_str.inspect}"
    end
    String.new
  end

  #   \k - store horizontal position
  def esc_k(s)
    s.slice!(0) if s.start_with?('(')
    warn "using \\k to store a horizontal position in #{s}..."
    block = Block::Selenium.new(style: @current_block.style.dup)
    last_break = @current_block.text.rindex { |t| t[:tab_stop] == 0 }
    block.text = @current_block.text.slice(last_break..-1)

    # keep a single trailing whitespace from being eaten in html -- lex(1) [SunOS 5.5.1]
    last_text = block.text.reverse.detect { |t| !t.empty? }
    # might not be a straight String
    last_text.text.sub!(/\s$/, '&nbsp;') if last_text.text.respond_to? :sub!

    @register[s] = Register.new(0)
    @register[s].value = typesetter_width(block).to_i unless block.to_s.empty?
    warn "\\k stored #{@register[s].value} in #{s}"
    String.new
  end

  #   \r - reverse (up) 1 em vertical motion
  def esc_r(*)
    esc_v %('-1m')
  end

  #   \u - reverse (up) 1/2 em vertical motion
  def esc_u(*)
    esc_v %('-0.5m')
  end

  #   \v - local vertical motion
  #
  #   negative values shift carriage toward top of page
  #
  #  this takes place at the current font size. since we aren't outputting anything
  #  in html context to represent the current font size, we need to do something to get
  #  the right amount of space when we have set a size for the motion that is different
  #  from the last output.
  #
  #    e.g. gamma(3) puts 8pt bounds on a 10pt integral -- \s10\(is\d\s80\s10\u\u\s8\(if
  #    - because we are applying baseline shift as a text style, you can see how the
  #      10 point size will have changed to 8 by the time output appears in the Text object
  #      and will be rendered in the browser at the smaller size.
  #
  #      maybe the place to "fix" this is in .ps - ugh.
  #
  # REVIEW
  #   what is the default unit?? v? -- yes.
  def esc_v(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    if req_str.match?(/^([-\w.]+)/)
      new_style = Style.new(@current_block.terminal_text_style.dup)
      current_baseline = new_style[:baseline] || 0
      new_baseline = to_em("#{current_baseline}m+#{to_u(req_str, default_unit: 'v')}u").to_f
      if new_baseline == 0
        apply { @current_block.terminal_text_style.delete(:baseline) }
      else
        apply { @current_block.terminal_text_style[:baseline] = new_baseline }
      end
    else
      warn "don't know how to \\v #{req_str.inspect}"
    end
    String.new
  end
end
