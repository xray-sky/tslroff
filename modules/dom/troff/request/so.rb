# so.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .so file      -         -         -       Switch source file. The top input (file reading)
#                                           level is switched to file. When the new file
#                                           ends, input is again taken from the original
#                                           file; .so's may be nested. Note that file should
#                                           be preprocessed, if necessary, before being
#                                           called by .so. eqn, tbl, pic, and grap will
#                                           not reach through .sos to process an object
#                                           file. Once a .so is encountered, the processing
#                                           of file is immediate. Processing of the original
#                                           file (e.g., a macro that is still active) is
#                                           suspended.
#

module Troff
  def req_so(name)
    # TODO only works with paths relative to pwd. Some systems include absolute
    # path references to .so; these will have to be rewritten somehow.
    # e.g. AOS-4.3 includes /usr/athena/etc/tmac.h
    ofile = @lines
    (warn ".so can't read ./#{name}" ; return nil) unless File.readable?("./#{name}")
    @lines = File.read("./#{name}").lines.each   # force relative path TODO path translation
    loop do
      begin
        l = @lines.tap { @register['.c'].value += 1 }.next
        parse(l)
      rescue StopIteration
        break
      end
    end
    @lines = ofile
  end
end
