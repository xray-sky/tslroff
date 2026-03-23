# rm.rb
# -------------
#   troff
# -------------
#
#   remove request, macro, or string
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .am xx yy     -         yy=..     -       Append to macro (append version of .de)
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
# .as xx string  ignored  -         -       Append string to xx (append version of .ds)
#
# .ds xx string  ignored  -         -       Define a string 'xx' containing 'string'.
#                                           Any initial double-quote in 'string' is
#                                           stripped off to permit initial blanks.
#
#
#  .as can be used on a string that doesn't already exist.
#  Undefined strings (or ones that have been .rm'ed) output as blank.
#
#  groff ignores invalid names (e.g. '.ds xxfoobar crap' will define nothing)
#  troff just takes the first two characters as the request name (above will define 'xx' as 'foobar crap')
#  REVIEW will we ever need to accomodate this?
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
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
#  .rm xx     -     ignored   u       Remove request, macro, or string. The name xx is
#                                     removed from the name list and any related storage
#                                     is freed. Subsequent references will have no effect.
#
# We have separate namespaces for requests/macros and strings. In practice probably it
# doesn't matter, since troff input must assume they're the same namespace. Whatever
# we find, disable it.
#
#
#  REVIEW fpr.1 [AOS-4.3] what is even going on there?!
#
# .rn xx yy     -         ignored   -       Rename request, macro, or string xx to yy.
#                                           If yy exists, it is first removed.
#
#   TODO  Request, macro, and string names share the same name list.
#         Macro and string names may be one or two characters long and may
#         usurp previously defined request, macro, or string names. Any
#         of these entities may be renamed with .rn or removed with .rm
#

class Troff
  def as(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr.slice!(0, 2).rstrip
    defstr = argstr.sub(/^ *"?/, '') # a leading tab is preserved

    @state[:named_string][name] ||= String.new
    #@state[:named_string][name] << unescape(args.sub(/^"/, ''), :copymode => true)
    @state[:named_string][name] << defstr
    #warn "appended to named string #{name.inspect}: #{@state[:named_string][name].inspect}"
  end

  def ds(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr.slice!(0, 2).rstrip
    defstr = argstr.sub(/^ *"?/, '') # a leading tab is preserved

    #@state[:named_string][name] = unescape(defstr.sub(/^"/, ''), copymode: true)
    @state[:named_string][name] = defstr
    #warn "defined string #{name} as #{@state[:named_string][name].inspect}" if name.start_with? '%'
  end

  def am(argstr = '', breaking: nil)
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
      #oldmethod = name if REQUESTS.include? name

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
      de "#{name} #{delim}", breaking: nil
    end
  end

  def de(argstr = '', breaking: nil)

    (name, delim) = argstr.split
    return nil unless name
    delim ||= '.'

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this?
    warn ".de wants to change .#{name}!" if %w[CW EN EQ TS].include?(name)

    # termination doesn't appear work like a macro invocation
    #terminating_method = Troff.quote_method delim"
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
      #@input_filename << " [#{opos}] => #{__callee__}" # TODO make this work properly across class refactoring (finish separating input filename / output filename, class concern, etc.)
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

  def rm(argstr = '', *args, breaking: nil)
    return nil if argstr.empty?
    arg = argstr.slice(0, 2).strip
    #@state[:named_string].delete(string) or define_singleton_method(string) { |*args| true } # REVIEW instance_eval(':undef foo') instead?
    #warn arg.inspect
    @state[:named_string].delete(arg) or instance_eval("undef #{arg.to_sym.inspect}") # REVIEW need to update Requests?
    rescue NameError
      warn "attempt to .rm undefined macro #{arg}"
  end

  def rn(argstr = '', breaking: nil)
    oldname = argstr.slice!(0, 2).strip
    newname = argstr.lstrip!.slice(0, 2)
    return nil if oldname.empty? or newname.empty?

    # since we don't share the same namelist...
    if @state[:named_string][oldname]
      warn ".rn renaming string #{name.inspect} as #{newname.inspect}"
      @state[:named_string][newname] = @state[:named_string][oldname]
      @state[:named_string].delete oldname
      return true
    end

    # find the old method - might be a request, or a macro
    oldmethod = oldname
    #oldmethod = oldname if REQUESTS.include? oldname
    # TODO correctly update the Requests array

    if respond_to? oldmethod
      warn ".rn renaming request/macro #{oldname.inspect} as #{newname.inspect}"
      define_singleton_method newname, method(oldmethod)
      # if it's one of ours (not one we .defined at runtime), it's
      # not a singleton method, and removing it kills it entirely
      # instead, _pretend_ it's gone. parse rescues NoMethodError,
      # so the effect should be the same.
      #define_singleton_method(oldmethod) { |*_args| raise NoMethodError }
      # -- surprise (test this, it removes object singleton_methods;
      #    none of the other conventional wisdom about singleton_class.remove_method
      #    would work; the methods are instance_methods of the singleton_class that
      #    remove_method wouldn't touch) ALSO update .rm. or better, implement that
      #    and call it here
      instance_eval "undef #{oldmethod.to_sym.inspect}"
      return true
    end

    warn ".rn couldn't find #{oldname.inspect} to rename as #{newname.inspect}"
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
