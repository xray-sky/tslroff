# de.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .de xx yy     -         yy=..     -       Define or redefine the macro xx. The contents
#                                           of the macro begin on the next line. Input
#                                           lines are copied in copy mode until the
#                                           definition is terminated by a line beginning
#                                           with .yy, whereupon the macro yy is called.
#                                           In the absence of yy, the definition is
#                                           terminated by a line beginning with "..".
#                                           A macro may contain .de requests provided
#                                           the terminating macros differ or the contained
#                                           definition terminator is concealed; ".." can
#                                           be concealed as "\\.." which will copy as
#                                           "\.." and be reread as "..".
#
# .am xx yy     -         yy=..     -       Append to macro (append version of .de)
#
#
#   TODO  Request, macro, and string names share the same name list.
#         Macro and string names may be one or two characters long and may
#         usurp previously defined request, macro, or string names. Any
#         of these entities may be renamed with .rn or removed with .rm
#
#   Arguments are copied in copy mode onto a stack were they are available for reference.
#
#
# wow. this works. go ruby!
#
# NOTE: despite the description, the default macro is a single dot. ('yy=.')
#       explicitly setting 'yy=..' results in a terminating macro of '...'.
#       'yy=mm' equates to a terminating macro of '.mm'.
#
#       '. (break suppressed) is not a valid termination.
#
#    REVIEW does it work correctly with non-default delim?
#

module Troff
  def req_am(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr.slice!(0, 2).strip
    delim = argstr.sub(/^ */, '').slice(0, 2)
    delim = '.' if delim.empty?

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this?
    #warn ".de wants to change .#{name}!" if %w[CW EN EQ TS].include?(name)

    begin
      # find the old method - might be a request, or a macro
      oldmethod = name
      oldmethod = "req_#{name}" if Troff.requests.include? name

      savemethod = "#{oldmethod}#{@input_filename}#{@register['.c']}"
      define_singleton_method savemethod, method(oldmethod)

      macro = []
      loop do
        next_line
        break if @line == ".#{delim}"
        macro << unescape(@line, copymode: true)#.tap { |n| warn "sketchy use of .if/.ie with args in .am => #{n.inspect}" if n.match?(%r{^.\s*i[e].*\$[1-9]}) }
      end

      warn ".am appending #{macro.inspect} to .#{name} -- REVIEW"

      define_singleton_method(name) do |*args|
        send(savemethod, *args)
        macro.each do |l|  # only args 0-9 allowed
          parse l.gsub(/(\s*)#{Regexp.quote(@state[:escape_char])}\$(\d)/) {
            arg = args[$2.to_i - 1]
            (arg.nil? or arg.empty?) ? '' : $1+arg
          }
        end
      end
    rescue NameError # we didn't already have one to append to
      warn ".am couldn't find #{name} to append - delegating to .de"
      req_de "#{name} #{delim}", breaking: nil
    end
  end

  def req_de(argstr = '', breaking: nil)

    (name, delim) = argstr.split
    return nil unless name
    delim ||= '.'

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this?
    warn ".de wants to change .#{name}!" if %w[CW EN EQ TS].include?(name)

    # termination doesn't appear work like a macro invocation
    #terminating_method = "req_#{Troff.quote_method delim}"
    #define_singleton_method(terminating_method) { |*_args| true }

    macro = []
    loop do
      next_line
      break if @line == ".#{delim}" # not just .start_with!
      macro << unescape(@line, copymode: true)#.tap { |n| warn "sketchy use of .if/.ie with args in .de => #{n.inspect}" if n.match?(%r{^.\s*i[e].*\$[1-9]}) } # REVIEW seems fine based on monop(6) [SunOS 1.0]
    end

    # somehow troff is able to determine, given something like
    #
    #    .de C                  \" from macros/vxfs.an [HPUX 10.20]
    #    .ft CW
    #    \&\\$1 \\$2 \\$3 \\$4 \\$5 \\$6\fR
    #    ..
    #
    # not to spit out the extra spaces before arguments that haven't been passed, or are empty
    # (doesn't matter if there's one, or more -- it's only kept if there are enough args to follow)
    # which we are doing (ugh) and then unescape is preserving them as &nbsp;s
    #
    # revealing: I _did_ get extra spaces when I had a typo, '\&\\$1 \\$2 \\$3 \\$4 \\%5 \\$6\fR'
    #            this method is not bug compatible with that. REVIEW do I care?
    #
    # unrelated:
    # I need next_line to give the next line of the definition, in case of .if \{ \}
    # (as performed extensively by the osf macros).

    define_singleton_method(name) do |*args|
      olines = @lines
      ofile = @input_filename.dup
      opos = @register['.c'].dup
      odol = @register['.$'].dup
      @register['.$'] = Register.new(args.count, nil, :ro => true)
      @register['.c'] = Register.new(0, 1, :ro => true)
      @input_filename << " [#{opos}] => #{__callee__}"
      @lines = macro.each

      loop do
        begin
          parse next_line.gsub(/(\s*)#{Regexp.quote(@state[:escape_char])}\$(\d)/) {
            arg = args[$2.to_i - 1]
            (arg.nil? or arg.empty?) ? '' : $1+arg
          }#.tap { |n| warn "parsing #{n.inspect}" }
        rescue StopIteration
          break
        end
      end

      @lines = olines
      @input_filename = ofile
      @register['.$'] = odol
      @register['.c'] = opos

    end
  end

end

