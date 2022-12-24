# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#
# TODO
#   something's got to be done about the huge volume of warnings from all the comments
#     in the osf macro files. .so of them on every. goddamn. page. is fucking killing us.
#
# √ reference links are all bogus
# √  - http://dev.online.typewritten.org/Manual/DEC/Tru64/5.1b/man1ssl/%E2%80%8D%3Cstrong%3Egendsa%E2%80%8D.html
# √  - section 1ssl only? no, I see it in section 1 too. was ok in (the one page in) 3cde.
# √  - looks like it's full of &zwj; (likely from \*L and \*O) and this is probably the problem.
#
# √ some pages have RELATED INFORMATION instead of SEE ALSO
#   CA.pl(1s) no read perms on output??? (because it is named .pl? looks like it)
#   hier(7) links Functions:‍symlink‍(2) -- lack of whitespace; other pages WITH whitespace still linking this way
#

class Font # Triumvirate is essentially Helvetica
  class TR < Font::H ; end
  class TB < Font::HB ; end
  class TI < Font::HI ; end
  class G  < Font::H ; end
  class GB < Font::HB ; end
  class GL < Font::HI ; end
end

module OSF1

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.define_singleton_method(:HB, k.method(:GB)) if k.methods.include?(:GB)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([n\d][^.\s]*)(?:\.gz)?$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
    k.instance_variable_set '@related_info_heading', %r{(?:SEE(?: |&nbsp;)+ALSO|RELATED(?: |&nbsp;)INFORMATION)}
    case k.instance_variable_get '@input_filename'
    when /^default\./
      k.instance_variable_set '@manual_entry', '_default'
    when /^index\./
      k.instance_variable_set '@manual_entry', '_index'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      #:footer => "\\fH\\*(]W\\fP"
      :footer => ''
    })
  end

  def init_fp
    super
    # Geneva Light changed to Triumvirate Italic for LN01
    # Geneva Regular changed to Triumvirate Regular for LN01
    @state[:fonts][4] = 'BI'
    @state[:fonts][5] = 'CW' # assumes font position 5 is the constant width font
    @state[:fonts][7] = 'H'  # Gothic
    #@state[:fonts][8] = 'L'  # Gothic Light
    @state[:fonts][8] = 'HI' # Gothic Light
    @state[:fonts][9] = 'HB' # Gothic Bold
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
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
  def req_so(name, breaking: nil)
    osdir = @source_dir.dup
    @source_dir << '/../..' if name.start_with?('/')
    if %w[sml rsml].include? File.basename(name)
      super(name) { |lines| lines.reject! { |l| l.start_with? '...\\"' } }
    else
      super(name)
    end
    @source_dir = osdir
  end

  define_method 'AT' do |*args|
    req_ds(']W ' + case args[0]
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
    req_ds(']W ' + case args[0]
                   when '', '1' then '1st Carnegie-Mellon Update'
                   when '2'     then '2nd Carnegie-Mellon Update'
                   when '3'     then '3rd Carnegie-Mellon Update'
                   else "#{args[0].to_i - 3}th Carnegie-Mellon Update"
                   end)
  end

  define_method 'CT' do |*args|
    parse "\\s-2<\\|CTRL\\|#{args[0]}\\|>\\s+2"
  end

  define_method 'CW' do |*args|
    req_ft 'CW'
  end

  define_method 'De' do |*args|
    warn "REVIEW .De #{args.inspect}"
    req_ce '0'
    req_fi
  end

  define_method 'Ds' do |*args|
    warn "REVIEW .Ds #{args.inspect}"
    req_nf
    send "#{args[0]}D", "#{args[1]} #{args[0]}"
    req_ft 'R'
  end

  define_method 'DE' do |*args|
    warn "REVIEW .DE #{args.inspect}"
    req_fi
    send 'RE'
    req_sp '.5'
  end

  define_method 'EE' do |*args|
    req_fi
    req_ps "#{Font.defaultsize}"
    req_in "-#{@register['EX'].value}u"
    req_sp '.5'
    req_ft '1'
  end

  define_method 'EX' do |*args|
    req_nr 'EX ' + to_u("#{args[0] || 0}n+#{@state[:base_indent]}u")
    req_nf
    req_sp '.5'
    req_in "+#{@register['EX'].value}u"
    req_ft 'CW' # Geneva regular (changed to Constant Width for LN01)
    req_ps '-2'
    #req_vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
  end

  define_method 'G' do |*args| # Gothic (Sans-Serif) assumes font position 7 is Helvetica
    req_ft 'H'
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  # .GB doesn't actually have an input trap! .HB is different from .GB but also has no .it, so I'll alias them.
  # TODO this isn't actually how GB (or HB) work.
  define_method 'GB' do |*args| # Gothic Bold (Sans-Serif Bold) assumes font position 9 is Helvetica Bold
    warn "REVIEW use of #{__callee__}"
    req_ft 'HB'
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  define_method 'GL' do |*args| # Gothic Light (Sans-Serif Italic) assumes font position 8 is Helvetica Italic
    #req_ft 'GL'
    req_ft 'HI'
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  # apparently for indexing; do nothing for now but suppress the warning
  define_method 'iX' do |*args| ; end

  define_method 'I1' do |*args|
    warn "REVIEW .I1 #{args.inspect}"
    req_ti "+\\w'#{args[0]}'u"
  end

  define_method 'I2' do |*args|
    warn "REVIEW .I2 #{args.inspect}"
    req_sp '-1'
    req_ti "+\\w'#{args[0]}'u"
  end

  # uses Courier fonts for 4.0
  define_method 'MS' do |*args|
    parse "\\f(CW\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
  end

  define_method 'NE' do |*args|
    req_ce '0'
    req_in '-5n'
    req_sp '12p'
  end

  define_method 'NT' do |*args|
    req_ds 'NO Note'
    req_ds "NO #{args[1]}" if args[1] and args[1] != 'C'
    req_ds "NO #{args[0]}" if args[0] and args[0] != 'C'
    req_sp '12p'
    send 'HB'
    req_ce
    parse "\\*(NO" # not unescape - need to trigger input trap
    req_sp '6p'
    req_ce '99' if args[0..1].include? 'C'
    req_in '+5n'
    # also bring in right margin by the same.
    # it'll work as long as there's only one paragraph worth of note
    @current_block.style.css[:margin_right] = @current_block.style.css[:margin_left]
    send 'R'
  end

  # for indexing - don't care. uses \*(BK internally (default value: "Book Title")
  define_method 'HH' do |*args| ; end
  define_method 'NX' do |*args| ; end

  define_method 'Pn' do |*args|
    parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
  end

  # uses Courier fonts for 4.0
  define_method 'PN' do |*args|
    parse "\\f(CW\\|#{args[0]}\\|\\fP#{args[1]}"
  end

  define_method 'R' do |*args|
    req_ft 'R'
  end

  define_method 'RN' do |*args|
    parse "\\s-2<\\|RETURN\\|>\\s+2"
  end

  define_method 'TB' do |*args|
    warn "REVIEW .TB #{args.inspect}"
    @register['PF'] = @register['.f'].dup
    req_ft 'HB' # Triumvirate Bold
    if args.any?
      parse args.join(' ')
      send 'R'
    else
      req_nr 'SF 8'
    end
  end

  define_method 'TH' do |*args|
    # these strings are deliberately blanked by .TH if not given in the args.
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}"
    req_ds "]D #{args[4]}"
    req_ds "]U #{args[5]}" # product, or product status
    req_ds "]A #{args[6]}" # "usually architecture"
    req_ds(']T ' + case args[1][0]
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
    unless @state[:named_string][']U'].empty? and @state[:named_string][']A'].empty?
      byline = Block::Footer.new
      byline.style.css[:margin_top] = '0.5em' # TODO not working?
      unescape "\\f9\\*(]U\\fP", output: byline
      unescape "\\0\\0\\(em\\0\\0", output: byline unless @state[:named_string][']U'].empty? or @state[:named_string][']A'].empty?
      unescape "\\f9\\*(]A\\fP", output: byline
      @document << byline
    end

    # sir \*(PR not appearing in tmac.an.repro - does anything define it?
    # is it worth the log warn noise?
    heading = "#{args[0]}\\|(\\^#{args[1]}\\*(PR\\^)"
    heading << "\\0\\0\\(em\\0\\0\\*(]T" unless @state[:named_string][']T'].empty?
    heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?
    # these would go below the top .tl if given. I think I'll put it in <h1> instead.
    # REVIEW <h1> could potentially be very busy.
    #heading << '\\0\\0\\(em\\0\\0\\*(]U' unless @state[:named_string][']U'].empty?
    #heading << '\\0\\0\\(em\\0\\0\\*(]A' unless @state[:named_string][']A'].empty?

    #@state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' if args[2] and !args[2].strip.empty?
    # TODO \*(]W and \*([L are empty in most cases, giving us unnecessary \(em
    # I think I want ]T in the header.
    #@state[:named_string][:footer] << "\\*(]T" unless @state[:named_string][']T'].strip.empty?
    @state[:named_string][:footer] << "\\0\\0\\(em\\0\\0\\*(]W" unless @state[:named_string][']W'].empty?
    @state[:named_string][:footer] << "\\0\\0\\(em\\0\\0\\*(]L" unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

  define_method 'UC' do |*args|
    req_ds(']W ' + case args[0]
                   when '3' then '3rd Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   when '7' then '4.4 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end)
  end

  define_method 'UF' do |*args|
    req_ds "]T #{args[0]}"
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
