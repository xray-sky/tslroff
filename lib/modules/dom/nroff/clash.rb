#class Manual
  class Nroff
    class TypeClashError < RuntimeError
      attr_accessor :pile

      def initialize(pile)
        super
        @pile = pile
      end
    end
  end
#end
