# traps.rb
# ---------------
#    Troff trap processing routines
# ---------------
#
# frozen_string_literal: true
#

class Troff

  private

  def process_input_traps
    # decrement the line counters
    @input_traps = @input_traps.transform_keys { |k| k -= 1 }

    # select the ones that should happen now
    macros = @input_traps.delete(0)

    return unless macros
    macros.reverse.each do |macro|
      send macro[0]
    end
  end
end
