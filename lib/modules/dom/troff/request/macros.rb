# frozen_string_literal: true
#
# rm.rb
# -------------
#   troff
# -------------
#
#   remove request, macro, or string
#
#   §7.5
#
#
#   TODO  Request, macro, and string names share the same name list.
#         Macro and string names may be one or two characters long and may
#         usurp previously defined request, macro, or string names. Any
#         of these entities may be renamed with .rn or removed with .rm
#

class Troff
  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .am xx yy     -         yy=..     -       Append to macro (append version of .de)

  def am(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr[0..1].rstrip
    delim = argstr[2..-1].sub(/^ */, '')[0..1]
    delim = '.' if delim.empty?

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this? => yes.
    # this is more or less working, except for catching the exceptions (e.g. EndOfTbl)
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
          parse l.gsub(/(\s*)#{Regexp.quote(@escape_character)}\$(\d)/) {
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

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .as xx string  ignored  -         -       Append string to xx (append version of .ds)
  #
  #  .as can be used on a string that doesn't already exist.
  #  Undefined strings (or ones that have been .rm'ed) output as blank.

  def as(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr[0..1].rstrip
    defstr = argstr[2..-1].sub(/^ *"?/, '') # don't lstrip, a leading tab is preserved

    @named_strings[name] ||= String.new
    @named_strings[name] << defstr
    #warn "appended to named string #{name.inspect}: #{@named_strings[name].inspect}"
  end

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
  #       explicitly setting 'yy=..' results in a terminating macro of '...'.
  #       'yy=mm' equates to a terminating macro of '.mm'.
  #
  #       '. (break suppressed) is not a valid termination.
  #
  #    REVIEW does it work correctly with non-default delim?

  def de(argstr = '', breaking: nil)

    (name, delim) = argstr.split
    return nil unless name
    delim ||= '.'

    # .EQ/.EN and I think .CW can be defined as macros _in addition_
    # to their meanings to the preprocessor. REVIEW is someone doing this?
    warn ".de wants to change .#{name}!" if %w[CW EN EQ TS].include?(name)

    macro = []
    loop do
      next_line
      break if @line == ".#{delim}" # not just .start_with!
      macro << unescape(@line, copymode: true) #.tap { |n| warn ".de read #{n.inspect}" } # REVIEW seems fine based on monop(6) [SunOS 1.0]
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
      opfx = @warn_prefix
      @warn_prefix = "#{@warn_prefix}#{file} [#{line_number}]: .#{name}"

      osrc = @source
      opos = @register['.c'].dup
      odol = @register['.$'].dup

      @register['.$'] = Register.new(args.count, nil, :ro => true)
      @register['.c'] = Register.new(0, 1, :ro => true)
      @source = Source.new(nil, magic: :Troff) do
        macro.collect do |l|
          # fix args in full macro before parsing, otherwise block conditionals don't get
          # args (they do their own next_line parse loop)
          # TODO REVIEW rcsfile.5:182 [DU 3.2c] does .de with escapes disabled??
          l.gsub(/(\s*)#{Regexp.quote(@escape_character || '')}\$([1-9])/) do
              arg = args[$2.to_i - 1]
              (arg.nil? or arg.empty?) ? '' : $1 + arg
          end
        end
      end

      loop do
        begin
          parse next_line
        rescue StopIteration
          break
        end
      end

      @register['.c'] = opos
      @register['.$'] = odol
      @source = osrc
      @warn_prefix = opfx
    end
    #warn ".de defined #{name}"
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .ds xx string  ignored  -         -       Define a string 'xx' containing 'string'.
  #                                           Any initial double-quote in 'string' is
  #                                           stripped off to permit initial blanks.
  #
  #
  #  groff ignores invalid names (e.g. '.ds xxfoobar crap' will define nothing)
  #  troff just takes the first two characters as the request name (above will define 'xx' as 'foobar crap')
  #  REVIEW will we ever need to accomodate this?

  def ds(argstr = '', breaking: nil)
    return nil if argstr.empty?
    name = argstr[0..1].rstrip
    defstr = argstr[2..-1].sub(/^ *"?/, '') # don't lstrip, a leading tab is preserved

    @named_strings[name] = defstr
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
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

  def rm(argstr = '', *args, breaking: nil)
    return nil if argstr.empty?
    arg = argstr[0..1].strip
    @named_strings.delete(arg) or instance_eval("undef #{arg.to_sym.inspect}") # REVIEW need to update Requests?
    rescue NameError
      warn "attempt to .rm undefined macro #{arg}"
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .rn xx yy     -         ignored   -       Rename request, macro, or string xx to yy.
  #                                           If yy exists, it is first removed.
  #
  #   TODO  Request, macro, and string names share the same name list.
  #         Macro and string names may be one or two characters long and may
  #         usurp previously defined request, macro, or string names. Any
  #         of these entities may be renamed with .rn or removed with .rm

  def rn(argstr = '', breaking: nil)
    oldname = argstr[0..1].strip
    newname = argstr[2..-1].lstrip[0..1]
    return nil if oldname.empty? or newname.empty?

    # since we don't share the same namelist...
    if @named_strings.key? oldname
      warn ".rn renaming string #{oldname.inspect} as #{newname.inspect}"
      @named_strings[newname] = @named_strings[oldname]
      @named_strings.delete oldname
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
    @named_strings = {
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}",
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      '.T' => 'html'   # name of output device
    }
    @named_strings.default_proc = proc { |_h, k| warn "\* : undefined named string #{k.inspect}" ; '' }
    true
  end

end
