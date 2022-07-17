# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/07/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Get a relative path from one file to another
# from and to must be absolute, or relative the same base directory.
#

class File
  def self.relative_path(from, to)
    tpath = File.dirname(to).split('/').reject { |p| p == '.' }
    fpath = File.dirname(from).split('/').reject { |p| p == '.' || p == tpath[0] and tpath.shift }.map { |p| '..' }
    fpath << tpath if tpath.any?
    fpath.any? ? "#{fpath.join('/')}/#{File.basename(to)}" : File.basename(to)
  end
end


