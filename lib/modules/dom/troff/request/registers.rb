# frozen_string_literal: true
#
# nr.rb
# -------------
#   troff
# -------------
#
#   set numeric registers
#
#   §8
#

require 'forwardable'

class Troff
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

  def af(argstr = '', breaking: nil)
    (reg, fmt) = argstr.split
    return nil unless reg and fmt
    unless reg.match(/s[tb]/) or @register[reg].read_only?
      @register[reg].format = fmt
    end
  end

  # Request  Initial  If no     Notes   Explanation
  #  form     value   argument
  #
  #  .nr R ±N M -     -         u       The number register R is assigned the value ±N with
  #                                     respect to the previous value, if any. The increment
  #                                     for auto-incrementing is set to M.
  #
  #  incrementing is done when processing the \n escape, rather than at output, because
  #  it may be a positive or negative increment, or none at all
  #
  #  if we set up an increment, and subsequently .nr without one, is it held? - yes.
  #
  #  enforcement of read_only registers is done in .nr rather than internal to the class,
  #  because the internal registers still need to be updated, just not from document context
  #
  #  what happens when given not-an-N as second arg (invalid expression)
  #  -> ignored. doesn't set anything. same as if no number passed at all.
  #  we set the register = 0, but an unused register in troff has the value 0
  #  so that's probably fine?
  #
  #  Registers are always arabic until changed by .af

  def nr(argstr = '', breaking: nil)
    reg = argstr.split(/\s/).first or return

    # value expression may contain whitespace e.g. .nr g \w'sock gnome'+9n
    # - I don't _think_ we need to worry about doing any other unescaping?
    #   can't think of any other way whitespace might end up in the expression
    (value, increment) = __unesc_w(argstr[reg.length..-1]).split
    return unless value

    @register[reg] = Register.new unless @register.has_key?(reg) # default value means no ||=
    return if @register[reg].read_only?

    if value.start_with? '+' or value.start_with? '-'
      # leading +/- is treated as increment/decrement, separately from expression
      # so "-1-6" is "decrement -5" (i.e. "add 5") and not "subtract 7"
      @register[reg].value = @register[reg].value + (to_u(value[1..-1]).to_i * (value[0] == '-' ? -1 : 1))
    else
      @register[reg].value = to_u(value).to_i
    end

    @register[reg].increment = increment.to_i if increment
  end

  # Request  Initial  If no     Notes   Explanation
  #  form     value   argument
  #
  #  .rr R     -      ignored   -       Remove register R. If many registers are being
  #                                     created dynamically, it may become necessary to
  #                                     remove unneeded registers to recapture internal
  #                                     storage space for new registers.

  def rr(argstr = '', breaking: nil)
    return nil if argstr.empty?
    reg = reqstr.slice(0, 2).strip
    @register.delete(reg)
  end

  def xinit_nr
    date = Time.new
    @register.default = Register.new(0)
    @register.merge!({
      ############################################
      # §24 Predefined General Number Registers
      ############################################
      #%                                                                  # current page number.
      #.b                                                                 # emboldening factor of current font.
      '.R' => Register.new(100),                                          # count of number registers that remain available for use.
      #ct                                                                 # character type (set by width function \w).
      #dl                                                                 # width (maximum) of last completed diversion.
      #dn                                                                 # height (vertical size) of last completed diversion.
      'dw' => Register.new(date.wday),                                    # current day of the week (1-7).
      'dy' => Register.new(date.day),                                     # current day of the month (1-31).
      #ln                                                                 # output line number.
      'mo' => Register.new(date.month),                                   # current month (1-12).
      #nl                                                                 # vertical position of last printed text base-line.
      #sb                                                                 # depth of string below base line (generated by \w).
      #st                                                                 # height of string above base line (generated by \w).
      'yr' => Register.new(date.strftime('%y')),                          # last two digits of current year.
      ############################################
      # §25 Predefined Read-only Number Registers
      ############################################
      '$$' => Register.new(Process.pid, ro: true),                        # process id of troff.
      '.$' => Register.new(0, ro: true),                                  # # of args avail at current macro level.
      '.A' => Register.new(0, ro: true),                                  # 1 in troff if -a option used; always 1 in nroff.
      '.F' => Register.new(File.basename(@source.file), ro: true),        # name of current input file.
      #.H                                                                 # avail horizontal resolution in u.
      '.L' => Register.new(1, ro: true),                                  # current line spacing parameter (.ls).
      #.P                                                                 # 1 if current page is being printed; otherwise 0.
      #.T                                                                 # 1 if -T option used; otherwise 0.
      #.V                                                                 # avail vertical resolution in u.
      #.a                                                                 # post-line extra line-space most recently utilized using \x'N'
      '.c' => Register.new(0, 1, ro: true),                               # number of lines read from current input file.
      #.d                                                                 # current vertical place in current diversion. == nl if no diversion
      '.f' => Register.new(1, ro: true),                                  # current font position.
      #.g                                                                 # set non-zero for groff
      #.h                                                                 # text baseline high-water mark on current page or diversion (?)
      #.i' => Register.new(@base_indent, ro: true),               # current indent. - circular dependency referencing @base_indent here - see xinit_in
      '.j' => Register.new(1, ro: true),                                  # current adj mode and type. can be saved for use with .ad to restore
      #.k                                                                 # horizontal size of text (minus indent) of current partially collected output line, if any, in current env.
      '.l' => Register.new(to_u('7.5i'), ro: true),                       # current line length. TODO connect this to some future implementation of .ll ??
      #'.l' => Register.new(7, ro: true),                                 # REVIEW Solaris 2.4 x86 SDK ApplicationShell(3X) suggests this is supposed to be in i already??
                                                                          #   tbl uses this to determine whether the table is too wide for the page and to calculate table indent
                                                                          #   - actually it's inconsistent, it treats it as inches once, for determining whether it's too wide to fit,
                                                                          #     and later, units for calculating table indent. latter matters more, for us.
      #.n                                                                 # length of text portion on previous output line.
      '.o' => Register.new(0, ro: true),                                  # current page offset (left margin). separate from indents. REVIEW: how does changing this interact with css ('0' provides 1in margin)
      #.p                                                                 # current page length.
      '.s' => Register.new(Font.defaultsize, ro: true),                   # current point size.
      #.t                                                                 # distance to the next trap.
      '.u' => Register.new(1, ro: true),                                  # 1 in fill mode and 0 in no-fill mode.
      '.v' => Register.new(to_u("#{Font.defaultsize}p*6/5"), ro: true),   # current vertical line spacing in basic units (default: 1.2em)
      #.w                                                                 # width of previous character.
      #.x                                                                 # reserved: version-dependent.
      #.y                                                                 # reserved: version-dependent.
      #.z                                                                 # name of current diversion.
      ###########################################
      # these are variously defined in tmac.an
      # some pages reference them
      ###########################################
      ')L' => Register.new(to_u('11i')),   # page length
      'LL' => Register.new(to_u('6.5i'))   # line length (page width - margins)
    })

    # c. is supposed to be the same as read-only variable .c
    # REVIEW: but then why isn't it in the list of read-only registers?

    @register['c.'] = @register['.c']

    true
  end
end
