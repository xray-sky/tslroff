# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
# Requires .HLB/.TLB library files be pre-processed into .HLP/.TXT with LIBRARY/EXTRACT=*
#
# TODO
#   do straight text (e.g. release_notes)
#   page titles
#   do the HTML properly, with Block and Text objects
# √ detect anchor links
# √ insert command/qualifier links
#   do better link sidebars than just "related"
#    -- maybe also include a grey subhead for section names, under which the anchors are linked?
# √ observe whether there are any tabs to obey (or is it all spaces)
#    -- there are. as long as we are deferring to ::Nroff, it's fine.
#   interaction between various level headings and Block::Nroff indent (~around <h4> is when it gets "bad")
# √ review HELP RUNOFF (4.4) to understand how the qualifiers are presented
#    -- we've got RUNOFF, RUNOFF/CONTENTS, and RUNOFF/INDEX, plus the qualifiers for RUNOFF itself
#    -- at the top level, maybe it should be part of Commands (like MAIL/EDIT) ?
#        -- this might be helplib specific, in that case.
# √ Commands linked at level 1 of command page (edfhlp.hlb/invoke.html) are not linked as anchors
#   Some mixed-case level-1 sections should probably be done as "commands" (e.g. DECthreads, RTL Routines, System Services, NewFeatures...)
#   RUNOFF has two major sections, each with /PAGE_NUMBERS qualifiers - only the first anchor works
#    -- try to put section breadcrumbs in anchors, maybe
#   maybe try to detect monospace vs. paragraph, table, example, external links (if there are any?)
#   maybe try to detect in-text links (e.g. "See the SET command for [...]")
# √ ANSI escapes (e.g. tpuhelp.hlb; [7m in aclhelp.hlb) - log/report on usage
#      [m / [0m - clear		[1m - bold		[2m - low intensity		[4m - bold
#      [5m - blink			[7m - reverse	[8m - invisible
# √ box drawing w/typebox? (e.g. tpuhelp.hlb)
#   translate filenames with % (e.g. debug/$label)
#   Forking is a problem:
#    - fork overhead becomes extremely high (like 1-2m if run in isolation, becomes 15-20m deep into a world build - webdriver cache size?)
#    - with fully populated webdriver cache, still getting chrome activity?? -- fork-local caches are getting lost
#
# REVIEW whether the µVMS 4.6 RUNOFF help refs actually cut out the extra parameter text (/FOO[=bar])
#

require_relative 'source'
require_relative 'nroff'
require_relative 'help'

module VMS
  class Manual < Manual

    def initialize(file, **kwargs)
      kwargs[:document_class] = Help if File.basename(file).end_with?('hlp', 'txt') # extracted .hlb, .tlb
      super(file, **kwargs)
    end

  end
end
