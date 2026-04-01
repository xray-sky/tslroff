# frozen_string_literal: true
#
# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#
# some escapes are processed before we ever do request parsing?!
# \* at least - what else?? what order?
#
# Multiple inter-word space characters found in the input are retained §4.1
# unescaped trailing spaces are not. (but not until output, .ds can define
# a string with as much trailing space as provided)
#
# see observations, at bottom
#

class Troff

  private

  def parse(l)
    if escapes?
      # copy mode expands \* and \n and strips comments.
      # looks like reading a line in copy mode is the first step of every parse
      #    .\*(xx  <== causes a macro name stored in xx to be invoked!
      line = unescape l, copymode: true

      # lines starting with \! are read in copy mode and transparently output
      # seemingly, with a break after
      if line.start_with? "#{@escape_character}!"
        warn "transparent throughput? #{line.inspect}"
        @current_block << line[2..-1]
        br
        return true
      end
    end

    line.start_with?(@cc, @c2) ? request(line) : output(line)
  end

  ###
  ### ordinary text
  ###

  def output(l)
    # unescaped trailing spaces are stripped
    line = l.sub(/((?<!#{@resc})#{@resc} )? *$/, '')

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
    unescape(__unesc_w(line))

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

  def request(l)
    breaking = l.slice!(0) != @c2
    # one of the few places tabs and spaces are equivalent: between cc & req
    l.lstrip!
    req = l[0..1].rstrip
    argstr = l[2..-1]&.lstrip || ''

    # until we bring back comments stripped in parse so .\" can work again:
    return if req.empty?

    if request?(req) and respond_to?(req)
      # it's not a macro and we haven't renamed it
      send req, __unesc_w(argstr), breaking: breaking
    else
      # macro - unescaped trailing spaces are stripped; getargs sets register .$
      args = getargs __unesc_w(argstr)
      send req, *args
    end
  rescue NoMethodError => e
    # it's some normal screwup; use the standard error reporting
    raise unless e.message.match(/^undefined method .+ for #<#{self.class}:/)

    # Control lines with unrecognized names are ignored. §1.1
    warn "Unrecognized request #{breaking ? @cc : @c2 }#{req} #{argstr}"
  end


end

=begin

observations:

   .ds yo .ab
   \*(yo
   nroff: User Abort; line 26, file <standard input>

   .de 99
   .ab
   ..
   .nr a 99
   .\na          # yes \n
   nroff: User Abort; line 15, file <standard input>

   \w'foo'
   .fl
   72
   .de 72
   .ab
   ..
   .\w'foo'      # not \w
   .nr a 72
   .ds n \\na
   .\*n          # so \* then \n
   nroff: User Abort; line 3, file <standard input>

trailing whitespace apparently stripped on output, not input.

   .ds yo "
   \*(yo foo.
   .fl
           foo.
   \w' '
   .fl
   24
   \w'\*(yo'
   .fl
   168
   .ds yo "       \" crud
   \w'\*(yo'
   .fl
   168

   \! foooo \" bar
   .fl
   foooo         # so comments go before transparent throughput even

\n and \* happen together, you can stack them either way

   .ds aa 99
   .nr 99 1 1
   \n+(\*(aa
   .fl
   2
   \n+(\*(aa
   .fl
   3
   .ds 11 foo
   .nr aa 11
   \*(\n(aa
   .fl
   foo
   .ds ab \w'foo'
   \*(ab
   .fl
   72
   .ds ac ab
   \*(\*(ac
   .fl
   72

\w also plays in this space - but is not interpreted in copy mode

   .nr 72 101
   \n(\w'foo'
   .fl
   101


=end
