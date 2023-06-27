# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Get the magic number of the input file
#


# zlib can't deal with old school UNIX compression. just gzip.
#require "zlib"

# TODO do something productive with a symlink
# i.e. generate equivalent output link

FileIsEmptyError = Class.new(RuntimeError)
FileIsLinkError  = Class.new(RuntimeError)

class File
  def self.magic(file)
    #raise FileIsLinkError, self.readlink(file) if self.symlink?(file)

    case IO.read(file, 2)
    when nil         then raise FileIsEmptyError
    # this is any file that starts with "NE" - no good for nroff e.g. 'NETSTAT(1)'
    # probably going to have to special-case A/UX 3.0.1 AutoLogin.4.Z in this event.
    # fortunately, haven't run into any other tar files
    #when "\116\105" then 'tar'	# tape archive (pre-POSIX) - this is not a tar magic number, but matches Autologin.4.Z [A/UX 3.0.1]
    when "\037\036" then 'gz'	# pack/huffman
    when "\037\037" then 'gz'	# pack/huffman, old
    when "\037\213" then 'gz'	# gzip
    when "\037\235" then 'gz'	# compress
    #when "\037\240" then 'gz'	# SCO LZH - osx gzip no longer understands
    when "\037\240" then 'ogz'	# SCO LZH - use 10.6 gzip in ~/Unix/bin
    else                 'text'
    end
  end
end


