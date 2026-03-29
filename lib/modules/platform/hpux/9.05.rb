# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/17/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX 9.05 Platform Overrides
#
# TODO
# √ fts_help.1m [8]: .so can't read /usr/share/lib/macros/osfhead.rsml
# √ fts_help.1m [9]: .so can't read /usr/share/lib/macros/sml
# √ fts_help.1m [10]: .so can't read /usr/share/lib/macros/rsml
#
#   be nice somehow to prevent the extraneous \0\0\(em\0\0 if )H doesn't get defined...
#    - maybe I can define an end of processing macro to do it
#
#   pages ref font position 4. what is it? REVIEW not mounted in tmac.an. probably C (maybe CB?)
#   probably move C font to css. the 9.05 and 10.20 manuals use it _extensively_
#   wgskbd(3w) wants to use PA font
#   XcmsQuery..(3x) pages want to use XW font
#   softbench(1) SEE ALSO has spaces between manual and section.
#    - but the refs are for pages not in the base OS manual anyway
#   some other pages do too, like stlicense(1)
#

class HPUX::V9_05
  class Troff < HPUX::Troff

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*()H\\0\\0\\(em\\0\\0\\*(]W",
          'Tm' => '&trade;',
          ')H' => '', # .TH sets this to \&. Some pages define it.
          #']V' => "Formatted:\\0\\0#{File.mtime(@source.path).strftime("%B %d, %Y")}",
          # REVIEW is this what actually goes in the footer in the printed manual?
          ']V' => File.mtime(@source.path).strftime("%B %d, %Y")
        }
      )
    end

    def init_fp
      super
      @mounted_fonts[4] = 'C'
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    %w[C B I].each do |a|
      define_method a do |*args|
        if args.any?
          ft @mounted_fonts.index(a).to_s
          parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
          #send '}N'
          send '}f'
        else
          #it '1 }N'
          it '1 }f'
        end
      end
    end

    %w[C B I R].permutation(2).each do |a, b|
      define_method(a + b) do |*args|
        parse %(.}S #{@mounted_fonts.index(a)} #{@mounted_fonts.index(b)} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
      end
    end

    def TH(*args)
      ds "]W #{__unesc_star('\\*(]V')}"
      ds "]O #{args[2]}"
      ds "]L #{args[3]}"
      ds "]J #{args[4]}"

      # ]J and ]O follow the title (if given), each centered on their own line.
      # .sp .3v between, .sp 1.5v following.
      #space = false
      %w( ]J ]O ).each do |s|
        next if @named_strings[s].empty?
        #space = true
        byline = Block::Footer.new
        byline.style.css[:margin_top] = '0.5em' # TODO not working?
        unescape "\\f3\\*(#{s}\\fP", output: byline
        @document << byline
      end
      #req_sp('1.5v') if space # probably this is overkill, actually

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

  end
end
# all the same tmac.an

class HPUX::V8_07 < HPUX::V9_05 ; end
class HPUX::V9_00 < HPUX::V9_05 ; end
class HPUX::V9_03 < HPUX::V9_05 ; end
class HPUX::V9_04 < HPUX::V9_05 ; end
class HPUX::V9_10 < HPUX::V9_05 ; end
