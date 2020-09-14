# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#

module Troff

  def parse(line)

    if @state[:escape_char]		# the escape mechanism may be disabled
      # hidden newlines -- REVIEW: does this need to be any more sophisticated?
      # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
      while line.end_with?("#{@state[:escape_char]}\n") and line[-3] != @state[:escape_char]
        line.chop!.chop! << @lines.next.tap { @register['.c'].incr }
      end
      # Multiple inter-word space characters found in the input are retained except for
      # trailing spaces. §4.1
      line.rstrip! unless line.match(/#{Regexp.quote(@state[:escape_char])}\s+$/)
    end

    if line.match(/^([\.\'])\s*(\S[^\s\\]?)\s*(\S.*|$)/)
      (_, cmd, req, args) = Regexp.last_match.to_a
      begin
        send("req_#{Troff.quote_method(req)}", *getargs(args))
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
      # TODO: hm, I'm getting an extra .br (because of a space adjustment??) on consecutive blank text lines. - hesinfo(1) [AOS-4.3]

      if line.match(/^\s*$/)
        req_br
        @current_block << '&nbsp;'
        req_br
      end

      # initial spaces also cause a break. §4.1
      # -- but don't break again unnecessarily (i.e. in nofill mode).
      # -- REVIEW: I think tabs don't count for this (...based on??)
      if line.start_with?(' ')
        line.prepend("\\")    # force this initial space to appear in the output
        req_br
      end

      if @state[:eqn_start] and line.include?(@state[:eqn_start])
        parse_eqn(line)
      else
        unescape(line)
      end

    end

    if @current_block.output_indicator?
      process_input_traps
      if nofill?
        @current_block << LineBreak.new	# this duplicates .br, but if that is guarded on nofill...
        @current_tabstop = @current_block.text.last
      else
        space_adj
      end
      # reset no-space mode, which is only in effect for one output line
      req_rs if nospace?
    end

    @current_block.reset_output_indicator

  end
end
