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
=begin
 no bueno now we're not running in pwd
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
=end

    # make this relative by trying to find file working backward
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

    ofile = @lines
    @lines = File.read(localfile).lines.each
    loop do
      begin
        parse(next_line)
      rescue StopIteration
        break
      end
    end
    @lines = ofile
  end

=begin
  def init_so
    @state[:path_translations] = Hash.new
    true
  end
=end
end
