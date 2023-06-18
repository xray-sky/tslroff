# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 10.20 Platform Overrides
#
# REVIEWED
#   lpfilter(1) "E/C", "D/1", etc. are all explicitly typeset, empty tbl column (no tabs in input)
#
# TODO
# √ fts_help.1m [8]: .so can't read /usr/share/lib/macros/osfhead.rsml
# √ fts_help.1m [9]: .so can't read /usr/share/lib/macros/sml
# √ fts_help.1m [10]: .so can't read /usr/share/lib/macros/rsml
#
#   be nice somehow to prevent the extraneous \0\0\(em\0\0 if )H doesn't get defined...
#    - maybe I can define an end of processing macro to do it
#
#   pages ref font position 4. what is it? REVIEW not mounted in tmac.an. probably C (maybe CB? BI?)
#   probably move C font to css. the 10.20 manual uses it _extensively_
#   some pages want to use D, G, other fonts - what are they? acl_edit(1m)
#    - A D E F G K N O S T U
#   bos_getrestart(1m) wants to use S font directly
#   Xserver.1 has no .TH
#   mwm(1) has a couple examples toward the bottom of the page with apparent negative indents; "RELATED INFORMATION"
#   book title strings (e.g. \*(Dk, \*(Dr in v5srvtab.5) for OSF pages?
# √ .ds ]L 'Open Software Foundation' for OSF pages, since we can't .am }C even if we implemented .am
#   REVIEW osf pages (e.g. sams(1)) for .sS (.SP) example offset spacing -- is it really 0, given no args?
#   svcdumplog(1) has "RELATED INFORMATION" instead of "SEE ALSO"
#   dcecp_cdsalias(1m) sources osf macros _twice_, causing a .rn loop (also causes loop in troff)
#   remove_object(1m) [106]: \*C apparently expands to \&\f (with no following font request) - undef .empty? (nil) in tokenize/get_char
#     tmac/sml has .ds C \&\\f\\*(!]\" (where is .ds !] ??)
#     + related information -- detect ' ', translate ' ' to '_' for link
#   restore(1m) [402]: are we bug compatible now with formatting through .CI (too many quotes: 'blocks' should be C but is I, check if troff does the same)
#

module HPUX_10_20

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'dcecp_cdsalias.1m'
      # until we can figure out how to make ourselves resilient to .rn'ing the same macro twice
      k.instance_variable_get('@source').lines[7].sub!(/^/, '.\\"')
      k.instance_variable_get('@source').lines[8].sub!(/^/, '.\\"')
      k.instance_variable_get('@source').lines[9].sub!(/^/, '.\\"')
    when 'default.4'
      k.instance_variable_set '@manual_entry', '_default'
    when 'x_open_800.5' # is nroff output (with ^H overstriking), despite starting with .\" and .nf
      # lines per page is not consistent? deleting these extra lines doesn't help
      #k.instance_variable_get('@source').lines.delete_at(3887)
      #k.instance_variable_get('@source').lines.delete_at(3886)
      #k.instance_variable_get('@source').lines.delete_at(3885)
      #k.instance_variable_get('@source').lines.delete_at(1)
      #k.instance_variable_get('@source').lines.delete_at(0)
      require_relative '../../dom/nroff.rb'
      k.extend ::Nroff
      k.instance_variable_set '@lines_per_page', nil
    end
  end

  %w[C B I].each do |a|
    define_method a do |*args|
      if args.any?
        req_ft "#{@state[:fonts].index(a)}"
        parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
        #send '}N'
        send '}f'
      else
        #req_it '1 }N'
        req_it '1 }f'
      end
    end
  end

  %w[C B I R].permutation(2).each do |a, b|
    define_method "#{a + b}" do |*args|
      parse %(.}S #{@state[:fonts].index(a)} #{@state[:fonts].index(b)} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      'Tm' => '&trade;',
      ')H' => '', # .TH sets this to \&. Some pages define it.
      #']V' => "Formatted:\\0\\0#{File.mtime(@source.filename).strftime("%B %d, %Y")}",
      # REVIEW is this what actually goes in the footer in the printed manual?
      ']V' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      :footer => "\\*()H\\0\\0\\(em\\0\\0\\*(]W"
    })
  end

  def init_fp
    super
    @state[:fonts][4] = 'C'
  end

  # .so with absolute path, headers in /usr/include
  def req_so(name, breaking: nil)
    osdir = @source_dir.dup
    @source_dir << '/../..' if name.start_with?('/')
    if %w[sml rsml osfhead.rsml].include? File.basename(name)
      req_ds ']L Open Software Foundation'
      super(name) { |lines| lines.reject! { |l| l.start_with? '...\\"' } }
    else
      super(name)
    end
    @source_dir = osdir
  end

  # undocumented, not in tmac.an
  # appears to take one arg, matching the first letter of the command the manual entry is for?
  # (not accounting for .so -- so bg(1) has '.TA s', because of '.so sh.1'
  # ...seems irrelevant to us. suppress the warning on every page by defining.
  define_method 'TA' do |*_args| ; end

  define_method 'TH' do |*args|
    req_ds "]W #{__unesc_star('\\*(]V')}"
    req_ds "]O #{args[2]}"
    req_ds "]L #{args[3]}"
    req_ds "]J #{args[4]}"

    # ]J and ]O follow the title (if given), each centered on their own line.
    # .sp .3v between, .sp 1.5v following.
    #space = false
    %w( ]J ]O ).each do |s|
      unless @state[:named_string][s].empty?
        space = true
        byline = Block::Footer.new
        byline.style.css[:margin_top] = '0.5em' # TODO not working?
        unescape "\\f3\\*(#{s}\\fP", output: byline
        @document << byline
      end
    end
    #req_sp('1.5v') if space # probably this is overkill, actually

    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end
