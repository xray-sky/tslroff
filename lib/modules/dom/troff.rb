# frozen_string_literal: true
#
# troff.rb
# ---------------
#    troff main
# ---------------
#
# frozen_string_literal: true
#
# REVIEW add anchors menu for .SH ?
# TODO .foot => /tsl-print.css (center, n% grey, extra margin-top)
# TODO tabs and probably other contrivances also need copying to print css. check especially eqn.
# TODO finish making the macro package selectable
#

require_relative '../../classes/webdriver'
require_relative '../../classes/textformatter'

class Troff < TextFormatter
  class Man  < Troff ; require_relative 'troff/tmac/an'  ; include Macros::An ; end
  class Man6 < Troff ; require_relative 'troff/tmac/an6' ; include Macros::An6 ; end
  class Ms   < Troff ; require_relative 'troff/tmac/s'   ; include Macros::S ; end

  %w[. request escape eqn tbl].each do |t|
    Dir.glob("troff/#{t}/*.rb", base: File.dirname(__FILE__)).sort.each do |i|
      require_relative i
    end
  end

  # reusable parts of Troff - e.g. for formatting tabs in VMS Help
  include Tab

  # preprocessor support
  include Eqn
  include Macros::Eqn
  include Tbl
  include Macros::Tbl

  DELIMITERS = %w[\002 \003 \005 \006 \007 " '].freeze # unused. REVIEW necessary? useful?
  REQUESTS = %w[
    ab ad af am as bd bp br c2 cc ce cf ch cs cu da de di ds dt ec el em eo ev ex fc fi
    fl fp ft hc hw hy ie if ig in it lc lf lg ll ls lt mc mk na ne nf nh nm nn nr ns nx
    os pc pi pl pm pn po ps rd rm rn rr rs rt so sp ss sv ta tc ti tl tm tr ul vs wh \"
  ].freeze # REVIEW \" isn't really a request but I want to not parse its args

  @@webdriver = nil

  def self.webdriver ; @@webdriver ; end
  def self.requests ; REQUESTS ; end # REVIEW smrtr? - does this need to be a class method??
  def self.use_groff? ; false ; end # REVIEW necessary? (I think no)

  def initialize(source)
    @header ||= Block::Header.new
    @footer ||= Block::Footer.new
    @related_info_heading ||= %r{(?:RELATED(?: |&nbsp;)INFORMATION|SEE(?: |&nbsp;)+ALSO|See(?: |&nbsp;)+Also)}

    #xinit_selenium
    @@webdriver ||= WebDriver.new backing_store: ENV['WEBDRIVER_CACHE']
    @@pixels_per_inch ||= @@webdriver.ppi

    super(source)

    xinit_ec
    xinit_nr
    xinit_in

    # Remember there are init_ methods in the Macros modules, too
    methods.each do |m|
      send(m) if m.to_s.start_with? 'init_'
    end
  end

  def to_html(halt_on: nil)
    @current_block = blockproto
    @document << @current_block
    loop do
      parse(next_line)
      return true if halt_on and instance_variable_get halt_on
    #rescue EndOfEqn, EndOfTbl
    #  # .EN, .TE without .EQ, .TS - will be caught in .EQ/.TS if
    #  # this suppressed exceptions in the logs but didn't include the warning? disabling for now
    #  # also not clear why this was happening e.g. Domain/IX SR9.0 BSD eqn(1) - does have .EN/.EQ pairs
    #  warn "encountered #{e.class} outside of relevant preprocessor context"
    #  retry
    rescue StopIteration
      # prevent double header/footer if e.g. we didn't hit halt_on condition & re-entered later
      if halt_on and !instance_variable_get halt_on
        warn "reached end of document without setting #{halt_on}!"
        return false
      end
      # TODO perform end-of-input trap macros from .em;
      # REVIEW maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
      # TODO this is quite wrong if we are doing halt_on e.g. from parse_title and don't find one (e.g. unix v7 intro.0)
      if @named_strings.key? :header
        unescape @named_strings[:header], output: @header
        @document.insert(0, @header)
      end
      if @named_strings.key? :footer
        unescape @named_strings[:footer], output: @footer
        @document << @footer
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

  def next_line
    l = super.tap { @register['.c'].incr }.chomp # REVIEW do we ever need to perserve the trailing \n ?

    # Hidden newlines -- REVIEW does this need to be any more sophisticated?
    # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
    # TODO the new-line at the end of a comment cannot be concealed.
    # Doing it here means I don't have to do it everywhere we are doing local next_lines (.TS, .if, etc.)
    l.chop! << next_line if escapes? and l.end_with?(@escape_character) and l[-2] != @escape_character

    @line = l
  end

  # TODO find where we're inserting paragraphs (with and without margin-top:0) containing only
  #      a single space. these are being output but are apparently irrelevant/invisible.
  #      might have to do an a/b comparison to be sure. e.g. eqn(1) [SunOS 5.5.1]

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = Block::Paragraph)
    break_adj # eat a break at the end of a block; this wouldn't have whitespaced. but html will REVIEW is this working??
              # - no, it's eating the final break in a nofill, when we go to .ig! but we don't need blockproto in .ig
              #   so that is the solution for now. but watch this.
    type = Block::Monospace if @cs and type == Block::Paragraph
    block = type.new
    block.style[:section] = @section_heading if @section_heading
    block.style[:linkify] = true if @section_heading =~ @related_info_heading
    block.style.css[:margin_top] = "#{to_em(@register[')P'])}em" unless @register[')P'] == @default_para_distance
    block.style.css[:margin_top] = '0' if nospace? #if nofill? or nospace?
    block.style.css[:margin_left] = "#{to_em(@register['.i'])}em"
    block.style.css.delete(:margin_left) if @register['.i'] == @base_indent
    block.style.css[:text_align] = [ 'left', 'justify', nil, 'center', nil, 'right' ][@register['.j']] unless @register['.j'] == 1
    block.style.css[:text_align] = 'left' if noadj? # .na sets left adjust without changing .j
    block.style.attributes[:class] = Regexp.last_match[1].downcase if @section_heading&.match(/^(name|synopsis)$/i) and block.is_a? Block::Paragraph
    block
  end
end
