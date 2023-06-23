# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/20/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Rhapsody Platform Overrides
#
# TODO
#   _actually_ using mdoc/doc-* macros. gadzooks. looks like all versions share the same macros though
#

module Troff
  def self.useGroff?
    true
  end
end

module Rhapsody
  def self.extended(k)
  end
end
