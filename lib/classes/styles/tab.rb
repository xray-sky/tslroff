class Tab < Text
  def initialize(arg)
    super(arg)
    @width = arg[:width]
    @stop = arg[:stop]
    immutable!
  end
  def to_s ; text.to_s + "\t" ; end
  def to_html ; %(<span class="tab" style="width:#{@width}em;">#{@text.collect(&:to_html).join}</span>) ; end
  def length ; @text.join.length + 1 ; end
  def width ; @width ; end
  def stop ; @stop ; end
  def inspect ; "#{@text.collect(&:inspect).join} (tab)==#{@width}>>>" ; end
  # sentence_end? expects to be able to .match?
  def match?(r) ; @text.last.tap{|n|warn "text.last #{n.inspect}"}.match?(r) ; end
  alias text= immutable_setter
end
