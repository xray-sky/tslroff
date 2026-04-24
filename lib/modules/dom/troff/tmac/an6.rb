# frozen_string_literal: true
#
# tmac.an6.rb
#
#   UNIX Version 6 man page macros
#

class Troff
  module Macros
    module An6
      def self.extended(k)
        k.define_singleton_method :Bd, k.method(:bd)
        k.define_singleton_method :Dt, k.method(:dt)
        k.define_singleton_method :il, k.method(:it)
        k.undef :bd
        k.undef :dt
        k.undef :it
        k.xinit_nr
        k.init_ds
      end

      def init_ds
        super
        @named_strings.merge!(
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

      #   .dt
      #
      #     Restore default tab settings (every 7.2en in troff(1), 5en in nroff(1))

      def dt(*_args)
        ta('.5i 1i 1.5i 2i 2.5i 3i 3.5i 4i 4.5i 5i 5.5i 6i 6.5i')
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
        send :in, "#{args[0]}n"
        ti "-#{args[1]}n"
      end

      def s1(*_args)
        sp '1v'
        #ne '2'
      end

      def s2(*_args)
        sp '.5v'
      end

      def s3(*_args)
        sp '.5v'
        #ne '2'
      end

      #   .sh text
      #
      #     Place subhead text, for example, SYNOPSIS, here.
      #
      #  turns fill mode on, if it's off (at least on GL2-W2.5 - REVIEW)

      def sh(*args)
        fi
        nr(')R 0')
        xinit_in
        @current_block = blockproto Block::Head
        @document << @current_block
        unescape(args.join(' '))
        @section_heading = @current_block.to_s

        ps "#{Font.defaultsize}"
        ft '1'
        @register[')I'] = Register.new(to_u('0.5i'))
        @tag_padding = 12
        @current_block = blockproto
        @document << @current_block
      end

      def th(*args)
        #send 'TH', args[0], args[1], heading: "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\*-\\0\\0PWB/UNIX\\| #{args[2]}"
        @manual_section = args[1] if args[1] and !args[1].strip.empty?   # REVIEW ...do I? - I'm doing it that way in nroff. but this also means I can't override in platform/version
        dt
        @named_strings[:header] = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\*-\\0\\0PWB/UNIX\\| #{args[2]}"
        @current_block = blockproto
        @document << @current_block
      end

      def li(*_args)
        warn "V6 manual invoked .li with #{_args.inspect} ? REVIEW"
      end

      define_method '..' do |*_args|
        warn "V6 manual invoked ... with #{_args.inspect} ? REVIEW"
      end

      def P(*_args)
        send '}f'   # .PP resets font, by way of .}E (also line length, don't care)
        init_IP		# .PP resets \n()I to 0.5i
        @current_block = blockproto
        @document << @current_block
        indent(@base_indent + @register[')R'])
      end

      #alias :PP :P
      alias :LP :P

    end
  end
end

