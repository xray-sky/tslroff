# frozen_string_literal: true
#

class Troff
  class Register
    extend Forwardable

    attr_accessor :value, :format, :increment
    def_delegators :@value, :zero?, :>, :<, :<=, :>=, :==, :-@, :to_f, :to_i, :to_int

    ALPHA_MAP = [ [0], 'a'..'z', 'aa'..'zz', 'aaa'..'zzz' ].map(&:to_a).flatten.freeze
    ROMAN_MAP = [ [ '', 'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix' ],
                  [ '', 'x', 'xx', 'xxx', 'xl', 'l', 'lx', 'lxx', 'lxxx', 'xc' ],
                  [ '', 'c', 'cc', 'ccc', 'cd', 'd', 'dc', 'dcc', 'dccc', 'cm' ],
                  [ '', 'm', 'mm', 'mmm' ] ].freeze

    def initialize(value = 0, increment = 0, ro: false)
      self.value = value
      @format    = '1'
      @increment = increment
      @read_only = ro
    end

    def dup
      Register.new(value, increment)
    end

    def incrementing?
      !@increment.zero?
    end

    def incr
      @value += @increment
    end

    def decr
      @value -= @increment
    end

    def read_only?
      @read_only
    end

    def value=(x)
      raise RuntimeError "register sets only Integer value, not #{x.class.name}" unless x.respond_to?(:to_i)
      @value = x.to_i
    end

    # TODO this causes an infinite loop, performing comparisons (e.g. >, <, >=) between two Registers
    def coerce(other)
      [ Register.new(other), self ]
    end

    def to_str
      case @format
      when '1'     then @value.to_s
      when /(\d+)/ then sprintf("%0#{Regexp.last_match(1).length}d", @value)
      when 'a'     then ALPHA_MAP[@value]
      when 'A'     then ALPHA_MAP[@value].upcase
      when 'i', 'I'
        return '0' if @value.zero?
        ord = 0
        val = String.new
        num = @value.to_s
        while digit = num[-1] do # REVIEW why am I doing this in reverse order??
          begin
            val.prepend(ROMAN_MAP[ord][digit.to_i])
            num.chop!
            ord += 1
          rescue NoMethodError => e
            warn "register out of range for roman format (@value)"
          end
        end
        @format == 'I' ? val.upcase : val
      end
    end

    def arithmetic_method(other)
      case other
      when Fixnum, Float, Register then other.send(__callee__, @value)
      when String                  then other.send(__callee__, @value.to_str)
      else raise TypeError, "Register can't perform #{__callee__} with #{other.class} type"
      end
    end

    alias to_s to_str
    alias + arithmetic_method
    alias * arithmetic_method
    alias - arithmetic_method
    alias / arithmetic_method

  end
end
