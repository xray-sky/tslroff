# /usr/lib/macros/rsml => rsml.rb
#
# .\" $Header: /vob/dce.doc/src/doc/macros/rsml,v /main/1 1995/04/04 17:43 UTC arh Exp $
#
# very simple translation of HP rsml macro package to ruby, in order to avoid
# the various painful overheads of define_method
#
# frozen_string_literal: false
#


class HPUX
  module RSML

    def self.extended(k)
      # multiple-inclusion guard - prevent recursive re-def of PP
      #return if k.instance_variable_get(:@register)['!r'].value == 1
      #k.send :nr, '!r 1'
      k.send :nr, 'Ll 0 1'
      k.send :nr, '$A 0 1'
      k.send :nr, '$M 0 1'
      k.send :nr, '$V 0 1'
      k.send :rn, 'RS rS'
      k.send :rn, 'RE rE'
      k.send :rn, 'PP P#'
      k.define_singleton_method 'PP', k.method(:yoPP)
    end

    def tH(*_args) ; end

    # TH, SH, and SS were done with .am, but since it involves
    # macro args we will do it with super()

    def TH(*args) ; super(*args) ; send :rsml_barY, "TH", "#{args[0]}" ; end
    def SH(*args) ; super(*args) ; send :rsml_barY, "SH", "#{args[0]}" ; end
    def SS(*args) ; super(*args) ; send :rsml_barY, "SS", "#{args[0]}" ; end

    # was |Y - REVIEW for external calls; rename and fall back to define_method if necessary
    def rsml_barY(*_args)
      if @register['Ll'] > 0
        warn ".|Y : unterminated list (no .LE) -- noticed by the .#{args[0]} #{args[1]}"
        nr 'Ll 0'
      end
    end

    def yoPP(*_args)
      @register['Ll'] > 0 || @register['Nn'] > 0 ? sp("#{@register['PD']}u") : send('P#')
    end

    def ML(*_args)
      send :SP
      nr '$M +1'
      rS "#{@register["%#{@register['Ll']}"]}u" if @register['Ll'] > 0
      nr 'Ll +1'
      nr "%#{@register['Ll']} .5i"
      ds(@register['$M'] == 1 ? "%#{@register['Ll']} \\(bu" : "%#{@register['Ll']} \\(em")
      nr "##{@register['Ll']} 0 1"
      ds "##{@register['Ll']} M"
    end

    def VL(*args)
      send :SP
      nr '$V +1'
      rS "#{@register["%#{@register['Ll']}"]}u" if @register['Ll'] > 0
      nr 'Ll +1'
      nr("#{args[0]}".empty? ? "%#{@register['Ll']} 1i" : "%#{@register['Ll']} #{args[0]}n")
      ds "##{@register['Ll']} V"
    end

    def AL(*_args)
      send :SP
      nr '$A +1'
      rS "#{@register["%#{@register['Ll']}"]}u" if @register['Ll'] > 0
      nr 'Ll +1'
      nr "%#{@register['Ll']} .5i"
      af case @register['$A'].value
         when 1 then "##{@register['Ll']} 1"
         when 2 then "##{@register['Ll']} a"
         else        "##{@register['Ll']} i"
         end
      nr "##{@register['Ll']} 0 1"
      ds "%#{@register['Ll']} \\n+(##{@register['Ll']}"
      ds %[%#{@register['Ll']} "\\ \\ \\ \\ \\ #{@named_strings["%#{@register['Ll']}"]}]
      ds "##{@register['Ll']} A"
    end

    def LI(*args)
      send :SP, '.25'
      case @named_strings["##{@register['Ll']}"]
      when 'V' then send :IP, "#{args[0]}", %(#{@register["%#{@register['Ll']}"]}u)
      when 'M' then send :IP, %(#{@named_strings["%#{@register['Ll']}"]}), %(#{@register["%#{@register['Ll']}"]}u)
      else          send :IP, %(#{@named_strings["%#{@register['Ll']}"]}.), %(#{@register["%#{@register['Ll']}"]}u)
      end
    end

    def LE(*_args)
      case @named_strings["##{@register['Ll']}"]
      when 'A'
        nr '$A -1'
        nr 'Ll -1'
        rE if @register['Ll'] > 0
        send :in, "#{@register["%#{@register['Ll']}"]}+#{@register[')R']}u+#{@register['IN']}u", breaking: false
      when 'V'
        nr '$V -1'
        nr 'Ll -1'
        rE if @register['Ll'] > 0
        send :in, "#{@register["%#{@register['Ll']}"]}+#{@register[')R']}u+#{@register['IN']}u", breaking: false
      when 'M'
        nr '$M -1'
        nr 'Ll -1'
        rE if @register['Ll'] >= 0
        send :in, "#{@register["%#{@register['Ll']}"]}+#{@register[')R']}u+#{@register['IN']}u", breaking: false
      end
      send :SP
    end

    def FG(*args)
      rsml_out 'Figure', '0', "#{@register['Fg'].incr}", "#{args[0]}"
    end

    def TB(*args)
      rsml_out 'Table', '1', "#{@register['Tb'].incr}", "#{args[0]}"
    end

    def EC(*args)
      rsml_out 'Equation', '2', "#{@register['Ec'].incr}", "#{args[0]}"
    end

    def EX(*args)
      rsml_out 'Exhibit', '3', "#{@register['Ex'].incr}", "#{args[0]}"
    end

    # was )F - REVIEW for external calls; rename and fall back to define_method if necessary
    def rsml_out(*args)
      sp "#{@register['PD']}u"
      if @register['|D'] == 1 # "Draft mode"
        ce '1'
      else
        ti '0'
        nr "!~ #{@register['!@']}+1"
        ps "#{@register['!~']}"
        ft 'H'
      end
      parse "#{args[0]}\\ #{@register['H1']}\\(mi#{args[2]}.   #{args[3]}"
      sp "#{@register['PD']}u"
      # TOC only request omitted, if reg ~Z == 1
    end

    def SP(*args)
      br
      nr("#{args[0]}".empty? ? "|Q #{args[0]}v" : "|Q #{@register['PD']}u")
      nr '|A 0' unless @register['nl'] == @register['|B']
      nr "|Q -#{@register['|A']}u"
      if @register['|Q'] > 0
        sp "#{@register['|Q']}u"
        nr "|A +#{@register['|Q']}u"
      end
      nr "|B #{@register['nl']}"
    end
  end
end
