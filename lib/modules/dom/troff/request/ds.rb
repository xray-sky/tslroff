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
# .as xx string  ignored  -         -       Append string to xx (append version of .ds)
#
#
#  .as can be used on a string that doesn't already exist.
#  Undefined strings (or ones that have been .rm'ed) output as blank.
#
#  groff ignores invalid names (e.g. '.ds xxfoobar crap' will define nothing)
#  troff just takes the first two characters as the request name (above will define 'xx' as 'foobar crap')
#  REVIEW will we ever need to accomodate this?
#

module Troff
  def req_as(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr.slice!(0, 2).rstrip
    defstr = argstr.sub(/^ *"?/, '') # a leading tab is preserved

    @state[:named_string][name] ||= String.new
    #@state[:named_string][name] << unescape(args.sub(/^"/, ''), :copymode => true)
    @state[:named_string][name] << defstr
    #warn "appended to named string #{name.inspect}: #{@state[:named_string][name].inspect}"
  end

  def req_ds(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr.slice!(0, 2).rstrip
    defstr = argstr.sub(/^ *"?/, '') # a leading tab is preserved

    #@state[:named_string][name] = unescape(defstr.sub(/^"/, ''), copymode: true)
    @state[:named_string][name] = defstr
    #warn "defined string #{name} as #{@state[:named_string][name].inspect}" if name.start_with? '%'
  end

  def init_ds
    @state[:named_string] = {
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}",
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      '.T' => 'html'   # name of output device
    }
    true
  end
end
