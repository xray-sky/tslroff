# PS.rb
# -------------
#   troff
# -------------
#
#   Starts figure (pic) processing
#
# TODO
#

require 'open3'

class EndOfPic < RuntimeError ; end

module Troff

  define_method 'PE' do |*_args|
    raise EndOfPic
  end

  define_method 'PS' do |*args|
    warn ".PS received #{args.inspect} as absolute size" unless args.empty?

    @current_block = Block::Bare
    figure = blockproto Block::Figure


  rescue EndOfPic => e
    @document << figure
  end

end
