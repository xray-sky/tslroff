# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#
# frozen_string_literal: true
#

class Troff

  private

  def parse(line)
    if escapes?
      resc = Regexp.escape @escape_character

      # lines starting with \! are read in copy mode and transparently output
      if line.sub!(/^#{resc}!/, '')
        warn "transparent throughput? #{line.inspect}"
        @current_block << unescape(line, copymode: true)
        return true
      end

      # trim trailing spaces, along with any following comments
      # don't lose trailing spaces which have been escaped though
      #
      # this kills .\" "comment requests" that I had previously been
      # outputting into <-- --> html comments
      #
      # Multiple inter-word space characters found in the input are retained §4.1
      # unescaped trailing spaces are not.
      #
      # REVIEW this algorithm is suspect; '\ \    ' should still rstrip some spaces.
      #line.rstrip! unless line.match(/#{resc} +$/)
      line.sub!(/((?<!#{resc})#{resc} )? *(?:(?<!#{resc})#{resc}".*)?$/, '\1')
    end

    line.start_with?(@cc, @c2) ? request(line) : output(line)
  end

  ###
  ### ordinary text
  ###

  def output(line)
    # A blank text line causes a break and outputs a blank line
    # exactly like '.sp 1' §5.3 - also in nofill mode
    #
    # a line with only spaces counts as a blank line. a tab does not.
    #
    # REVIEW
    # my .sp outputs Block::VerticalSpace instead of causing a <br />
    #
    # TODO hm, I'm getting an extra .br (because of a space adjustment??)
    #      on consecutive blank text lines. - hesinfo(1) [AOS-4.3]

    # we should have already stripped any such spaces.
    if line.empty?
      br
      @current_block << '&nbsp;'
      br
      return
    end

    # initial spaces also cause a break. §4.1
    # -- but don't break again unnecessarily (i.e. in nofill mode).
    # -- tabs don't count for this
    if line.start_with? ' '
      line.prepend("\\") # force this initial space to appear in the output
      br
    end

    # we actually want to do this in a better order than l->r
    # because of ar(4) [SunOS 5.5.1] :: [30-31]
    unescape(__unesc_w(__unesc_n(line)))

    if nofill?
      # this duplicates .br, but if that is guarded on nofill...
      @current_block << LineBreak.new(font: @current_block.terminal_font.dup,
                                      style: @current_block.terminal_text_style.dup)
    else
      space_adj
    end

    # reset no-space mode, which is only in effect for one output line
    rs if nospace?
    process_input_traps
  end

  ###
  ### requests / macros
  ###

  # TODO named strings can be invoked as macros! and vice versa!
  #   figure out how that works. quoting, breaking, these are odd

  def request(line)
    breaking = line.slice!(0) != @c2
    # one of the few places tabs and spaces are equivalent: between cc & req
    line.lstrip!
    req = line.slice(0, 2).rstrip
    argstr = line.slice(2..-1)&.lstrip || ''

    # until we bring back comments stripped in parse so .\" can work again:
    return if req.empty?

    if request?(req) and respond_to?(req) # it's not a macro and we haven't renamed it
      send req, __unesc_w(unescape(argstr, copymode: true)), breaking: breaking
    else
      args = getargs argstr
      @register['.$'].value = args.length
      send req, *args
    end
  rescue NoMethodError => e
    # it's some normal screwup; use the standard error reporting
    raise unless e.message.match(/^undefined method .+ for #<#{self.class}:/)

    # Control lines with unrecognized names are ignored. §1.1
    warn "Unrecognized request #{breaking ? @cc : @c2 }#{req.inspect} #{argstr}"
  end


end
