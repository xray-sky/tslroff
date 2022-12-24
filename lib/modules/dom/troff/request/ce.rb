# ce.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .ce N     off     N=1       B,‡,E   Center the next N input text lines within the
#                                     current (line-length minus indent). If N=0,
#                                     any residual count is cleared. A break occurs after
#                                     each of the N input lines. If the input line is too
#                                     long, it will be left adjusted.
#
#  REVIEW what happens if break suppressed??
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#

module Troff
  def req_ce(argstr = '', breaking: true)
    warn ".ce invoked with nobreak - how to?" unless breaking
    n = argstr.split.first || '1'

    if n == '0'
      @state[:input_trap].delete_if { |k,v| v[0] == ':R' }#:finalize_ce }
      send '[C'
    else
      n = n.to_i
      req_nf
      @current_block.style.css[:text_align] = 'center'
      #req_it(n, :finalize_ce)
      req_it "#{n} [C"
    end
  end

  #def finalize_ce
  define_method "[C" do |argstr = '', breaking: nil|
    req_fi
    @current_block.style.css.delete(:text_align)
  end
end
