# af.rb
# -------------
#   troff
# -------------
#
#   set numeric register format
#
#   §8
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
#  .af R c  Arabic   -        -       Assign format c to register R. The available formats are
#
#                                       1   0,1,2,3,4,5,...
#                                     001   000,001,002,003,004,005,...
#                                       i   0,i,ii,iii,iv,v,...
#                                       I   0,I,II,III,IV,V,...
#                                       a   0,a,b,c,...,z,aa,bb,...,zz,aaa,...
#                                       A   0,A,B,C,...,Z,AA,BB,...,ZZ,AAA,...
#
#                                     An Arabic format having N digits specifies a field width
#                                     of N digits. The read-only registers and the width function
#                                     are always Arabic.
#
# Registers are always arabic until changed by .af
#

module Troff

  def req_af(reg, fmt)
    unless reg.match(/s[tb]/) or @register[reg].read_only?
      @register[reg].format = fmt
    end
  end

end
