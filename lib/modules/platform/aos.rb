# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 10/07/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS Platform Overrides (tmac.an.new)
#
# Three part title }H (head)
#  .tl @\\*(]H@\\*(]D@\\*(]H@	::	nam(sec)	Unix Programmer's Manual		nam(sec)
#
# Three part title }F (foot)
#  .tl @\\*(]W@\\*(]L@%@		::	7th Edition			TH$3					\n%
#
# .de TH
#   .nr IN .5i
#   .ds ]H $1\|(\|$2\|)
#   .ds ]L $3
#   .if $4 is set .ds ]W $4 else .ds ]W "7th Edition"
#   .if $5 is set .ds ]D $5 else .ds ]D "Unix Programmer's Manual"
#   put }H at top of page
#   put }F an inch from bottom
#
# TODO
#   we definitely have to delay header/footer processing until end of processing
#

class AOS
  class Troff < ::Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]
      @output_directory ||= "man#{@manual_section}"
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*(]W",
          # tmac.an.new
          ']D' => 'Unix Programmer\'s Manual', # default set by .TH
          ']W' => '7th Edition' # default set by .TH
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    # tmac.an.new
    define_method 'AC' do |*_args|
      ds(']W PRPQs 5799-WZQ/5799-PFF: IBM/4.3')	# REVIEW where the hell is this defined?
    end

    # tmac.an.new
    define_method 'AT' do |*args|
      ds(']W ' + case args[0]
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if !args[1]&.empty?}"
                 else '7th Edition'
                 end
        )
    end

    define_method 'DE' do |*_args|
      send 'fi'
      send 'RE'
      sp('.5')
    end

    define_method 'DS' do |*_args|
      send 'RS'
      nf
      sp
    end

    define_method 'TH' do |*args|
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].empty?
      ds "]D #{args[4]}" if args[4] and !args[4].empty?

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    define_method 'UC' do |v = nil, *_args|
      ds(']W ' + case v
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
        )
    end

    define_method 'VE' do |*_args|
      warn ".VE - can't yet draw margin characters (.mc)"
    end

    define_method 'VS' do |*_args|
      warn ".VS - can't yet draw margin characters (.mc)"
    end

  end
end
