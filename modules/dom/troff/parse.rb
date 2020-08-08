# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#

module Troff

  def parse(line)

    #outpos = @current_block.text.last

    # hidden newlines -- REVIEW: does this need to be any more sophisticated?
    while line.end_with?("#{@state[:escape_char]}\n")
      line.chop!.chop! << @lines.next
    end

    # Multiple inter-word space characters found in the input are retained except for
    # trailing spaces. §4.1
    line.rstrip! unless line.end_with?("#{@state[:escape_char]} ")

    if line.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (_, cmd, req, args) = Regexp.last_match.to_a
      #warn "bare tab in #{cmd}#{req} args (#{args.inspect})" if args.include?("\t") and req != '\"'
      begin
        send("req_#{Troff.quote_method(req)}", *getargs(args))
        # troff considers a macro line to be an input text line
        space_adj if Troff.macro?(req) and @current_block.output_indicator?
      rescue NoMethodError => e
        # Control lines with unrecognized names are ignored. §1.1
        if e.message.match(/^undefined method `req_/)
          warn "Unrecognized request in line #{input_line_number}: #{line}"
        else
          # it's some other screwup; use the normal error reporting
          warn "in line #{input_line_number}: #{line.inspect}:"
          warn e
          warn e.backtrace
        end
      end
    else
      # A blank text line causes a break and outputs a blank line
      # exactly like '.sp 1' §5.3
      if line.empty? and !nofill?
        req_br unless broke?
        req_br
      end

      # initial spaces also cause a break. §4.1
      # -- but don't break again unnecessarily (i.e. in nofill mode).
      # -- REVIEW: I think tabs don't count for this (...based on??)
      if line.start_with?(' ')
        line.prepend("\\")    # force this initial space to appear in the output
        req_br if fill? && !broke?
      end

      #warn "bare tab in input (#{line.inspect})" if line.include?("\t")
      unescape(line)
      space_adj
      req_br if nofill?# && !broke?
    end

    # REVIEW: this break might also need to happen during macro processing
    # TODO: I'm getting extra breaks in .nf -- [GL2-W2.5] acct.4
    #req_br unless fill? || broke? || cmd == "'"

    # did we output any text? - TODO probably this is totally insufficient
    #unless @current_block.text.last == outpos
    #  process_input_traps
    #  req_rs
    #end
    # --- why was req_rs in there?? what's that got to do with input traps?
#warn "#{@current_block.output_indicator?.inspect} from #{line.inspect}"
#    process_input_traps if @current_block.output_indicator?
#warn "reset?"
#    @current_block.reset_output_indicator
  end

end
