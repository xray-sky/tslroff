# el.rb
# -------------
#   troff
# -------------
#
#   conditional acceptance of input
#
#   §16
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .el anything  -       -           -      Else portion of if-else.
#

module Troff
  def req_el(*args)
    resc = Regexp.quote(@state[:escape_char])

=begin
    # multi-line input
    input = if args[0].sub!(/^#{esc}{/, '')
      @lines.collect_through do |line|
        @register['.c'].incr # TODO oops, this will go nuts if we have multiple collect_through (e.g., .de inside .if)
        line.sub!(/#{esc}}\s*$/, '')
      end
    else
      Array.new
    end

    # there's a strange case here if the first line of input is a command, since
    # the args have already been parsed.
    #
    # TODO: actually this is not good (q.v. req_if)
    #
    input.unshift(Troff.req?(args[0]) ? "#{args.shift} #{args.map { |arg| %("#{arg}") }.join(' ')}" : args.join(' '))
    if @state[:else]
      input.each { |line| parse(line) }
    end
=end

    argstr = args.shift.strip
    if argstr.sub!(/^#{resc}{/, '')
      loop do
        parse(argstr)
        argstr = next_line
        break if argstr.sub!(/#{resc}}$/, '')
      end #until argstr.sub!(/#{resc}}$/, '') somehow this never happens; looks like argstr outside of loop context isn't updating
    end
    parse(argstr)

  end
end
