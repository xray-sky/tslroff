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
# TODO: what does ".TP &" mean? (see: machid.1 [GL2-W2.5])
# TODO: AOS likes passing invalid expressions to .TP (and .IP) - nroff seems to ignore
#       them and keep previous indents, instead of changing them to 0 (as the expression evaluates)
#       ...how?? restore.tape(8), xlogin(8), etc. -- also ffbconfig(1m) [SunOS 5.5.1]
#

module Troff
  def req_TP(indent = nil, *_args)
    warn "pointlessly received extra arguments to .TP #{_args.inspect} - why??" unless _args.empty?
    indent = nil if indent == '&'	# TODO: ???
    req_it('1', :finalize_TP, indent)
    @document << blockproto
    @current_block = Block.new(type: :bare)
    @current_tabstop = @current_block.text.last
    @current_tabstop[:tab_stop] = 0

  end

  def finalize_TP(indent)
    @register[')I'].value = to_u(indent, :default_unit => 'n') if indent
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
      @@webdriver.get(Block.new(type: :bare, text: @current_block.text).to_selenium)
      tag_width = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i

      # reset the font (in case it wasn't reverted cleanly in the tag - nis+(1) [SunOS 5.5.1])
      # so our unit conversions aren't affected.
      req_ft('1')
      req_ps(Font.defaultsize)

      # is the tag wider than 3 points less than the indent?
      if @register[')I'] < tag_width + @state[:tag_padding]
        req_br
      else
        tab_width = to_em("#{@register[')I']}u")

        # The odd insertion is so we don't clobber tags which themselves include tabs.
        # - adb(1) [GL2-W2.5]
        #
        # The "control character" is so the Text object holding the inserted tab
        # isn't skipped for being "empty". it'll translate to nothing (an empty string)
        # during output processing. Otherwise, it's as if there had been a tab.

        tab = Text.new(text: "&roffctl_nil;")
        tab.instance_variable_set(:@tab_width, "#{tab_width}em")
        @current_block.text = @current_block.text.insert(0, tab)

        @current_block << '&roffctl_endspan;'
        apply { @current_block.text.last[:tab_stop] = 0 }
        @current_tabstop = @current_block.text.last
      end
      @current_tabstop.instance_variable_set(:@no_space_adj, true)
    end
    @state[:break_suppress] = true # suppress break between tag and para when in nofill mode -- prtdiag(1m) [SunOS 5.5.1]
  end

end
