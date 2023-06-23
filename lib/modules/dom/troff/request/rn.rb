# rn.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
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
#

module Troff
  def req_rn(argstr = '', breaking: nil)
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
    oldmethod = "req_#{oldname}" if Requests.include? oldname

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
end

