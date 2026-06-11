# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/7/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UC Berkeley 386BSD Platform Overrides
#
# TODO
#   magic (garbage in garbage out)
#   see also for "man1ext" (eqn, groff, grotty, etc.): not detecting, sections need repointed,
#      maybe we can skip linking to man[57]ext as we haven't these pages
#   all of the troff sources (local, x386)
#   what is going on with the XFree86 pages? also bison(1), others?
#   1.0 - cc(1) has page breaks
#
# REVIEW
#   are the section 0 pages even "enabled"? or were they moved there to "disable" them
#   is this for UCB 386BSD? or for Walnut Creek 386BSD?? I think the Nroff is for the latter;
#     the former seems to have Troff (Groff?)
#

module X386BSD
  class Troff < Troff::Man  # REVIEW probably actually Groff (e.g. groff_char(7))

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(?:[\dZz]\S?)$/, '')
      super(source, **kwargs)
    end

  end
end
