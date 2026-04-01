# /usr/share/lib/tmac/rsml => rsml.rb
#
# .\" @(#)$RCSfile: rsml,v $ $Revision: 4.1.2.2 $ (DEC) $Date: 1992/11/23 17:09:40 $
#
# very simple translation of OSF/1 rsml macro package to ruby, in order to avoid
# the various painful overheads of define_method - with persisted webdriver width
# cache, is effective at cutting DU 3.2c processing time in half. (~10m -> ~5m)
#
# All DEC OSF/1 / Digital UNIX / Tru64 RSML macros same since 1.0
# except introduction of !r added at or before 3.0
#
# frozen_string_literal: false
#

class OSF1
  module RSML

    def self.extended(k)
      # multiple-inclusion guard - prevent recursive re-def of PP
      return if k.instance_variable_get(:@register)['!r'].value == 1
      k.send :nr, '!r 1'
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

    def yoPP(*_args)
      @register['Ll'] > 0 ? sp("#{@register['PD']}u") : send('P#')
    end

    def ML(*_args)
      send :SP
      nr '$M +1'
      rS "#{@register["%#{@register['Ll']}"]}u" if @register['Ll'] > 0
      nr 'Ll +1'
      nr "%#{@register['Ll']} .5i"
      ds(@register['$M'] == 1 ? "%#{@register['Ll']} \\(bu" : "%#{@register['Ll']} \\(em")
      ds %[%#{@register['Ll']} "\\ \\ \\ \\ \\ \\ \\ #{@named_strings["%#{@register['Ll']}"]}]
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
      when 'V'
        nr '$V -1'
        nr 'Ll -1'
        rE if @register['Ll'] > 0
      when 'M'
        nr '$M -1'
        nr 'Ll -1'
        rE if @register['Ll'] >= 0
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
      ce '1'
      parse "#{args[0]}\\ #{@register['H1']}-#{args[2]}.  #{args[3]}"
      sp "#{@register['PD']}u"
    end

    def SP(*args)
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
