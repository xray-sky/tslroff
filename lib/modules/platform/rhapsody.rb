# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/20/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Rhapsody Platform Overrides
#
# TODO
#   text encoding (see groff_mm*.7)
#   _actually_ using mdoc/doc-* macros. gadzooks. looks like all versions share the same macros though
#

module Rhapsody
  class Groff < Groff ; end
end
