# ds.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ds xx string  ignored  -         -       Define a string 'xx' containing 'string'.
#                                           Any initial double-quote in 'string' is
#                                           stripped off to permit initial blanks.
#
#
# TODO: §7.2 Copy mode input interpretation
#            During the definition and extension of strings and macros, the input is
#            read in copy mode. The input is copied without interpretation except that
#            * the contents of number registers, indicated by '\n', are substituted.
#            * Strings, indicated by '\*x' and '\*(xx', are read into the text.
#            * Arguments indicated by '\$' are replaced by the appropriate values at
#              the current macro level.
#            * Concealed new-lines indicated by '\(new-line)' are eliminated.
#            * Comments indicated by '\"' are eliminated.
#            * '\t' and '\a' are interpreted as ASCII horizontal tab and SOH respectively.
#            * \\ is interpreted as \.
#            * \. is interpreted as ".".
#            These interpretations can be suppressed by prepending a \. For example,
#            since \\ maps into a \, '\\n' will copy as '\n' which will be interpreted
#            as a number register indicator when the macro or string is reread.
#

module Troff
  def req_ds(args)
    @state[:named_string][args.shift] = cm_unescape(args.join(' ').sub(/^"/, ''))
  end

  def init_ds
    {
      '.T' => 'html'   # name of output device
    }
  end
end