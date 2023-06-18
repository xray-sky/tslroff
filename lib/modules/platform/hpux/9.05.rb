# encoding: US-ASCII
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

module HPUX_9_05

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'default.4'
      k.instance_variable_set '@manual_entry', '_default'
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
    super(name)
    @source_dir = osdir
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

# all the same tmac.an

module HPUX_8_07
  def self.extended(k)
    k.extend HPUX_9_05
  end
end

module HPUX_9_00
  def self.extended(k)
    k.extend HPUX_9_05
  end
end

module HPUX_9_03
  def self.extended(k)
    k.extend HPUX_9_05
  end
end

module HPUX_9_04
  def self.extended(k)
    k.extend HPUX_9_05
  end
end

module HPUX_9_10
  def self.extended(k)
    k.extend HPUX_9_05
  end
end

