# troff.rb
# ---------------
#    troff main
# ---------------
#
# REVIEW add anchors menu for .SH ?
# TODO .foot => /tsl-print.css (center, n% grey, extra margin-top)
# TODO tabs and probably other contrivances also need copying to print css. check especially eqn.
# TODO finish making the macro package selectable
#

#require_relative 'groff'
require_relative '../../classes/webdriver'

class Troff < TextFormatter

  %w[. request escape eqn tbl].each do |t|
    Dir.glob("#{File.dirname(__FILE__)}/troff/#{t}/*.rb").each do |i|
      require i
    end
  end

  require_relative 'troff/tmac/an'
  include Macros::An
  include Eqn
  include Macros::Eqn
  include Tbl
  include Macros::Tbl

  Delimiters = %w[ \002 \003 \005 \006 \007 " ' ] # unused. REVIEW necessary? useful?
  Requests = %w[ ab ad af am as bd bp br c2 cc ce cf ch cs cu da de di ds dt ec el em eo ev ex fc fi
                 fl fp ft hc hw hy ie if ig in it lc lf lg ll ls lt mc mk na ne nf nh nm nn nr ns nx
                 os pc pi pl pm pn po ps rd rm rn rr rs rt so sp ss sv ta tc ti tl tm tr ul vs wh \" ] # REVIEW \" isn't really a request but I want to not parse its args

  @@webdriver = nil

  def self.webdriver ; @@webdriver ; end
  def self.requests ; Requests ; end  # REVIEW smrtr?
  def self.useGroff? ; false ; end  # REVIEW necessary? (I think no)

  def initialize(source)
    @source = source
    @register = {}
    @state = { header: Block::Header.new, footer: Block::Footer.new }
    @related_info_heading ||= %r{(?:RELATED(?: |&nbsp;)INFORMATION|SEE(?: |&nbsp;)+ALSO|See(?: |&nbsp;)+Also)}

    #xinit_selenium
    @@webdriver ||= WebDriver.new
    @@pixels_per_inch ||= @@webdriver.ppi

    xinit_ec
    xinit_nr
    xinit_in

    # Remember there are init_ methods in the Macros modules, too
    methods.each do |m|
      send(m) if m.to_s.start_with? 'init_'
    end

    super(source)
  end

  # TODO / REVIEW .so ugly
  def warn(msg)
    super("#{"#{@so_chain} [#{input_line_number}]: " if @so_chain}#{msg}")
  end

  def to_html(halt_on: nil)
    @current_block = blockproto
    @document << @current_block
    loop do
      parse(next_line)
      return true if halt_on and instance_variable_get halt_on
    rescue StopIteration
      # prevent double header/footer if e.g. we didn't hit halt_on condition & re-entered later
      if halt_on and !instance_variable_get halt_on
        warn "reached end of document without setting #{halt_on}!"
        return false
      end
      # TODO perform end-of-input trap macros from .em;
      # REVIEW maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
      # TODO this is quite wrong if we are doing halt_on e.g. from parse_title and don't find one (e.g. unix v7 intro.0)
      if @named_strings[:header]
        unescape @named_strings[:header], output: @state[:header]
        @document.insert(0, @state[:header])
      end
      if @named_strings[:footer]
        unescape @named_strings[:footer], output: @state[:footer]
        @document << @state[:footer]
      end
      return "#{@document.collect(&:to_html).join}\n    </div>\n</div>" # REVIEW closes main doc divs start ed by :th
    rescue => e
      warn "#{@line.inspect} -"
      warn e
      warn e.backtrace.join("\n")
    end
  end

  def output_directory
    @manual_section and return "man#{@manual_section.downcase}"
    warn "reading output directory without section set"
    ''
  end

  private

  def debug(line, *msg)
    return unless input_line_number == line
    block_given? ? yield(msg) : warn("debug: #{msg.collect(&:inspect).join(' ')}")
  end

  def input_line_number
    @register['.c']&.value || 0
  end

  def next_line
    line = @lines.tap { @register['.c'].incr }.next.chomp  # REVIEW do we ever need to perserve the trailing \n ?
    #line = @lines.tap { @register['.c'].incr }.next.chomp.tap { |n| warn "reading new line #{n.inspect}" }

    # Hidden newlines -- REVIEW does this need to be any more sophisticated?
    # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
    # TODO the new-line at the end of a comment cannot be concealed.
    # Doing it here means I don't have to do it everywhere we are doing local next_lines (.TS, .if, etc.)
    # But, this will give us "bad" line numbers for warnings. I can probably live with that.
    line.chop! << next_line if @escape_character and line.end_with?(@escape_character) and line[-2] != @escape_character

    @line = line
  end

  # TODO find where we're inserting paragraphs (with and without margin-top:0) containing only
  #      a single space. these are being output but are apparently irrelevant/invisible.
  #      might have to do an a/b comparison to be sure. e.g. eqn(1) [SunOS 5.5.1]

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = Block::Paragraph)
    break_adj # eat a break at the end of a block; this wouldn't have whitespaced. but html will REVIEW is this working??
              # - no, it's eating the final break in a nofill, when we go to .ig! but we don't need blockproto in .ig
              #   so that is the solution for now. but watch this.
    type = Block::Monospace if @state[:cs]
    block = type.new
    block.style[:section] = @state[:section] if @state[:section]
    block.style[:linkify] = true if @state[:section] =~ @related_info_heading
    block.style.css[:margin_top] = "#{to_em(@register[')P'])}em" unless @register[')P'] == @state[:default_pd]
    block.style.css[:margin_top] = '0' if nospace? #if nofill? or nospace?
    block.style.css[:margin_left] = "#{to_em(@register['.i'])}em"
    block.style.css.delete(:margin_left) if @register['.i'] == @state[:base_indent]
    block.style.css[:text_align] = [ 'left', 'justify', nil, 'center', nil, 'right' ][@register['.j']] unless @register['.j'] == 1
    block.style.css[:text_align] = 'left' if noadj? # .na sets left adjust without changing .j
    block.style.attributes[:class] = 'synopsis' if @state[:section]&.match?(/^synopsis$/i) and block.is_a? Block::Paragraph
    block
  end

end
