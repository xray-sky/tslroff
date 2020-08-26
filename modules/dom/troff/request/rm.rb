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

  def req_rm(string = nil, *args)
    if string
      @state[:named_string].delete(string) or define_singleton_method("req_#{string}") { |*args| true } # REVIEW instance_eval(':undef req_foo') instead?
    end
  end

end
