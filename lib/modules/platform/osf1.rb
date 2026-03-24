# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#
# .\" Basic Font Usage:
# .\"   For *troff processing, these macros assume the fonts are in the
# .\"   following order:
# .\"	  Position: 1  2  3  4  5  6  7  8  9  10 11 12
# .\"	  Font:     R  I  B  BI CW CB H  HI HB HX S1 S
#
# TODO
# √ OSF/1 3.0 macros (an, an.repro, rsml, sml) (identical to 3.2c except copyright date)
#
#   something's got to be done about the huge volume of warnings from all the comments
#     in the osf macro files. .so of them on every. goddamn. page. is fucking killing us.
#
# √ reference links are all bogus
# √  - http://dev.online.typewritten.org/Manual/DEC/Tru64/5.1b/man1ssl/%E2%80%8D%3Cstrong%3Egendsa%E2%80%8D.html
# √  - section 1ssl only? no, I see it in section 1 too. was ok in (the one page in) 3cde.
# √  - looks like it's full of &zwj; (likely from \*L and \*O) and this is probably the problem.
#
# √ some pages have RELATED INFORMATION instead of SEE ALSO
#   cdoc(1) [3.0] has 'See Also'
#   CA.pl(1s) no read perms on output??? (because it is named .pl? looks like it)
#   hier(7) links Functions:‍symlink‍(2) -- lack of whitespace; other pages WITH whitespace still linking this way
# √ lp(1) [1.0/mips] infinite loop => stack overflow due to double inclusion of sml/rsml macros
# √   - the 1.0 macros do not guard against this like the 3.x macros do
#

class OSF1
  class Manual < ::Manual
    def initialize file, vendor_class: nil, source_args: {}
      case File.dirname file
      when /SJIS/
        source_args.merge!({encoding: Encoding::Shift_JIS})
        @language ||= 'ja'
        @related_info_heading ||= %r{関連項目}u
      end
      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Troff < ::Troff

    # OSF1/Digital UNIX/Tru64 custom fonts
    # Gothic/Geneva and Triumvirate are all essentially Helvetica
    class Font
      class TR < ::Font::H ; end
      class TB < ::Font::HB ; end
      class TI < ::Font::HI ; end
      class G  < ::Font::H ; end
      class GB < ::Font::HB ; end
      class GL < ::Font::HI ; end
    end

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.([n\d][^.\s]*)(?:\.gz)?$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @related_info_heading ||= %r{(?:RELATED(?: |&nbsp;)INFORMATION|SEE(?: |&nbsp;)+ALSO|See(?: |&nbsp;)+Also)}
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: ''
        }
      )
    end

    def init_fp
      super
      # Geneva Light changed to Triumvirate Italic for LN01
      # Geneva Regular changed to Triumvirate Regular for LN01
      @mounted_fonts[4] = 'BI'
      @mounted_fonts[5] = 'CW' # assumes font position 5 is the constant width font
      @mounted_fonts[7] = 'H'  # Gothic
      #@mounted_fonts[8] = 'L'  # Gothic Light
      @mounted_fonts[8] = 'HI' # Gothic Light
      @mounted_fonts[9] = 'HB' # Gothic Bold
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_PD
      super
      @register['PD'] = @register[')P']         # OSF .PD sets \n(PD instead of \n()P - the OSF macros make extensive use of it
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    # .so with absolute path, osf/1 macros in /usr/share/lib/tmac
    #
    # sourcing the osf/1 macro files (sml, rsml) on every single page is killing us.
    # until I figure out how to improve that, reducing the warn load by stripping out
    # all the "illegal" comments should help immensely as a first draft.
    # (it does: ~10x improvement in runtime, ~2x improvement in log size)
    def so(name, breaking: nil)
      name = "../../../..#{name}" if name.start_with?('/')
      file = File.basename(name)
      if %w[sml rsml].include? file
        # guard against double-inclusion. e.g. lp(1) :: OSF/1 1.0
        # This feature is present in e.g. >3.0 sml/rsml macro files, but not in earlier OSF/1.
        super(name, breaking: breaking) { |lines| lines.reject! { |l| l.start_with? '...\\"' } } unless @state[file]
        @state[file] = true
      else
        super(name, breaking: breaking)
      end
    end

    define_method 'AT' do |*args|
      ds(']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5'
                   case args[1]
                   when '' then 'System V'
                   else "System V Release #{args[1]}"
                   end
                 else '7th Edition'
                 end)
    end

    define_method 'CM' do |*args|
      ds(']W ' + case args[0]
                 when '', '1' then '1st Carnegie-Mellon Update'
                 when '2'     then '2nd Carnegie-Mellon Update'
                 when '3'     then '3rd Carnegie-Mellon Update'
                 else "#{args[0].to_i - 3}th Carnegie-Mellon Update"
                 end)
    end

    define_method 'CT' do |*args|
      parse "\\s-2<\\|CTRL\\|#{args[0]}\\|>\\s+2"
    end

    define_method 'CW' do |*_args|
      ft 'CW'
    end

    define_method 'De' do |*args|
      warn "REVIEW .De #{args.inspect}"
      ce '0'
      fi
    end

    define_method 'Ds' do |*args|
      warn "REVIEW .Ds #{args.inspect}"
      nf
      send "#{args[0]}D", "#{args[1]} #{args[0]}"
      ft 'R'
    end

    define_method 'DE' do |*args|
      warn "REVIEW .DE #{args.inspect}"
      fi
      send 'RE'
      sp '.5'
    end

    define_method 'EE' do |*_args|
      fi
      ps Font.defaultsize.to_s
      send :in, "-#{@register['EX'].value}u"
      sp '.5'
      ft '1'
    end

    define_method 'EX' do |*args|
      nr 'EX ' + to_u("#{args[0] || 0}n+#{@state[:base_indent]}u")
      nf
      sp '.5'
      send :in, "+#{@register['EX'].value}u"
      ft 'CW' # Geneva regular (changed to Constant Width for LN01)
      ps '-2'
      #vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
    end

    define_method 'G' do |*args| # Gothic (Sans-Serif) assumes font position 7 is Helvetica
      ft 'H'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    # .GB doesn't actually have an input trap! .HB is different from .GB but also has no .it, so I'll alias them.
    # TODO this isn't actually how GB (or HB) work.
    define_method 'GB' do |*args| # Gothic Bold (Sans-Serif Bold) assumes font position 9 is Helvetica Bold
      warn "REVIEW use of #{__callee__}"
      ft 'HB'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    define_method 'GL' do |*args| # Gothic Light (Sans-Serif Italic) assumes font position 8 is Helvetica Italic
      #ft 'GL'
      ft 'HI'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    # apparently for indexing; do nothing for now but suppress the warning
    define_method 'iX' do |*_args| ; end

    define_method 'I1' do |*args|
      warn "REVIEW .I1 #{args.inspect}"
      ti "+\\w'#{args[0]}'u"
    end

    define_method 'I2' do |*args|
      warn "REVIEW .I2 #{args.inspect}"
      sp '-1'
      ti "+\\w'#{args[0]}'u"
    end

    # uses Courier fonts for 4.0
    define_method 'MS' do |*args|
      parse "\\f(CW\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
    end

    define_method 'NE' do |*_args|
      ce '0'
      send :in, '-5n'
      sp '12p'
    end

    define_method 'NT' do |*args|
      ds 'NO Note'
      ds "NO #{args[1]}" if args[1] and args[1] != 'C'
      ds "NO #{args[0]}" if args[0] and args[0] != 'C'
      sp '12p'
      send 'HB'
      ce
      parse "\\*(NO" # not unescape - need to trigger input trap
      sp '6p'
      ce '99' if args[0..1].include? 'C'
      send :in, '+5n'
      # also bring in right margin by the same.
      # it'll work as long as there's only one paragraph worth of note
      @current_block.style.css[:margin_right] = @current_block.style.css[:margin_left]
      send 'R'
    end

    # for indexing - don't care. uses \*(BK internally (default value: "Book Title")
    define_method 'HH' do |*_args| ; end
    define_method 'NX' do |*_args| ; end

    define_method 'Pn' do |*args|
      parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
    end

    # uses Courier fonts for 4.0
    define_method 'PN' do |*args|
      parse "\\f(CW\\|#{args[0]}\\|\\fP#{args[1]}"
    end

    define_method 'R' do |*_args|
      ft 'R'
    end

    define_method 'RN' do |*_args|
      parse "\\s-2<\\|RETURN\\|>\\s+2"
    end

    define_method 'TB' do |*args|
      warn "REVIEW .TB #{args.inspect}"
      @register['PF'] = @register['.f'].dup
      ft 'HB' # Triumvirate Bold
      if args.any?
        parse args.join(' ')
        send 'R'
      else
        nr 'SF 8'
      end
    end

    define_method 'TH' do |*args|
      # these strings are deliberately blanked by .TH if not given in the args.
      ds "]L #{args[2]}"
      ds "]W #{args[3]}"
      ds "]D #{args[4]}"
      ds "]U #{args[5]}" # product, or product status
      ds "]A #{args[6]}" # "usually architecture"
      ds(']T ' + case args[1]&.[](0) # the unbundled OpenGL pages don't have an args[1] (TODO? rewrite)
                     when '1' then 'Commands'
                     when '2' then 'System Calls'
                     when '3' then 'Subroutines'
                     when '4' then 'File Formats'
                     when '5' then 'Macro Packages and Conventions'
                     when '6' then 'Games'
                     when '7' then 'Special Files'
                     when '8' then 'Maintenance'
                     else ''
                     end)

      # ]U and ]A (if given) follow the title, centered on their own line.
      unless @named_strings[']U'].empty? and @named_strings[']A'].empty?
        byline = Block::Footer.new
        byline.style.css[:margin_top] = '0.5em' # TODO not working?
        unescape "\\f9\\*(]U\\fP", output: byline
        unescape "\\0\\0\\(em\\0\\0", output: byline unless @named_strings[']U'].empty? or @named_strings[']A'].empty?
        unescape "\\f9\\*(]A\\fP", output: byline
        @document << byline
      end

      # sir \*(PR not appearing in tmac.an.repro - does anything define it?
      # is it worth the log warn noise?
      heading = "#{args[0]}\\|(\\^#{args[1]}\\*(PR\\^)"
      heading << "\\0\\0\\(em\\0\\0\\*(]T" unless @named_strings[']T'].empty?
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty?
      # these would go below the top .tl if given. I think I'll put it in <h1> instead.
      # REVIEW <h1> could potentially be very busy.
      #heading << '\\0\\0\\(em\\0\\0\\*(]U' unless @named_strings[']U'].empty?
      #heading << '\\0\\0\\(em\\0\\0\\*(]A' unless @named_strings[']A'].empty?

      #@named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' if args[2] and !args[2].strip.empty?
      # TODO \*(]W and \*([L are empty in most cases, giving us unnecessary \(em
      # I think I want ]T in the header.
      #@named_strings[:footer] << "\\*(]T" unless @named_strings[']T'].strip.empty?
      @named_strings[:footer] << "\\0\\0\\(em\\0\\0\\*(]W" unless @named_strings[']W'].empty?
      @named_strings[:footer] << "\\0\\0\\(em\\0\\0\\*(]L" unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    define_method 'UC' do |*args|
      ds(']W ' + case args[0]
                     when '3' then '3rd Berkeley Distribution'
                     when '4' then '4th Berkeley Distribution'
                     when '5' then '4.2 Berkeley Distribution'
                     when '6' then '4.3 Berkeley Distribution'
                     when '7' then '4.4 Berkeley Distribution'
                     else '3rd Berkeley Distribution'
                     end)
    end

    define_method 'UF' do |*args|
      ds "]T #{args[0]}"
    end

    define_method 'VE' do |*args|
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    define_method 'VS' do |*args|
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end

  end
end

class Digital_UNIX < OSF1 ; end
class Tru64 < OSF1 ; end
class Tru64::V4_0f < Tru64 ; end
