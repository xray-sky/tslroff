# nr.rb
# -------------
#   troff
# -------------
#
#   set numeric registers
#
#   §8
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
#  .nr R ±N M -     -         u       The number register R is assigned the value ±N with
#                                     respect to the previous value, if any. The increment
#                                     for auto-incrementing is set to M.
#
# incrementing is done when processing the \n escape, rather than at output, because
# it may be a positive or negative increment, or none at all
#
# enforcement of read_only registers is done in .nr rather than internal to the class,
# because the internal registers still need to be updated, just not from document context
#
#   TODO: generally underimplemented
#

require 'forwardable'

module Troff

  def req_nr(register, value = '0', increment = nil)
    @state[:register][register] ||= Register.new(0)
    unless @state[:register][register].read_only?
      @state[:register][register].value += value.to_i
      @state[:register][register].increment = increment if increment
    end
  end

  def init_nr
    date = Time.new
    @state[:register] = {
      ############################################
      # §24 Predefined General Number Registers
      ############################################
      #%                                                                  # current page number.
      #.b                                                                 # emboldening factor of current font.
      #c.                                                                 # input line-number (same as read-only .c).
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
      #$$                                                                 # process id of troff.
      #.$                                                                 # # of args avail at current macro level.
      #.A                                                                 # 1 in troff if -a option used; always 1 in nroff.
      '.F' => Register.new(File.basename(@source.filename), :ro => true), # name of current input file.
      #.H                                                                 # avail horizontal resolution in u.
      #.L                                                                 # current line spacing parameter (.ls).
      #.P                                                                 # 1 if current page is being printed; otherwise 0.
      #.T                                                                 # 1 if -T option used; otherwise 0.
      #.V                                                                 # avail vertical resolution in u.
      #.a                                                                 # post-line extra line-space most recently utilized using \x'N'
      '.c' => Register.new(0, :ro => true),                               # number of lines read from current input file.
      #.d                                                                 # current vertical place in current diversion. == nl if no diversion
      '.f' => Register.new(1, :ro => true),                               # current font position.
      #.h                                                                 # text baseline high-water mark on current page or diversion (?)
      #.i                                                                 # current indent.
      #.j                                                                 # current adj mode and type. can be saved for use with .ad to restore
      #.k                                                                 # horizontal size of text (minus indent) of current partially collected output line, if any, in current env.
      #.l                                                                 # current line length.
      #.n                                                                 # length of text portion on previous output line.
      #.o                                                                 # current page offset.
      #.p                                                                 # current page length.
      '.s' => Register.new(Font.defaultsize, :ro => true),                # current point size.
      #.t                                                                 # distance to the next trap.
      '.u' => Register.new(1, :ro => true)                                # 1 in fill mode and 0 in no-fill mode.
      #.v                                                                 # current vertical line spacing (probably in u).
      #.w                                                                 # width of previous character.
      #.x                                                                 # reserved: version-dependent.
      #.y                                                                 # reserved: version-dependent.
      #.z                                                                 # name of current diversion.
    }
    true
  end

  class Register
    extend Forwardable

    attr_accessor :format, :increment
    def_delegators :@value, :zero?

    @@alpha_map = [0,('a'..'z').to_a,('aa'..'zz').to_a,('aaa'..'zzz').to_a].flatten
    @@roman_map = [ [ '', 'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix' ],
                    [ '', 'x', 'xx', 'xxx', 'xl', 'l', 'lx', 'lxx', 'lxxx', 'xc' ],
                    [ '', 'c', 'cc', 'ccc', 'cd', 'd', 'dc', 'dcc', 'dccc', 'cm' ],
                    [ '', 'm', 'mm', 'mmm' ] ]

    def initialize(value = 0, increment = 0, ro: false)
      self.value = value
      @format    = :roman
      @increment = increment
      @read_only = ro
    end

    def read_only?
      @read_only
    end

    def value
      case @format
      when :roman  then @value
      when /(\d+)/ then sprintf("%0#{Regexp.last_match(1).length}d", @value)
      when /(a)/i
        Regexp.last_match(1) == 'A' ? @@alpha_map[@value].upcase : @@alpha_map[@value]
      when /(i)/i
        return '0' if @value.zero?
        ord = 0
        val = ''
        num = @value.to_s
        while digit = num[-1] do
          begin
            val.prepend(@@roman_map[ord][digit.to_i])
            num.chop!
            ord += 1
          rescue NoMethodError => e
            warn "register out of range for roman format (@value)"
          end
        end
        Regexp.last_match(1) == 'I' ? val.upcase : val
      end
    end

    def value=(val)
      case val
      when String  then @value = val.to_i
      when Integer then @value = val
      else         raise RuntimeError "register sets only Integer value, not #{val.class.name}"
      end
    end

    def incrementing?
      !@increment.zero?
    end

  end

end