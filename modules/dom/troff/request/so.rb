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
    localfile = './' + name    # force relative path
    unless File.readable?(localfile)
      @state[:path_translations].each do |path, xlate|
        break if localfile.sub!(path, xlate) and File.readable?(localfile)
      end
    end
    unless File.readable?(localfile)
      warn ".so can't read #{localfile}"
      return nil
    end

    ofile = @lines
    @lines = File.read(localfile).lines.each
    loop do
      begin
        l = @lines.tap { @register['.c'].incr }.next
        parse(l)
      rescue StopIteration
        break
      end
    end
    @lines = ofile
  end

  def init_so
    @state[:path_translations] = Hash.new
    true
  end
end
