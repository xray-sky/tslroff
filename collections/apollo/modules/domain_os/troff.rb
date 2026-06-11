# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#
# REVIEW do I really want to downcase all the sections? 3X11 wants to be uppercase.
# TODO
#   unbundled Ada SEE ALSO links to e.g. a.db with no section

module Aegis
  class Troff < Troff::Man

    include Utils

    alias :LP :P

    def initialize(source, **kwargs)
      @systype = Regexp.last_match[1] if source.dir.match(%r{(bsd|sys5)})
      @manual_entry ||= "#{source.file.sub(/\.(?:[\danZz][A-Za-z]?|hlp)$/, '')}#{".#{@systype}" if @systype}"
      super(source, **kwargs)
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      #basedir = "#{@source.dir}#{"/../../.." if name.start_with?('/usr/man')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    # Troff methods <= tmac.an
    # tmac.an.new
    def AT(*args)
      ds(']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if args[1]}"
                 else '7th Edition'
                 end
            )
    end

    # tmac.an.new
    def UC(v = nil, *_args)
      ds(']W ' + case v
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
            )
    end

  end
end
