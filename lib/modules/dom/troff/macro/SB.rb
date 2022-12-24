# SB.rb
# -------------
#   troff
# -------------
#
#   smaller text, bold
#
# TODO: move this to whatever platform this is defined for; it's not a SysV macro
#
=begin
module Troff
  define_method 'SB' do |*args|
    req_ps("#{Font.defaultsize - 1}")
    req_ft('B')
    unless args[0].empty?
      parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
      send('}f')
    else
      req_it('1 }f')
    end
  end
end
=end
