# nr.rb
# -------------
#   troff
# -------------
#
#   set numeric registers
#

module Troff
  def req_nr(args)
    # TODO: this.
  end

  def init_nr
    {
      '.F' => File.basename(@source.filename), # name of current input file.
      '.c' => 0, # number of lines read from current input file.
      '.s' => Font.defaultsize, # Current point size.
      '.u' => 1, # 1 in fill mode and 0 in no-fill mode.
    }
  end
end