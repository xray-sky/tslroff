# rm.rb
# -------------
#   troff
# -------------
#
#   remove request, macro, or string
#
#   §7.5
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

module Troff

  def req_rm(argstr = '', *args, breaking: nil)
    return nil if argstr.empty?
    arg = argstr.slice(0, 2).strip
    #@state[:named_string].delete(string) or define_singleton_method("req_#{string}") { |*args| true } # REVIEW instance_eval(':undef req_foo') instead?
    #warn arg.inspect
    @state[:named_string].delete(arg) or instance_eval("undef #{arg.to_sym.inspect}")
    rescue NameError
      warn "attempt to .rm undefined macro #{arg}"
  end

end
