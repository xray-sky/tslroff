# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/2/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os Platform Overrides
#

class RISC_os
  class Nroff < Nroff

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.([\dZz]\S?)$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][A-Za-z\s]+)$)
      # some of these entries with longish names end up with clashes in the title line
      # so detect just on closing parenthesis, regardless of following whitespace
      # - this seems sufficient for 4.52 & RW4.00. Also the case in 5.01.
      @title_detection ||= %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:-(?<systype>\S+?))?\))}
      @related_info_heading ||= 'SEE ALSO'
      super(source)
    end

    def page_title
      t = @manual_entry.sub(/\.#{@systype}$/, '')
      t << "(#{@manual_section})"
      t << " &mdash; #{@systype}" if @systype
      t << " &mdash; mips" # #{@version.tr('_', ' ')}"  # TODO need replacement for @version
    end

    def parse_title
      title = super
      @systype ||= case title&.[](:systype)
                   when /bsd/i     then 'bsd'
                   when /sy.*v/i   then 'sysv' # somewhere in 4.52 there's a 'syv'
                   when /svr3/i    then 'svr3' # svr3/svr4 is new in 5.01; can they just be rolled up into 'sysv'?
                   when /svr4/i    then 'svr4' # -> no: cc(1) has both svr3 & svr4 pages
                   when /posix/i   then 'posix'
                   when 'NEW', nil then nil
                   #else
                   #  warn "unexpected systype #{title&.[](:systype)}"
                   # All unexpected systypes are "LOCAL" => emacs(1), rn(1), top(1), vn(1)
                   # 5.01 also has "NEW", which I think we will disregard.
                   end
      @manual_entry << ".#{@systype}" if @systype
      title
    end

    # normal unix, with systype inserted before .html
    # TODO: this is totally unreliable, e.g. awk(bsd) links to sed which only has a sysv page
    #       there is a "local" systype for e.g. rn that links to more, etc. which are obviously not "local", whatever it means
    #       probably no hope here except to rewrite them later somehow in a 404check-like utility
    # TODO: appears to totally fail in 5.01 (see man4/)
    #       but it looks maybe like the SEE ALSO might explicitly give systype if relevant?
    #       at least not in every case; exports(4-svr4) is just refed as exports(4)
    #       and exports(4-svr4)
    def detect_links(line)
      line.scan(/(?<=[\s,.;])((\S+?)\((\d.*?)\))/).map do |text, ref, section|
        [text, "../man#{section.downcase}/#{ref}#{'.' + @systype if @systype}.html"]
      end.to_h
    end

  end
end
