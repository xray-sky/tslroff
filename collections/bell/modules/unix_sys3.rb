# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Bell UNIX System III Platform Overrides
#

module UNIX
  module SysIII

    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            'R'  => '\\(rg',
            'S'  => '\\s\\n()S',
            ']D' => String.new('UNIX 3.0'),
            ']W' => File.mtime(@source.path).strftime('%B %d, %Y'),
            :footer => String.new('\\*(]W')
          }
        )
      end

      # .so with absolute path, headers in /usr/include
      def so(name, breaking: nil, basedir: nil)
        name.sub!(%r{^/usr/man}, '/usr/src/man') # manual extracted from source tree, not install tree
        basedir = "#{@source.dir}#{"/../../.." if name.start_with?('/')}"
        super(name, breaking: breaking, basedir: basedir)
      end

      def PM(*args)
        warn ".PM #{args.inspect} - testing"
        case args[0]
        when '', nil then nr '!K 0'
        when 'P'     then nr '!K 1' ; send ')G'
        when 'BP'    then nr '!K 3' ; send ')G'
        when 'BR'    then nr '!K 4' ; send ')G'
        else              nr '!K 2' ; send ')G'
        end
      end

      define_method ')G' do |*_args|
        warn ".)G - testing"
        ph = Block.new(text: Text.new(font: Font::I.new))
        pm = Block.new(text: Text.new(font: Font::B.new))
        ph.style.css[:text_align] = 'center'
        pm.style.css[:text_align] = 'center'

        case @register['!K'].value
        when 1
          ph.text.text = [ VerticalSpace.new(height: '2'), 'PRIVATE' ]
          pm.text.text = [
            'This information should not be disclosed to unauthorized persons.', LineBreak.new,
            'It is meant solely for use by authorized Bell System employees.', VerticalSpace.new(height: '2')
          ]
        when 2
          ph.text.text = [ VerticalSpace.new(height: '2'), 'NOTICE' ]
          pm.text.text = [
            'Not for use or disclosure outside the', LineBreak.new,
            'Bell System except under written agreement.', VerticalSpace.new(height: '2')
          ]
        when 3
          ph.text.text = [ VerticalSpace.new(height: '2'), 'BELL LABORATORIES PROPRIETARY' ]
          pm.text.text = [
            'Not for use or disclosure outside Bell Laboratories except by', LineBreak.new,
            'written approval of the director of the distributing organization.', VerticalSpace.new(height: '2')
          ]
        when 4
          ph.text.text = [ VerticalSpace.new(height: '2'), 'BELL LABORATORIES RESTRICTED' ]
          pm.text.text = [
            'The information herein is meant solely for use by authorized', LineBreak.new,
            'Bell Laboratories employees and is not to be disclosed to others.', VerticalSpace.new(height: '2')
          ]
        end

        @document << ph
        @document << pm
        @document << blockproto
      end

      def TH(*args)
        ds "]L #{args[2]}"
        ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

        heading = "#{args[0]}\\^(\\^#{args[1]}\\^)\\0\\0\\(em\\0\\0\\*(]D"
        @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

        super(*args, heading: heading)
      end
    end

    def self.name_for_section(sec)
      case sec.downcase
      when '1'  then "<strong>#{sec}.</strong> Commands"
      when '1c' then "<strong>#{sec}.</strong> Communications Commands"
      when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
      when '1m' then "<strong>#{sec}.</strong> Maintenance Commands"
      when '2'  then "<strong>#{sec}.</strong> System Calls"
      when '3'  then "<strong>#{sec}.</strong> Subroutines"
      when '3c' then "<strong>#{sec}.</strong> C and Assembler Library"
      when '3m' then "<strong>#{sec}.</strong> Math Library"
      when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
      when '3x' then "<strong>#{sec}.</strong> Miscellaneous Routines"
      when '4'  then "<strong>#{sec}.</strong> Special Files"
      when '5'  then "<strong>#{sec}.</strong> File Formats"
      when '6'  then "<strong>#{sec}.</strong> Games"
      when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities"
      when '8'  then "<strong>#{sec}.</strong> Maintenance Procedures"
      else "Section #{sec}"
      end
    end

  end
end
