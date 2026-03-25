# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# TODO do something productive with a symlink
# i.e. generate equivalent output link
#

# zlib can't deal with old school UNIX compression. just gzip.
#require "zlib"

FileIsEmptyError = Class.new(RuntimeError)
FileIsLinkError  = Class.new(RuntimeError)

class File
  def self.magic(file)
    #raise FileIsLinkError, self.readlink(file) if self.symlink?(file)

    case IO.read(file, 2)
    when nil        then raise FileIsEmptyError
    # this is any file that starts with "NE" - no good for nroff e.g. 'NETSTAT(1)'
    # probably going to have to special-case A/UX 3.0.1 AutoLogin.4.Z in this event.
    # fortunately, haven't run into any other tar files
    #when "\116\105" then 'tar'	# tape archive (pre-POSIX) - this is not a tar magic number, but matches Autologin.4.Z [A/UX 3.0.1]
    when "\037\036" then 'pack'	    # pack/huffman
    when "\037\037" then 'oldpack'  # pack/huffman, old
    when "\037\213" then 'gzip'	    # gzip
    when "\037\235" then 'compress' # compress
    when "\037\240" then 'lzh_sco'	# SCO LZH - use 10.6 gzip; dropped from gzip in newer OS X
    else                 'text'
    end
  end
end


