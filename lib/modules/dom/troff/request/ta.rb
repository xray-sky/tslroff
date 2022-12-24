# ta.rb
# -------------
#   troff
# -------------
#
#   §9.1
#
# Request    Initial     If no     Notes   Explanation
#  form       value      argument
#
# .ta Nt ...  8n; 0.5in  none       E,m    t=R, right adjusting; t=C, centering;
#                                          t absent, left adjusting. tR tab stops are    ## -- tL ??
#                                          present every 0.5in; nroff every 8 nominal
#                                          character widths. The stop values are
#                                          separated by spaces, and a value preceeded
#                                          by + is treated as an increment to the
#                                          previous stop value.
#
# The ASCII horizontal tab character and the ASCII SOH (hereinafter known as the leader
# character) can both be used to generate either horizontal motion or a string of
# repeated characters. The length of the generated entity is governed by internal tab
# stops specifiable with .ta. The default difference is that tabs generate motion and
# leaders generate a string of periods; .tc and .lc offer the choice of repeated character
# or motion. There are three types of internal tab stops---left adjusting, right adjusting,
# and centering. in the following table D is the distance from the current position on
# the input line (where a tab or leader was found) to the next tab stop; next-string
# consists of the input characters following the tab (or leader) up to the next tab
# (or leader) or end of line, and W is the width of next-string
#
#     Tab    | Legnth of motion or |    Location of
#     type   | repeated characters |    next-string
#  ----------|---------------------|----------------------------
#     Left   |           D         | Following D
#    Right   |         D - W       | Right adjusted within D
#   Centered |       D - W / 2     | Centered on right end of D
#
# The length of generated motion is allowed to be negative, but that of a repeated
# character string cannot be. Repeated character strings contain an integer number of
# characters, and any residual distance is prepended as motion. Tabs or leaders found
# after the last tab are ignored, but may be used as next-string terminators.
#
# Tabs and leaders are not interpreted in copy-mode. \t and \a always generate a
# non-interpreted tab and leader respectively, and are equivalent to actual tabs and
# leaders in copy mode but are ignored during output mode.
#
#  REVIEW what happens when given not-an-N as arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
# TODO initialize properly
# TODO justifications (right/centered)
# TODO what really happens when you get
#        .ta 0.5i 1.0i 1.5i
#        \tfoo\tbar\t\tbaz
#      e.g. more tabs in input than currently defined - rwhod(1m) [GL2-W2.5]
#      nroff just piles everything in, with no whitespace between
# TODO are comma-separated tabs legit? they seem to not be unusual. but, see above re: more tabs?
#

module Troff
  def req_ta(argstr = '', breaking: nil)
    args = argstr.split
    @state[:tabs] = Array.new
    while args.any? do
      stop = args.shift
      stop.prepend("#{@state[:tabs].last || 0}u") if stop.start_with?('+')
      @state[:tabs].push(to_u(stop, default_unit: 'm').to_i)
    end
  end

  def init_ta
    @state[:tabs] = [ '0.5i', '1i', '1.5i', '2i', '2.5i', '3i', '3.5i', '4i',
                      '4.5i', '5i', '5.5i', '6i', '6.5i' ].collect { |t| to_u(t).to_i }
    true
  end
end
