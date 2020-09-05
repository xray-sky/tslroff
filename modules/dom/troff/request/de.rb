# d3.rb
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
#                                           A macro may contain .de requests provided.
#                                           the terminating macros differ or the contained
#                                           definition terminator is concealed; ".." can
#                                           be concealed as "\\.." which will copy as
#                                           "\.." and be reread as "..".
#
# wow. this works. go ruby!
#
#    REVIEW does it work correctly with non-default delim?
#

module Troff
  def req_de(name, delim = '..', *)
    macro = @lines.collect_through do |l|
      @register['.c'].value += 1
      l.match(/^\.?#{Regexp.escape delim}/)
    end.collect do |l|
      unescape(l, :copymode => true)
    end
    # TODO this fails badly when the macro includes things that want to collect_through
    #      e.g. conditional input blocks (.if \{ \}) -- comb(1) [GL2-W2.5]
    define_singleton_method("req_#{name}") do |*args|
      macro[0..-2].each do |l|  # only args 0-9 allowed
        parse(l.gsub(/\$(\d)/) { args[$1.to_i - 1] })
      end
    end
  end

  def req_dot(*_args) ; end
end

