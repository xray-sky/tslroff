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
