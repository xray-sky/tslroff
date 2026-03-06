# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX R4.11 Version Overrides
#

class DG_UX::R4_11
  class Nroff < ::DG_UX::Nroff

    def initialize(source)
      # REVIEW encoding -> can it be done better now?
      source.lines.collect! { |l| l.force_encoding(Encoding::ISO_8859_1).encode!(Encoding::UTF_8) }

      case source.file
      when /^(?:contents|index)\d?\.(?:B2|C2|dgux|failover|nfs|onc|sdk|tcpip|X11)/
        raise ManualIsBlacklisted, 'is metadata'
      end

      super(source)

      @lines_per_page = nil
    end

  end
end


