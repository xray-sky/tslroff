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

# TODO: do something productive with a symlink
# i.e. generate equivalent output link

FileIsLinkError = Class.new(RuntimeError)

class File
  def self.magic(file)
    raise FileIsLinkError, self.readlink(file) if self.symlink?(file)

    case IO.read(file, 2)
    when nil         then raise ArgumentError, "Zero length file #{file}"
    when /^\116\105/ then 'tar'	# tape archive (pre-POSIX) - this is not a tar magic number, but matches Autologin.4.Z [A/UX 3.0.1]
    when /^\037\036/ then 'gz'	# pack/huffman
    when /^\037\037/ then 'gz'	# pack/huffman, old
    when /^\037\213/ then 'gz'	# gzip
    when /^\037\235/ then 'gz'	# compress
    when /^\037\240/ then 'gz'	# SCO LZH
    else                    'text'
    end
  end
end


