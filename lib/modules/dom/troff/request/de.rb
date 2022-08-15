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
#       but '. (break suppressed) is not a valid termination.
#       explicitly setting 'yy=..' results in a terminating macro of '...'.
#       'yy=mm' equates to a terminating macro of '.mm'.
#
#    REVIEW does it work correctly with non-default delim?
#

module Troff
  def req_de(name, delim = '.', *) # REVIEW: why is this * here?

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this?
    warn ".de wants to change .#{name}!" if %w[CW EN EQ].include?(name)

    terminating_method = "req_#{Troff.quote_method delim}"
    define_singleton_method(terminating_method) { |*_args| true }

    macro = []
    loop do
      next_line
      break if @line.start_with? ".#{delim}"
      macro << unescape(@line, copymode: true).tap { |n| warn "sketchy use of .if/.ie with args in .de => #{n.inspect}" if n.match?(%r{^.\s*i[e].*\$[1-9]}) } # REVIEW seems fine based on monop(6) [SunOS 1.0]
    end

    define_singleton_method("req_#{name}") do |*args|
      macro.each do |l|  # only args 0-9 allowed
        parse(l.gsub(/#{Regexp.quote(@state[:escape_char])}\$(\d)/) { args[$1.to_i - 1] })
      end
    end

    parse(@line)
    singleton_class.send(:remove_method, terminating_method)
  end

end

