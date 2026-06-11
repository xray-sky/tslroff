# frozen_string_literal: true
#

module Typesetter
  module ASR37
    Symbols = {
      'A' => '&Alpha;',  'G' => '&Gamma;', 'S'  => '&epsilon;', 'O' => '&Theta;', 'E' => '&Lambda;',
      'X' => '&xi;',     'K' => '&rho;',   'I'  => '&tau;',     'V' => '&psi;',   'Z' => '&Omega;',
      ']' => '&part;',   'B' => '&beta;',  'D'  => '&delta;',   'Q' => '&zeta;',  'T' => '&theta;',
      'M' => '&mu;',     'J' => '&pi;',    'Y'  => '&sigma;',   'U' => '&#981;',  'H' => '&Psi;',
      '[' => '&nabla;',  '^' => '&int;',   "\\" => '&gamma;',   'W' => '&Delta;', 'N' => '&eta;',
      'L' => '&lambda;', '@' => '&nu;',    'P'  => '&Pi;',      'R' => '&Sigma;', 'F' => '&Phi;',
      'C' => '&omega;',  '_' => '&not;'
    }
  end

  # EK-VT100-RC
  # only defines a few chars apparently; anything else is passed through
  # TODO fix the default_proc after completing the map, get rid of explicit passthrus
  module VT100
    Symbols = {
      # "light"
      'l' => '&#9484;', 'q' => '&#9472;', 'w' => '&#9516;', 'k' => '&#9488;',
      'x' => '&#9474;', 't' => '&#9500;', 'n' => '&#9532;', 'u' => '&#9508;',
      'm' => '&#9492;', 'v' => '&#9524;', 'j' => '&#9496;',
      # not listed? ...looks like maybe they just pass through?!
      '^' => '^', '<' => '&lt;', '>' => '&gt;', '(' => '(', ')' => ')',
      '0' => '0', '1' => '1', '2' => '2', '3' => '3', '4' => '4',
      '5' => '5', '6' => '6', '7' => '7', '8' => '8', '9' => '9',
      '.' => '.', ',' => ',', '-' => '-', ']' => ']', 'F' => 'F',
      'X' => 'X'
    }
  end
end
