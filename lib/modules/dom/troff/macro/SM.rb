# SM.rb
# -------------
#   troff
# -------------
#
#   .SM text
#
#     Make text 1 point smaller than default point size.
#

module Troff
  define_method 'SM' do |*args|
    req_ps "#{Font.defaultsize - 1}"
    if !args[0]&.empty?
      parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
      send '}f'
    else
      req_it('1 }f')
    end
  end
end
