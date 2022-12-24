# TP.rb
# -------------
#   troff
# -------------
#
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

module Troff
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
    @current_block = Block::Bare.new

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

      # get the width
      @@webdriver.get(Block::Selenium.new(text: @current_block.text).to_html)
      tag_width = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i

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
      #@current_block.text.last.instance_variable_set(:@no_space_adj, true)
    end
    #@state[:break_suppress] = true # suppress break between tag and para when in nofill mode -- prtdiag(1m) [SunOS 5.5.1]
  end

end
