#class Manual
  class Nroff

    Overstrikes = {
      %w[&]   => '&amp;',     %w[<]   => '&lt;',      %w[>]    => '&gt;',
      %w[O c]  => '&copy;',   %w[< a]  => '&alpha;',  %w[, f]  => '&fnof;',
      %w[/ E o] => '&exist;', %w[- C]  => '&isin;',   %w[- n]  => '&pi;',     %w[- V]  => '&forall;',
      %w[+ |]  => '&dagger;', %w[- |]  => '&dagger;', %w[= |]  => '&Dagger;', %w[v |]  => '&darr;',
      %w[+ -]  => '&plusmn;', %w[^ |]  => '&uarr;',   %w[' e]  => '&eacute;', %w[/ c]  => '&cent;',
      %w[/ =]  => '&ne;',     %w[/ L]  => '&#0321;',  %w[/ l]  => '&#0322;',  %w[/ O]  => '&empty;',
      %w[+ o]  => '&oplus;',  %w[+ O]  => '&oplus;',  %w[O x]  => '&otimes;', %w[O r]  => '&reg;',
      %w[H I X] => '&#9724;',  # U25FC see eqnchar(5) [DG/UX 4.30]
      %w[' , I] => '&int;',    #       see eqnchar(5) [DG/UX 4.30]
      %w[e o x] => '&bull;',   #       see eqnchar(5) [DG/UX 4.30]
      %w[- : = o] => '&bull;', #       see syslogd(8n), others. [UTek 6130-W2.3]
      %w[- / C] => '&notin;',  #       (etc.)
      %w[- h]  => '&#8463;',   # U210F
      %w[< =]  => '&#8806;',   # U2266
      %w[> =]  => '&#8807;',   # U2267
      %w[< ~]  => '&#8818;',   # U2272
      %w[> ~]  => '&#8819;',   # U2273
      %w[= ~]  => '&#8773;',   # U2245
      %w[< |]  => '&#8814;',   # U226E
      %w[> |]  => '&#8815;',   # U226F
      %w[| ~]  => '&Gamma;',   # see gamma(3) [CLIX-7.6.22] (is actually rendered as ~^H|~ )
      %w[# ^]  => '&#9636;',   # curses "board of squares" equivalent
      %w[- . X |] => '&lowast;', # see eqnchar(7) [Domain/OS SR10.4]
      ['(', '/']  => '&#8467;',  # U2113
      %w[- d |]   => %(<span class="clash">d<span class="pile">&dagger;</span></span>), # see cw(1), etc. [A/UX 3.0.1]
    }

    Overstrikes.default_proc = proc do |_hash, key|
      key.collect! { |c| c.sub(/(.)\cN/) { Typebox[Regexp.last_match[1]] } }
      key.length == 1 and next key[0]
      raise TypeClashError.new(key), 'unresolved overstrike'
    end

    Overstrikes.freeze # REVIEW do I really want to freeze this, or make it platform overrideable somehow

  end
#end
