class Troff
  module Eqn

    def eqn_delim(delim)
      if delim == 'off'
        # TODO quit with @state{}
        @eqn_start = nil
        @eqn_end = nil
        nil
      else
        (@eqn_start, @eqn_end) = delim.chars
        #warn @eqn_start.inspect
      end
    end

    def eqn_define(defstr)
      word = defstr.slice!(/\S+\s+/).strip
      # delim may not always be followed by a space
      delim = defstr.slice!(/\S\s*/).strip
      remainder = defstr.slice!(defstr.rindex(delim)..-1)
      warn "eqn extra text in define?? #{remainder[1..-1].inspect}" if remainder[1]
      if @eqnchars.include? word
        # this is totally legal but in practice seems used to construct characters not
        # available on the typesetter. we have all the characters we need, already
        warn "eqn rejecting redefinition of existing eqnchar #{word}"
        nil
      else
        define_singleton_method("eqn_#{word}") do |parse_tree|
          gen_eqn eqn_parse_tree(defstr)
          #gen_eqn [parse_tree.shift]
        end
      end
    end

    def eqn_ndefine(_defstr) ; true ; end  # nroff-specific define
    alias_method :eqn_tdefine, :eqn_define # troff-specific define

    def eqn_mark(_parse_tree)
      unescape "\\k(97"
    end

    def eqn_lineup(_parse_tree)
      warn "eqn lineup - check interaction with tabs"
      insert_tab(width: to_em(@register['97'].value))
    end

  end
end
