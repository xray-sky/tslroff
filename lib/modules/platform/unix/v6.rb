# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX V6 Platform Overrides
#
#   from GL2-W2.5 lib/macros/an6
#   can't seem to find the 'an' macros from the v6 kit (look again)
#   this ought to be interesting
#
# TODO
#   redo as first-class macro package
# √ link detection - section in roman numerals
#   is everything here ok? what's up with cc(i) ?
#

class UNIX::V6

  # this is working to avoid killing ::Block::Paragraph (`class Block::Paragraph < ::Block` did this)
  # but neither was the UNIX::V6 Troff making use of it.
  # overriding blockproto() was sufficient to fix, but fragile.

  class Block
    class Paragraph < ::Block
      def to_html
        # this used to happen before every block was processed.
        # TODO something better.
        #      something not tied to Block::Paragraph.
        #      something that can be overridden.
        #        => V6 manual refs are like "syscall (II)"
        # NOTE Nroff Line class has its own link rewrite

        t = @text.collect(&:to_html).join
        t.gsub!(%r{(?<break>(?:<br />)*)(?<text>(?:<[^<]+?>)*(?<entry>\S+?)\s{0,1}(?:<[^<]+?>)*\s{0,1}\((?:<[^<]+?>)*(?<fullsec>(?<section>[IV]*?))(?:<[^<]+?>)*\)(?:<[^<]+?>)*)}) do |_m|
          caps = Regexp.last_match
          entry = caps[:entry].sub(/&minus;/, '-')  # this was interfering with link generation - ali(1) [AOS 4.3]
          %(#{caps[:break]}<a href="../man#{caps[:fullsec].downcase}/#{entry}.html">#{caps[:text]}</a>)
        end if style[:linkify]

        "<p#{@style}>\n#{t}\n</p>\n"
      end
    end
  end

  class Troff < ::UNIX::Troff

    alias :Bd :bd
    alias :Dt :dt
    alias :il :it
    undef :bd
    undef :dt
    undef :it

    alias :LP :P
    alias :dt :DT
    alias :sh :SH

    def init_ds
      super
      @state[:named_string].merge!(
        {
          '_' => '_',
          '-' => '\\-',
          '|' => '\\|',
          "'" => '\\(aa',
          '>' => '\\(->',
          'a' => '\\(aa',
          'b' => '\\(*b',
          'g' => '\\(ga',
          'p' => '\\(*p',
          'r' => '\\(rg',
          'u' => '\\(*m',
          'v' => '\\(bv',
          'G' => '\\(*G',
          'X' => '\\(mu'
        }
      )
    end

    def xinit_nr
      super
      @register.merge!({
        '}I' => Register.new(to_u('5n')),
        '}P' => Register.new(0, 1)
      })
    end

    def source_init
      case @source.file
      when 'greek.5' then @source.patch_line(17, /\s([.1])/, ' +\1', global: true)
      end
      super
    end

    def blockproto(type = Block::Paragraph)
      super(type)
    end

    def bd(*args)
      ft '3'
      if @register['V'] > 1
        parse "_#{args[0]}_"
      else
        parse "\\&#{args[0]}"
      end
      ft
    end

    def bn(*args)
      ft '3'
      if @register['V'] > 1
        parse "_#{args[0]}_\t\\&\\c"
      else
        parse "\\&#{args[0]}\t\\&\\c"
      end
      ft
    end

    def i0(*_args)
      parse ".in\\n(}Iu" #send 'in', "#{@register['I'].value}u"
      dt
    end

    def it(*args)
      # can't use .ul as it calls .it internally
      #ul
      ft '2'
      if @register['V'] > 1
        parse "_#{args[0]}_"
      else
        parse "\\&#{args[0]}"
      end
      # since we can't rely on .ul giving us a one-line input trap for .}f
      ft
    end

    def lp(*args)
      tc
      i0
      ta "#{args[1]}n"
      send 'in', "#{args[0]}n"
      ti "-#{args[1]}n"
    end

    define_method 's1' do |*_args|
      sp '1v'
      #ne '2'
    end

    define_method 's2' do |*_args|
      sp '.5v'
    end

    define_method 's3' do |*_args|
      sp '.5v'
      #ne '2'
    end

    def th(*args)
      send 'TH', args[0], args[1], heading: "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\*-\\0\\0PWB/UNIX\\| #{args[2]}"
    end

    def li(*_args)
      warn "V6 manual invoked .li with #{_args.inspect} ? REVIEW"
    end

    define_method '..' do |*_args|
      warn "V6 manual invoked ... with #{_args.inspect} ? REVIEW"
    end

  end
end
