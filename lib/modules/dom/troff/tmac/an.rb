# tmac.an.rb
#
#   man page macros
#
# TODO
#   separate the preprocessor methods
#

module Troff

  def init_RS
    @register[')R'] = Register.new(0)
    @register[')p'] = Register.new(0, 1)
    ('1'..'9').each do |n|
      [')', ']'].each do |i|
        @register[i+n] = Register.new
      end
    end
  end

#   .B text			Make text bold.
#   .I text			Make text italic.
#   .RI a b			Concatenate roman a with italic b, and alternate these two fonts for
#                   up to six arguments. Similar macros alternate between any two of
#                   roman, italic, and bold:   .IR  .RB  .BR  .IB  .BI
#
#   tmac.an defines behavior where a shift out of I inserts \^ except after the last arg

  %w[B I].each do |a|
    define_method a do |*args|
      if args.any?
        req_ft "#{@state[:fonts].index(a)}"
        parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
        #send '}N' # see note re: \n()E below
        send '}f'
      else
        #req_it('1', '}N')
        req_it '1 }f'
      end
    end
  end

  %w[B I R].permutation(2).each do |a, b|
    define_method "#{a + b}" do |*args|
      parse %(.}S #{@state[:fonts].index(a)} #{@state[:fonts].index(b)} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
    end
  end

  define_method '}f' do |*_args|
    req_ps "#{Font.defaultsize}"
    req_ft '1'
  end

  # the same, whether .B or .I
  # "handle end of 1-line features"
  # uses \n()E, set by .SH, .SS, .TP, etc.
  # REVIEW do we _need_ to use )E?

  define_method '}N' do |*_args|
    req_br if @register[')E'] > 0
    req_di
    send '}f' if @register[')E'].zero? # .}S
    send '}1' if @register[')E'] == 1 # .TP
    send '}2' if @register[')E'] == 2 # .SH, .SS
  end

  # special case for shift out of italic
  #
  # recursive .}S causes bad interactions with stray double-quotes :: restore(1m) [ HP-UX 10.20 ]
  # this means we have to be intentional about the way things like .if '\f2'' evaluate true
  #  - defer our conditionals to req_if

  define_method '}S' do |*args|
    #req_ds "]F #{(args[0] == '2' and !args[4].empty?) ? '\\^' : ''}"
    #if !args[3].empty?
    #  parse %(.}S #{args[1]} #{args[0]} "#{args[2]}\\f#{args[0]}#{args[3]}\\*\(]F" "#{args[4]}" "#{args[5]}" "#{args[6]}" "#{args[7]}" "#{args[8]}").tap { |n| warn ".}S :: #{n.inspect}" }
    #else
    #  parse args[2]
    #end

    req_ds ']F'
    req_if(%(!\007#{args[4]}\007\007 .ds ]F\\^), quiet: true) if args[0] == '2'
    req_ie(%(!\007#{args[3]}\007\007 .}S #{args[1]} #{args[0]} "#{args[2]}\\f#{args[0]}#{args[3]}\\*\(]F" "#{args[4]}" "#{args[5]}" "#{args[6]}" "#{args[7]}" "#{args[8]}"), quiet: true)
    req_el args[2]
    send '}f'
  end

#   .CD
#
#     define delimiters for cw(1) processing
#
#  TODO everything

  define_method 'CD' do |*_args|
    warn "requires preprocessing by cw(1)"
  end

#   .DT
#
#     Restore default tab settings (every 7.2en in troff(1), 5en in nroff(1))

  define_method 'DT' do |*_args|
    req_ta('.5i 1i 1.5i 2i 2.5i 3i 3.5i 4i 4.5i 5i 5.5i 6i 6.5i')
  end

#   .HP in			Begin paragraph with hanging indent.
#
#
#  e.g. paragraph has indent in, first line doesn't

  define_method 'HP' do |indent = nil, *_args|
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
    @current_block = blockproto
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'] + @register[')I'])
    temp_indent -@register[')I']
  end

#   .IP t in
#
#     Same as .TP with tag t; often used to get an indented paragraph without a tag.
#
# tmac.an turns ligatures off for the tag. interesting. -- did this via css. (TODO no longer after having removed dl/dd/dt)
# \n()I is also manipulated by/used for the indents on .RS and .HP
#
# REVIEW .IP/.PP/.IP with no further args is giving inconsistent indents, ar(1) Examples [GL2-W2.5]
#        -- that first .IP is holding over from .TP in previous section; should .SH reset like .PP does? porbly

  def init_IP
    # called from .RS - TODO maybe find a better way to do it that allows us to merge init_ methods
    @register[')I'] = Register.new(to_u('0.5i'))
    # this is effectively a constant. nothing changes it.
    @state[:tag_padding] = to_u('3p').to_i
  end

  define_method 'IP' do |tag = '', indent = nil, *_args|	# )I reg holds carryover indent
    warn "received extra args to .IP ?? - #{_args.inspect}" if _args.any?
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent

    # give us a block if we need one. doing it here keeps the paragraph spacing
    # the test prevents us from losing paragraph spacing we already got:
    # e.g. .PP -> .PD 0 -> .TP foo -- adb(1) [GL2-W2.5]
    #
    # TODO: but then we lose it at the other end - ugh how
    #       .RE -> .PD -> .TP foo
    #       the problem is that .PP outputs vertical space. but in HTML context, this is
    #       an empty container! REVIEW are we grown up enough to not skip empty blocks?
    #                                  we aren't pushing any "unnecessary" ones into the doc?

    @current_block = blockproto
    @document << @current_block

    tagpara(tag)
  end

#   .IX
#
#     Generate metadata for permuted index
#
#  REVIEW what is even sensible to do with this stuff?
#         SunOS is full of it
#
#   .P
#
#     Begin a paragraph with normal font, point size, and indent. .PP is a synonym for
#     mm(5) macro .P
#
#  REVIEW this is interacting with .in, not resetting that indent. correct? mkfs(1m) [GL2-W2.5]
#         it's also causing margin_top to collapse to 0 - bfs(1) [GL2-W2.5]

  define_method 'P' do |*_args|
    send '}f'   # .PP resets font, by way of .}E (also line length, don't care)
    init_IP		# .PP resets \n()I to 0.5i
    @current_block = blockproto
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'])
  end

#   .PD v
#
#     Set the interparagraph distance to v vertical spaces. If v is omitted, the set the
#     interparagraph distance to the default value (0.4v in troff(1), 1v in nroff(1)).
#
#     just sets )P, does nothing to @current_block
#     some implementations set PD instead
#
#     tslroff.css has it as 1em, which is some kind of de-facto browser standard.
#     I think this is better for HTML than 0.4v (0.48em). REVIEW: if we decide to change
#     it later, the CSS should be updated (for p, dl, others?)
#
#  TODO .PD 0 followed immediately by .TP anything is resulting in extra space
#       see bfs(1) Description, xbz/xbn [GL2-W2.5]

  def init_PD
    @state[:default_pd] = to_u('1m').to_i
    @register[')P'] = Register.new(@state[:default_pd])
  end

  define_method 'PD' do |v = nil, *_args|
    v ? @register[')P'].value = to_u(v, default_unit: 'v') : init_PD
  end

#   .PM m
#
#     Produces proprietary markings; see REFERENCE to mm(1).
#     REVIEW not sure this is present in too many non-AT&T versions of tmac.an
#            HP-UX defines it.
#     REVIEW just insert it here for every page to use? or leave it vendor-specific
#
#   .RE k
#
#     Return to the kth relative indent level (initially, k=1; k=0 is equivalent to k=1);
#     if k is omitted, return to the most recent lower indent level.
#
#   this works like a stack (see .RS)
#   kermit(1c) [GL2-W2.5] seems to call it repeatedly without ever having called .RS.

  define_method 'RE' do |k = nil, *_args|
    return if @register[')p'].zero?		# never .RS'd.
    case k
    when nil then true
    when '0' then @register[')p'] = Register.new(1, 1)
    else          @register[')p'] = Register.new(k, 1)
    end

    @register[')I'].value = @register["]#{@register[')p']}"].value
    @register[')R'].value = @register[")#{@register[')p']}"].value
    @register[')p'].decr if @register[')p'] > 0

    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = '0'
      @document << @current_block
    end
    indent(@state[:base_indent] + @register[')R'])
  end

#   .RS in
#
#     Increase relative indent (initially zero). Indent all output an extra in units
#     from the current left margin.
#
#   this works like a stack (see .RE)
#   tmac.an tracks the stack depth in )p
#                  the current indent )I is saved in ]1 -- ]9 (depending on value of )p) (this would be set by HP or TP)
#                  the current indent )R is saved in )1 -- )9 (depending on value of )p)
#                  the new indent is )R -- either the arg in (en) is added to it or it goes up by )I
#                  the new )I is )M (u) (3.6m for troff; 5n for nroff)
#          --alt-- the new )I is 0.5i (== 3.6m)
#
#   note: "all output"

  define_method 'RS' do |indent = nil, *_args|
    # troff won't tolerate more than 9 levels of indent even though theoretically we could
    #raise RuntimeError "out of stack space for indents in .RS at line #{input_line_number}" if @register[')p'] == 9
    # It doesn't fail though, it just does the simple thing of only using the first digit of )p, and the second digit goes uninterpreted

    # push old values onto stack
    @register[')p'].incr
    @register["]#{@register[')p']}"].value = @register[')I'].value
    @register[")#{@register[')p']}"].value = @register[')R'].value

    # increase relative indent by arg, or by )I if arg not given
    @register[')R'].value += if indent
      to_u(indent, :default_unit => 'n').to_i
    else
      @register[')I'].value
    end

    init_IP
    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = '0'
      @document << @current_block
    end
    indent(@state[:base_indent] + @register[')R'])

  end

#   .SH text
#
#     Place subhead text, for example, SYNOPSIS, here.
#
#  turns fill mode on, if it's off (at least on GL2-W2.5 - REVIEW)

  define_method 'SH' do |*args|
    req_fi
    req_nr(')R 0')
    xinit_in
    #apply { @current_block.type = :sh }
    @current_block = blockproto Block::Head
    @document << @current_block
    unescape(args.join(' '))
    @state[:section] = @current_block.to_s
    send 'P'
  end

#   .SM text
#
#     Make text 1 point smaller than default point size.
#

  define_method 'SM' do |*args|
    req_ps "#{Font.defaultsize - 1}"
    if !args[0]&.empty?
      parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
      send '}f'
    else
      req_it('1 }f')
    end
  end

#   .SS text
#
#     Place sub-subhead text, for example, Options, here.
#
# REVIEW .ti \n()Ru+\n(INu - sunos tmac.an

  define_method 'SS' do |*args|
    req_fi
    req_nr(')R 0')
    xinit_in
    #apply { @current_block.type = :ss }
    @current_block = blockproto Block::SubHead
    @document << @current_block
    unescape(args.join(' '))
    send 'P'
  end

#   .TH t s c n
#
#     Set the title and entry heading; t is the title, s is the section number,
#     c is extra commentary, e.g., "local", n is new manual name. Invokes .DT
#
#   Marks a "three-part header"
#
# The following number registers are given default values by .TH:
#       IN  Left margin indent relative to subheads
#           (default is 7.2en in troff(1), 5 en in nroff(1)
#            -- tmac.an sets it to 0.5i and it never changes).
#       LL  Line length including IN.
#       PD  Current interparagraph distance.
#
# none of this is relevant to tslroff (REVIEW: unless some man page tries to use them - e.g. IN in ms.5)
#
# TODO DomainOS softbench uses .TQ macro instead of .TH - this prevents us from outputting a correct set of divs
# TODO consider trying to get an actual .tl style title in html, which would help us prevent the hanging \(em
#      when some info is missing. I know we tried a bunch of nonsense ages ago, and didn't really solve it.
#

  define_method 'TH' do |*args, heading: nil|
    #@manual_section ||= args[1]
    # I want the section inferred from the filename to be a default
    # in case we don't get or can't parse the one from .TH
    @manual_section = args[1] if args[1] and !args[1].strip.empty?   # REVIEW ...do I? - I'm doing it that way in nroff. but this also means I can't override in platform/version
    @output_directory = "man#{@manual_section.downcase}" if @manual_section
    send 'DT'
    @state[:named_string][:header] = heading || "#{args[0]}\\^(\\^#{args[1]}\\^)"
    @current_block = blockproto
    @document << @current_block
  end

#   .TP in
#
#     Begin indented paragraph with hanging tag. The next line that contains text to be
#     printed is taken as the tag. If the tag does not fit, it is printed on a separate
#     line.
#
#   .TP (width)
#   (tag)
#   text...
#
# TODO what does ".TP &" mean? (see: machid.1 [GL2-W2.5])
# TODO AOS likes passing invalid expressions to .TP (and .IP) - nroff seems to ignore
#      them and keep previous indents, instead of changing them to 0 (as the expression evaluates)
#      ...how?? restore.tape(8), xlogin(8), etc. -- also ffbconfig(1m) [SunOS 5.5.1]
#      restore.tape(8) [AOS 4.3] gives .TP - 5 which causes '-' to try to be evaluated as an expression. this throws an exception.
#

  define_method 'TP' do |indent = nil, *_args|
    warn "pointlessly received extra arguments to .TP #{_args.inspect} - why??" unless _args.empty?
    indent = nil if indent == '&'	# TODO: ??? -- this isn't a special case, it's just an invalid expression. REVIEW does our expression handling cover it now?
                                    # it will automatically when we fix .nr to abort non-numeric and make this follow tmac.an
    # can't do this anymore, after rewriting the req/macro parsing to work with Interactive
    # TODO probably ought to eventually rewrite closer to actual tmac.an with \n()E, .ns, .di, and .}N
    #req_it('1', :finalize_TP, indent)
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
    req_it '1 }1'
    @document << blockproto
    @current_block = Block::Bare.new # for receiving the tag text
  end

  #def finalize_TP(indent)
  #  @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
  define_method '}1' do |*_args|
    tag = @current_block.text
    @current_block = @document.last
    tagpara(tag)
  end

  def tagpara(tag)
    indent(@state[:base_indent] + @register[')R'] + @register[')I'])
    unless tag.empty?
      temp_indent(-@register[')I'])
      tag.class == String ? unescape(tag) : @current_block.text = tag

      tag_width = typesetter_width(Block::Selenium.new(text: @current_block.text)).to_i

      # reset the font (in case it wasn't reverted cleanly in the tag - nis+(1) [SunOS 5.5.1])
      # so our unit conversions aren't affected.
      req_ft '1'
      req_ps "#{Font.defaultsize}"

      # is the tag wider than 3 points less than the indent?
      if @register[')I'] < tag_width + @state[:tag_padding]
        req_br
      else
        tab_width = to_em("#{@register[')I']}u")

        insert_tab(width: tab_width, stop: @register[')I'])
      end
    end
  end

  alias_method 'PP', 'P'
end
