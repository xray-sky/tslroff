# ev.rb
# -------------
#   troff
# -------------
#
#   §17
#
#   A Number of the parameters that control the text processing are gathered together
#   into an environment, which can be switched by the user. The environment parameters
#   are those associated with requests noting E in their Notes column; in addition,
#   partially collected lines and words are in the environment. Everything else is
#   global; examples are page-oriented parameters, number registers, and macro and
#   string definitions. All environments are initialized with default parameter values.
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .ev N    N=0      previous  -       Environment is switched to environment 0≤N≤2.
#                                     Switching is done in push-down fashion so that
#                                     restoring a previous environment must be done with
#                                     .ev rather than a specific reference.
#
# Requests affecting environment:
#  .ad (Adjust)
#  .c2 (No-break control character)
#  .cc (Basic control character)
#  .ce (Next lines centered)
#  .cu (Identical to .ul (troff))
#  .fi (Fill)
#  .ft (Font)
#  .hc (Hyphenation character)
#  .hy (Hyphenation mode)
#  .in (Indent)
#  .it (Input-line count trap)
#  .lc (Leader repetition character)
#  .ll (Line length)
#  .ls (Line spacing)
#  .lt (Length of title)
#  .mc (Margin character)
#  .na (No-adjust)
#  .nf (No-fill)
#  .nh (No-hyphenation mode)
#  .nm (Line numbering mode)
#  .nn (Next lines unnumbered)
#  .ps (Font point size)
#  .ss (Minimum word spacing)
#  .ta (Set tab stops)
#  .ti (Temporary indent)
#  .tc (Tab repetition character)
#  .ul (Switch to italic font (troff))
#  .vs (Vertical baseline spacing)
#
#      TODO - everything
#

module Troff
  # how is this different from .ab? just exit code?
  def req_ev(argstr = '', breaking: nil)
    warn ".ev wants to switch environments (#{argstr.inspect})‘"
  end
end

=begin
 [[ from the Troff Tutorial, CTIX Programmer's Ref ]]

As we mentioned, there is a potential problem when going across a page boundary:
parameters like size and font for a page title may well be different from those in
effect in the text when the page boundary occurs, troff provides a very general
way to deal with this and similar situations. There are three "environments", each
of which has independently settable versions of many of the parameters associated
with processing, including size, font, line and title lengths, fill/nofill mode,
tab stops, and even partially collected lines. Thus the titling problem may be
readily solved by processing the main text in one environment and titles in a
separate one with its own suitable parameters.

The command .ev n shifts to environment n; n must be 0, 1 or 2. The command .ev
with no argument returns to the previous environment. Environment names are
maintained in a stack, so calls for different environments may be nested and
unwound consistently.

Suppose we say that the main text is processed in environment 0, which is where
troff begins by default. Then we can modify the new page macro .NP to process
titles in environment 1 like this:

.4 TROFF Tutorial 8—27
.de NP
.ev 1 \ " shift to new environment
.It 6i \ " set parameters here
.ft R
.ps 10
... any other processing ...
.ev \ " return to previous environment

It is also possible to initialize the parameters for an environment outside the
.NP macro, but the version shown keeps all the processing in one place and is thus
easier to understand and change.
=end
