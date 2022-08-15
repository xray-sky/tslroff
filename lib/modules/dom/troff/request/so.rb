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
    # make this relative by trying to find file working backward
    # NOTE this is relative _to the man page directory_ (@source_dir)
    # REVIEW will we ever see a non-absolute path here, that we could maybe use directly?
    file = File.basename name
    searchdir = ''
    path_components = File.dirname(name).split('/').reverse
    until File.readable?("#{@source_dir}/#{searchdir}#{file}") do
      return(nil).tap { warn ".so can't read #{name}" } if path_components.empty?
      searchdir = "#{path_components.shift}/#{searchdir}"
    end

    localfile = File.realpath("#{@source_dir}/#{searchdir}#{file}")

    # REVIEW this is a bit suspect; makes rewrites look ugly
    # might benefit from a full Manual.new & subsequent merge? maybe.

    olines = @lines
    ofile = @input_filename.dup
    opos = @register['.c'].dup
    @input_filename << " => #{file}"
    @register['.c'] = Register.new(0, 1, :ro => true)
    newsrc = File.read(localfile).lines
    newsrc = yield newsrc if block_given? # give a chance to perform processing on the sourced file
    @lines = newsrc.each

    loop do
      begin
        parse(next_line)
      rescue StopIteration
        break
      end
    end

    @lines = olines
    @input_filename = ofile
    @register['.c'] = opos
  end
end
