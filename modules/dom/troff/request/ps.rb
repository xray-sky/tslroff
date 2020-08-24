# ps.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ps ±N        10pt      previous  E       Point size set to ±N. Alternatively, embed
#                                           \sN or \s±N. Any positive size value may be
#                                           requested; if invalid, the nearest valid size
#                                           will result, with a maximum size to be
#                                           determined by the individual printing device.
#                                           A paired sequence +N, -N will work because the
#                                           previous value is also remembered.
#                                           Ignored in nroff.
#
#   our default font size is 12pt
#

module Troff
  def req_ps(ps = '0')
    ps = __unesc_nr(ps)     # REVIEW should this happen before method invoke? see also .nr
    size = case ps
    when '0'                then @register[:prev_ps].value
    when /^([-+])(\d{1,2})/ then @register['.s'].value.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
    else                    ps.to_i
    end

    @register[:prev_ps].value = @register['.s'].value
    apply { @current_block.text.last.font.size = size }
    @register['.s'].value = size
  end

  def init_ps
    @register[:prev_ps] = Register.new
    true
  end
end
