# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#

module Troff

  def parse(line)

    if escapes?	# the escape mechanism may be disabled
      esc = @state[:escape_char]
      resc = Regexp.quote esc

      # hidden newlines -- REVIEW does this need to be any more sophisticated?
      # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
      # TODO the new-line at the end of a comment cannot be concealed.
      while line.end_with?(esc) and line[-2] != esc
        line.chop! << next_line
      end
      # Multiple inter-word space characters found in the input are retained except for
      # trailing spaces. §4.1
      line.rstrip! unless line.match(/#{resc}\s+$/)
      # lines starting with \! are read in copy mode and transparently output
      if line.sub!(/^#{resc}!/, '')
        warn "transparent throughput? #{line.inspect}"
        @output_block << unescape(line, copymode: true)
        @current_block.reset_output_indicator # REVIEW
        return true
      end
    end

    if line.match(/^([\.\'])\s*(\S[^\s\\]?)\s*(\S.*|$)/)
      (_, cmd, req, args) = Regexp.last_match.to_a
      begin
        # \", ie, and if do their own special-case arg parsing
        send("req_#{Troff.quote_method(req)}", *(%w(\" el ie if).include?(req) ? args : getargs(args)))
      rescue NoMethodError => e
        # Control lines with unrecognized names are ignored. §1.1
        if e.message.match(/^undefined method `req_/)
          warn "Unrecognized request #{line}"
        else
          # it's some other screwup; use the normal error reporting
          raise
        end
      end
    else
      # A blank text line causes a break and outputs a blank line
      # exactly like '.sp 1' §5.3 - also in nofill mode
      # TODO hm, I'm getting an extra .br (because of a space adjustment??) on consecutive blank text lines. - hesinfo(1) [AOS-4.3]

      if line.match(/^\s*$/)
        req_br
        @current_block << '&nbsp;'
        req_br
      end

      # initial spaces also cause a break. §4.1
      # -- but don't break again unnecessarily (i.e. in nofill mode).
      # -- REVIEW I think tabs don't count for this (...based on??)
      if line.start_with?(' ')
        line.prepend("\\")    # force this initial space to appear in the output
        req_br
      end

      # TODO
      # move eqn to prior to argparse since delims can appear in macro args
      # not doing it now because we'll need to remove unescape call from parse_eqn
      # to achieve it (have parse_eqn just return string, and have it work like an
      # actual preprocessor) and that'll lose me the .eqn class style that I want to
      # keep for now (it calls attention to text that's been sent through parse_eqn,
      # which is handy while developing). Gotta make it work during tbl too.
      # does that suggest we are putting it in next_line?? maybe we are making some
      # preprocessing methods to enable/disable/rewrite as needed.

      # eqn delims can be hidden by escaping them
      if @state[:eqn_start] and line.match?(/(?<!#{resc})#{resc}#{resc}#{Regexp.quote @state[:eqn_start]}|(?<!#{resc})#{Regexp.quote @state[:eqn_start]}/)
        parse_eqn line
      else
        unescape(__unesc_w(__unesc_n(line))) # we actually want to do this in a better order than l->r because of ar(4) [SunOS 5.5.1] :: [30-31]
      end

    end

    if @current_block.output_indicator?
      process_input_traps
      if nofill? and !@state[:break_suppress] # suppress break between tag & para in .TP, etc.
        @current_block << LineBreak.new	# this duplicates .br, but if that is guarded on nofill...
        @current_tabstop = @current_block.text.last
      else
        space_adj
      end
      # reset no-space mode, which is only in effect for one output line
      req_rs if nospace?
    end

    @state.delete(:break_suppress)
    @current_block.reset_output_indicator

  end
end
