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
    #macro = @lines.collect_through do |l|
    #  @register['.c'].incr
    #  l.match(/^\.#{Regexp.escape delim}/)
    #end.collect do |l|
    #  unescape(l, copymode: true)
    #end

    terminating_method = "req_#{Troff.quote_method delim}"
    define_singleton_method(terminating_method) { |*_args| true } #unless respond_to?(terminating_method) # REVIEW why does this unless always prevent the define?? -- uh oh, is it because we've implemented a "method missing"? ..we haven't?

    macro = []
    until @line.start_with? ".#{delim}" do
      macro << unescape(next_line, copymode: true).tap { |n| warn "sketchy use of .if/.ie with args in .de => #{n.inspect}" if n.match?(%r{^.\s*i[e].*\$[1-9]}) }
    end

    # TODO: this fails badly when the macro includes things that want to collect_through
    #       e.g. conditional input blocks (.if \{ \}) -- comb(1) [GL2-W2.5]
    define_singleton_method("req_#{name}") do |*args|
      macro.each do |l|  # only args 0-9 allowed
        parse(l.gsub(/#{Regexp.quote(@state[:escape_char])}\$(\d)/) { args[$1.to_i - 1] })
      end
    end

    parse(@line)
    singleton_class.send(:remove_method, terminating_method)
  end

  #def req_dot(*_args) ; end  ---- aaaaah hah. putting this here made it _not_ a singleton method. it was defined, but couldn't be removed with singleton_class.send
end

