# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# BSD 2.11 Platform Overrides (tmac.an.new) - same as 4.3_VAX_MIT except extra cases in .UC
#
# TODO
# √ macros
# √ manual section may be e.g. 4f or 4n (currently output directory is just man4/)
#

require_relative '../unix'
require_relative '../unix/v6'
require_relative '../unix/v7'

module BSD
  module V1
    class Troff < ::UNIX::V6::Troff ; end
  end

  module V2_8
    class Nroff < Nroff ; end
    class Troff < ::UNIX::V7::Troff
      def initialize(source, **kwargs)
        @manual_entry ||= source.file.sub(/\.(?:[u\d]\S?)$/, '')
        super(source, **kwargs)
      end
    end
  end

  # TODO (maybe) - no AT, DE, DS in 2.9
  module V2_9
    class Troff < Troff
      # TODO this appears in other versions' macros too
      def init_ds
        super
        @named_strings.merge!(
          {
            'R' => '\\(rg'
          }
        )
      end

      def UC(v = nil, *_args)
        ds(']W ' + case v
                   when '2' then 'Second Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   else "#{args[1]} #{args[0]} BSD"
                   end
          )
      end
    end
  end

  module V2_11
    class Nroff < Nroff ; end
    class Troff < Troff
      # tmac.an.new
      def UC(v = nil, *_args)
        ds(']W ' + case v
                   when '2' then '2nd Berkeley Distribution' # is actually "2rd" in tmac.an.new
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   when '7' then '4.4 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end
          )
      end
    end
  end

  module V3
    class Nroff < Nroff ; end
    class Troff < Troff
      # tmac.an.new
      def UC(v = nil, *_args)
        ds(']W 3rd Berkeley Distribution')
      end
    end
  end
end
