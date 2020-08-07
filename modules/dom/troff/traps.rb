# traps.rb
# ---------------
#    Troff trap processing routines
# ---------------
#

module Troff

  private

  def process_input_traps

    # decrement the line counters
    @state[:input_trap] = Hash[ @state[:input_trap].collect do |trap, macros|
                                  [ trap -= 1 , macros ]
                                end ]

    # select the ones that should happen now
    macros = @state[:input_trap].delete(0)

    if macros
      macros.reverse.each do |macro|
        self.send(macro[0], *macro[1])
      end
    end

  end

end
