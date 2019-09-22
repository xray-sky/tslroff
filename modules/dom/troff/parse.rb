# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#

module Troff

  def parse(line)
    # Multiple inter-word space characters found in the input are retained except for
    # trailing spaces. §4.1
    line.rstrip!
    if line.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (_, cmd, req, args) = Regexp.last_match.to_a
      warn "bare tab in #{cmd}#{req} args (#{args.inspect})" if args.include?("\t") and req != '\"'
      begin
        send("req_#{Troff.quote_method(req)}", *getargs(args))
        # troff considers a macro line to be an input text line
        space_adj if Troff.macro?(req)
      rescue NoMethodError => e
        # Control lines with unrecognized names are ignored. §1.1
        if e.message.match(/^undefined method `req_/)
          warn "Unrecognized request in line #{@register['.c'].value}: #{line}"
        else
          # it's some other screwup; use the normal error reporting
          warn "in line #{@register['.c'].value}: #{line.inspect}:"
          warn e
          warn e.backtrace
        end
      end
    else
      # A blank text line causes a break and outputs a blank line
      # exactly like '.sp 1' §5.3
      if line.empty? && @current_block.type != :cell
        req_br unless broke?
        req_br
      end

      # initial spaces also cause a break. §4.1
      # -- but don't break again unnecessarily.
      # -- REVIEW: I think tabs don't count for this
      if line.start_with?(' ')
        # REVIEW: these initial spaces are probably also supposed to appear in the output
        line.prepend("\\")    # force this initial space to appear in the output
        req_br if fill? && !broke? && @current_block.type != :cell
      end

      warn "bare tab in input (#{line.inspect})" if line.include?("\t")
      unescape(line)
      space_adj
      req_br if nofill? && !broke? && @current_block.type != :cell
      process_input_traps
    end

    # REVIEW: this break might also need to happen during macro processing
    # TODO: I'm getting extra breaks in .nf -- [GL2-W2.5] acct.4
    #req_br unless fill? || broke? || cmd == "'"
  end

end
