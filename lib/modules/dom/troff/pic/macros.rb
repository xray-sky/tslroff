#   .PS xx
#
#     Starts figure (pic) processing
#
# TODO

class EndOfPic < RuntimeError ; end

module Troff

  def PE(*_args)
    raise EndOfPic
  end

  def PS(*args)
    warn ".PS received #{args.inspect} as absolute size" unless args.empty?

    @current_block = Block::Bare
    figure = blockproto Block::Figure


  rescue EndOfPic => e
    @document << figure
  end

end
