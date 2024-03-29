# expressions.rb
# ---------------
#    Troff conversions and expressions
# ---------------
#
#   §1.3
#
#    basic units (u) - device specific (use pixels for html? - does it matter if I want to keep things in the output as ems?)
#    inches      (i) - 120u (120dpi?)
#    centimeters (c) - 50/127i
#    pica        (P) - 1/6i
#    em          (m) - size of font in points
#    en          (n) - 1/2m
#    point       (p) - 1/72i
#    vertical line space (v) - 6/5m (? - default v is 1.2em)
#
# in nroff, i is 240u; m == n == C (output device dependent; usually 1/10i or 1/12i)
#
#    Orientation    Default    Request or Function
#   --------------------------------------------------------------------------------
#    Horizontal        m       .ll, .in, .ti, .ta, .lt, .po, .mc, \h, \l
#
#    Vertical          v       .pl, .wh, .ch, .dt, .sp, .sv, .ne, .rt, \v, \x, \L
#
#    Register or       u       .nr, .if, .ie
#    conditional
#
#    Misc              p       .ps, .vs, \H, \s
#
#
# All other requests ignore any scale indications. When a number register containing
# an already appropriately scaled number is interpreted to provide numerical input,
# the unit scale indicator 'u' may need to be appended to prevent an additional
# inappropriate default scaling. The number, 'N', may be specified as a decimal fraction
# but the parameter finally stored is rounded to an integer number of basic units.
#
# TODO (necessary? possible?)
#
# The absolute position indicator | may be prepended to a number N to generate the
# distance to the vertical or horizontal place N. For vertically oriented requests and
# functions, |N becomes the distance in basic units from the current vertical place on the
# page or in a diversion to the vertical place N. (See section 7.4, "Diversions".) For
# all other requests and functions, |N becomes the distance from the current horizontal
# place on the input line to the horizontal place N.
#
# For example, .sp |3.2c will space in the required direction to 3.2 cm from the top of
# the page.
#
#   §1.4 Numerical Expressions
#
# Wherever numerical input is expected an expression involving parentheses, the arithmetic
# operators +, -, /, *, % (modulus), and the logical operators <, >, <=, >=, = (or ==),
# & (and), and : (or) may be used. Except where controlled by parentheses, evaluation of
# expressions is left-to-right. In the case of certain requests (TODO), an initial + or - is
# stripped and interpreted as an increment or decrememnt indicator respectively. In the
# presence of default scaling, the desired scale indicator must be attached to every
# number in an expression for which the desired and default scaling differ. For example,
# if the number register x contains 2 and the current point size is 10, then
#
#    .ll (4.25i+\nxP+3)/2u
#
# will set the line length to 1/2 the sum of 4.25 inches + 2 picas + 3 ems.
#
# The use of whitespace in arithmetic expressions is not permitted.
# nroff/troff expressions do not recognize decimal multipliers or divisors; a high
# level of precision may be achieved by mixing scales within expressions.
#

module Troff

  @@units_per_inch = 1200	# REVIEW: does this even matter?

  # str.to_s -- tolerate receiving integer/register argument

  def to_in(str)
    to_u(str.to_s).to_f / @@units_per_inch
  end

  def to_cm(str)
    to_u(str.to_s).to_f * 2.54 / @@units_per_inch
  end

  def to_pt(str)
    to_u(str.to_s).to_f * 72 / @@units_per_inch
  end

  def to_em(str)
    warn "absurd font size #{@register['.s']} converting units to em" if @register['.s'] < 1
    to_u(str.to_s).to_f * 72 / ( @@units_per_inch * @register['.s'] )
  end

  def to_u(str, default_unit: 'u')

    # troff issues a warning for any characters not allowed in a numeric expression
    # (like ',') and disregards everything after one. not sure what to return though
    # if the entire expression is disregarded. REVIEWED. zero? - yes.
    str.sub!(%r{[^-+()\d\.cimnPpuv/*%<>=&:].*$}, '') and warn "disregarding extra chars in numeric expression #{Regexp.last_match[0].inspect}"
    return '0' if str.empty? # everything was rejected as invalid

    # prepend '0u+' and treat '+-'/'--' (not valid in a troff expression) as '-'/'+'
    # in order to avoid having to differentiate between '-' as subtraction vs. negation
    str = str.prepend('0u') if str.match(/^[+-]/)
    str = str.gsub('+-', '-').gsub('--', '+').gsub('++', '+').gsub(/=-([\.\dcimnPpuv]+?)/, "=(-\\1)")

    # try to break down the expression
    # start with parens; work inside -> out
    while str.include?('(') do
      (a,b,c) = str.partition(')')
      (x,y,z) = a.rpartition('(')
      str.sub!(a + b, x + to_u(z, :default_unit => default_unit) + 'u')
    end

    # tokenize the result
    operands = str.scan(%r([\d\.cimnPpuv]+|[-+/*%<>=&:]+)) # TODO: somewhere in here I'm getting ==- as an operator (as in 10==-1 - end result works as it throws an exception and is rejected by if)

    # we need to be tolerant of garbage in - e.g. text passed as indent to .IP which may look a little like an expression
    # example - hpterm(1) [HPUX 10.20] line 733
    operand = operands.shift.match(/^([\d.]+)([cimnPpuv]?)/)
    return '0'.tap { warn "garbage in evaluating expression #{str.inspect}" } unless operand

    (magnitude, unit) = operand[1..2]
    unit = default_unit if unit.empty?

    lhs = case unit
    when 'u'  then magnitude.to_i
    when 'i'  then magnitude.to_f * @@units_per_inch
    when 'c'  then magnitude.to_f * @@units_per_inch * 50 / 127
    when 'P'  then magnitude.to_f * @@units_per_inch / 6
    when 'p'  then magnitude.to_f * @@units_per_inch / 72
    when 'm'  then magnitude.to_f * @register['.s'].to_f * @@units_per_inch / 72
    when 'n'  then magnitude.to_f * @register['.s'].to_f * @@units_per_inch / 144
    when 'v'  then magnitude.to_f * @register['.v'].to_f
    # non-Troff unit for use with Selenium results -- must be accessed with :default_unit
    when 'px' then magnitude.to_f * @@units_per_inch / @@pixels_per_inch
    end.to_i

    while operands.any?
      op = case o = operands.shift
           when '=' then '=='
           when ':' then '||'
           when '&' then '&&'
           else o
           end
      rhs = to_u(operands.shift, default_unit: default_unit).to_i
      # can't just send logical and/or - ruby doesn't have c-style numeric truth
      # also && and || are not methods!
      lhs = %w[|| &&].include?(op) ? eval("#{lhs > 0} #{op} #{rhs > 0}") : lhs.send(op, rhs)
      lhs = 1 if lhs == true
      lhs = 0 if lhs == false
    end

    lhs.to_s

  end

end
