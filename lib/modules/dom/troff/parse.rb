# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#

module Troff

  # TODO named strings can be invoked as macros! and vice versa!
  #   figure out how that works. quoting, breaking, these are odd

  def request(req, argstr, breaking: true)
    if Requests.include? req and respond_to?("req_#{req}") # it's not a macro and we haven't renamed it
      send "req_#{req}", __unesc_w(unescape(argstr, copymode: true)), breaking: breaking
    else
      send req, *(getargs argstr)
      # REVIEW necessary?
      #@register['.$'].value = 0
    end
    rescue NoMethodError => e
      # Control lines with unrecognized names are ignored. §1.1
      if e.message.match(/^undefined method .+ for #<Manual:/)
        warn "Unrecognized request .#{req} #{argstr}"
      else
        # it's some other screwup; use the normal error reporting
        raise
      end
  end

  def parse(line)
    if escapes?	# the escape mechanism may be disabled
      esc = @state[:escape_char]
      resc = Regexp.quote esc

      # hidden newlines -- REVIEW does this need to be any more sophisticated?
      # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
      # TODO the new-line at the end of a comment cannot be concealed.
      #while line.end_with?(esc) and line[-2] != esc
      #  line.chop! << next_line
      #end

      # Multiple inter-word space characters found in the input are retained except for
      # trailing spaces. §4.1
      # REVIEW this algorithm is suspect; '\ \    ' should still rstrip some spaces.
      line.rstrip! unless line.match(/#{resc} +$/)
      # lines starting with \! are read in copy mode and transparently output
      if line.sub!(/^#{resc}!/, '')
        warn "transparent throughput? #{line.inspect}"
        # @output_block?? what was I thinking, there
        #@output_block << unescape(line, copymode: true)
        @current_block << unescape(line, copymode: true)
        #@current_block.reset_output_indicator # REVIEW
        return true
      end
    end

    if line.start_with? @state[:cc]
      line.slice!(0)
      line.lstrip! # one of the few places tabs equally valid
      request line.slice(0, 2).rstrip, (line.slice(2..-1) || '').sub(/\s*(?<!#{resc})#{resc}".*$/, '').lstrip # nuke inline comments
    elsif line.start_with? @state[:c2]
      line.slice!(0)
      line.lstrip! # one of the few places tabs equally valid
      request line.slice(0, 2).rstrip, (line.slice(2..-1) || '').sub(/\s*(?<!#{resc})#{resc}".*$/, '').lstrip, breaking: false
    else
      # A blank text line causes a break and outputs a blank line
      # exactly like '.sp 1' §5.3 - also in nofill mode
      # a line with only spaces counts as a blank line. a tab does not.
      # TODO hm, I'm getting an extra .br (because of a space adjustment??) on consecutive blank text lines. - hesinfo(1) [AOS-4.3]

      # we should have already stripped any such spaces.
      #if line.match(/^ *$/)
      if line.empty?
        req_br
        @current_block << '&nbsp;'
        req_br
      else

        # initial spaces also cause a break. §4.1
        # -- but don't break again unnecessarily (i.e. in nofill mode).
        # -- tabs don't count for this
        if line.start_with?(' ')
          line.prepend("\\")    # force this initial space to appear in the output
          req_br
        end

        unescape(__unesc_w(__unesc_n(line))) # we actually want to do this in a better order than l->r because of ar(4) [SunOS 5.5.1] :: [30-31]

        if nofill?# and !@state[:break_suppress] # suppress break between tag & para in .TP, etc. in nofill mode - see prtdiag(1m) [SunOS 5.5.1]
          @current_block << LineBreak.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup) # this duplicates .br, but if that is guarded on nofill...
        else
          #@state.delete(:break_suppress)
          space_adj
        end

        # reset no-space mode, which is only in effect for one output line
        req_rs if nospace?

        process_input_traps

      end
    end
  end
end
