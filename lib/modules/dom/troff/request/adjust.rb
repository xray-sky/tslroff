# ad.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .ad c    adj,both adjust    E       Line adjustment is begun. If fill mode is not on,
#                                     adjustment will be deferred until fill mode is back
#                                     on. If the type indicator c is present, the adjustment
#                                     type is changed as shown in the following table.
#
#                                     Indicator  |         Adjust Type
#                                     -----------------------------------------
#                                        l       |  adjust left margin only
#                                        r       |  adjust right margin only
#                                        c       |  center
#                                     b or n     |  adjust both margins
#                                     absent     |  unchanged
#
#                                     The adjustment type indicator c may also be a number
#                                     obtained from the .j register. (See section 25 in
#                                     the "Summary," "Predefined Read-Only Registers.")
#
# .na      adjust   -         E       No-adjust. Adjustment is turned off; the right
#                                     margin will be ragged. The adjustment type for .ad
#                                     is not changed. Output line filling still occurs if
#                                     fill mode is on.
#
# [ :left, :both, nil, :center, nil, :right ]
#
#  REVIEW proper interaction with fill mode
#
# .fi      on       -         B,‡,E   Fill subsequent output lines. The register .u is 1
#                                     in fill mode and 0 in no-fill mode.
#
# .nf      fill on  -         B,‡,E   No-fill. Subsequent output lines are neither filled
#                                     nor adjusted. Input text lines are copied directly
#                                     to output text lines without regard for the current
#                                     line length.
#
# TODO §4.2 The copying of an input line in no-fill mode can be interrupted by
#           terminating the partial line with a '\c'. The next encountered input
#           text line will be considered to be a continuation of the same line of input
#           text. If the intervening control lines cause a break, any partial line will
#           be forced out along with any partial word.
#
# TODO §4.2 A word within filled text may be interrupted by terminating the word with
#           '\c'; the next encountered text will be taken as a continuation of the
#           interrupted word. If the intervening control lines cause a break, any
#           partial line will be forced out along with any partial word.
#
# REVIEW our implementation of \c against above ^^^
#
# REVIEW all the edge cases
#        .PP followed by .nf shouldn't margin_top: 0 -- ascii(5) [GL2-W2.5]
#        .br followed by .nf; the browser swallows the <br /> before the </p>, and
#            we get an incorrect margin_top:0 on the next <p>? -- a.out(5) [AOS 4.3]
#
#
# .br      -        -         B       Break. The filling of the line currently being
#                                     collected is stopped and the line is output without
#                                     adjustment. Text lines beginning with space
#                                     characters and empty text lines (blank lines) also
#                                     cause a break.
#
# it appears that 'br does nothing at all.
#
#
# REVIEW  the intersection of all these things needs closer look; on the AOS pages
#         there are lots of examples like adb(1), or bitprt(1) [ AOS 4.3 ]:
#           .nf
#              something
#           .br
#              something else
#           .br
#              third thing
#           .fi
#         where this is output with no extra space between any of the three lines.
#
#         experiments with nroff on a terminal demonstrate that .br never inserts
#         space; it only breaks a line. so three consecutive .brs has the same effect
#         as one, and in nofill mode it has no effect at all.
#
#         also doesn't count for .it
#
# .ce N     off     N=1       B,‡,E   Center the next N input text lines within the
#                                     current (line-length minus indent). If N=0,
#                                     any residual count is cleared. A break occurs after
#                                     each of the N input lines. If the input line is too
#                                     long, it will be left adjusted.
#
#  REVIEW what happens if break suppressed??
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#

class Troff
  def ce(argstr = '', breaking: true)
    warn ".ce invoked with nobreak - how to?" unless breaking
    n = argstr.split.first || '1'

    if n == '0'
      @input_traps.delete_if { |k,v| v[0] == ':R' }#:finalize_ce }
      send '[C'
    else
      n = n.to_i
      nf
      @current_block.style.css[:text_align] = 'center'
      #it(n, :finalize_ce)
      it "#{n} [C"
    end
  end

  #def finalize_ce
  define_method "[C" do |argstr = '', breaking: nil|
    fi
    @current_block.style.css.delete(:text_align)
  end

  def br(_argstr = '', breaking: true)
    return if !breaking or nofill? or broke? or nobreak?
    @current_block << LineBreak.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
  end

  def fi(_argstr = '', breaking: true)
    warn ".fi invoked with nobreak - how to?" unless breaking
    #warn "received pointless argument #{_args.inspect} to .fi - why??" unless _args.empty?
    @register['.u'].value = 1
    # do we need to break? or is this already a brand new block.
    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def nf(_argstr = '', breaking: true)
    warn ".nf invoked with nobreak - how to?" unless breaking
    @register['.u'].value = 0
    # do we need to break? or is this already a brand new block.
    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def na(_argstr = '', breaking: nil)
    @adjust = false
    # REVIEW this should keep .P followed by .na from collapsing margin_top
    if !nofill? and @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def ad(argstr = '', breaking: nil)
    init_ad
    adj = argstr.split.first
    return nil unless adj
    @register['.j'].value = case adj
                            when /^[0135]$/ then adj
                            when 'l'        then 0
                            when 'r'        then 5
                            when 'c'        then 3
                            when 'b', 'n'   then 1
                            else
                              warn "trying to adjust nonsense #{adj.inspect}"
                            end
    if !nofill? and @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def init_ad
    @adjust = true
  end
end
