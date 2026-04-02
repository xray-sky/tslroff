# frozen_string_literal: true
#
# parse.rb
# ---------------
#    Troff.parse source
# ---------------
#
# some escapes are processed before we ever do request parsing?!
#
# Multiple inter-word space characters found in the input are retained §4.1
# unescaped trailing spaces are not. (but not until output, .ds can define
# a string with as much trailing space as provided)
#

class Troff

  private

  def parse(line)
    if escapes?
      # lines starting with \! are read in copy mode and transparently output
      # seemingly, with a break after
      if line.start_with? "#{@escape_character}!"
        warn "transparent throughput? #{line.inspect}"
        @current_block << unescape(line, copymode: true)[2..-1]
        br
        return true
      end
    end

    line.start_with?(@cc, @c2) ? request(unescape line, copymode: true) : output(line)
  end

  ###
  ### ordinary text
  ###

  def output(line)
    # A blank text line causes a break and outputs a blank line
    # exactly like '.sp 1' §5.3 - also in nofill mode
    #
    # a line with only spaces counts as a blank line. a tab does not.
    #
    # REVIEW
    # my .sp outputs Block::VerticalSpace instead of causing a <br />
    #
    # TODO hm, I'm getting an extra .br (because of a space adjustment??)
    #      on consecutive blank text lines. - hesinfo(1) [AOS-4.3]
    if line.empty?
      br
      @current_block << '&nbsp;'
      br
      return
    end

    # initial spaces also cause a break. §4.1
    # -- but don't break again unnecessarily (i.e. in nofill mode).
    # -- tabs don't count for this
    if line.start_with? ' '
      line.prepend("\\") # force this initial space to appear in the output
      br
    end

    # field processing
    #
    # TODO lines with escape chars prior to tabs result in that text living outside the tab span!
    #      csh(1) [GL2-W2.5]
    # - to this end, fix up the text block if we just broke. we oughtn't need to deal with
    #   a mid-unesc break.
    #
    # there's a special case if we just had a break. we don't want to set the tab width on that.
    # REVIEW is there a more orderly way of handling this?
    #
    # TODO split the output, with tabs and fields and translation, from unescape
    #      that's going to be hard as long as we are spitting e.g. font changes out
    #      directly into the document, instead of returning
    #
    # something diabolical is happening with empty fields / too many separators
    #   -- see RISCiX 1.2 rcsfile(5)
    #
    # looks like postprocessed tbl involves fields as well.

    # skip entirely if all field markers are preceeded by single escape.
    if fields? and line.match?(/(?<!(?<!#{@resc})#{@resc})#{Regexp.quote @field_delimiter}/)
      # don't match a field character preceeded by a single escape.
      fields = line.split(%r{(?<!(?<!#{@resc})#{@resc})#{Regexp.quote @field_delimiter}})
      # if the last character is a delimiter, then the last index is a field (otherwise, ordinary text)
      str = line.end_with?(@field_delimiter) ? '' : fields.pop
      # the first part is outside the field. if delim is the first character, the string will be empty
      unescape __unesc_w(fields.shift)
      fields.each do |field|
        # this mostly mirrors tab processing
        warn "empty field - attempting to use for positioning only" and next if field.empty? # no pad REVIEW this is an attempt to cover rcsfile(5) usage
        warn "don't know how to do field padding except at right! #{@field.inspect}" unless !field.nil? or field.end_with?(@field_pad_character) # empty fields won't have padding
	    unescape __unesc_w(field.gsub(/#{Regexp.escape(@field_pad_character)}$/, '')) # TODO pad
   		stop = next_tab # overflow?
        if stop
          insert_tab(width: to_em(stop - @current_block.last_tab_position), stop: stop)
        else
          # prevent exception on running out of tabs
          warn "out of fields with tabs=#{@tabstops.inspect}! (field: #{field.inspect})"
          @current_block << ' '	# REVIEW any space at all is possibly not correct; nroff just runstexttogether when there are no more tabs
        end
      end
      unescape(__unesc_w(str)) # final not-a-field
    else
      # we actually want to do this in a better order than l->r
      # because of ar(4) [SunOS 5.5.1] :: [30-31]
      unescape(__unesc_w(line))
    end

    if nofill?
      # this duplicates .br, but if that is guarded on nofill...
      @current_block << LineBreak.new(font: @current_block.terminal_font.dup,
                                      style: @current_block.terminal_text_style.dup)
    else
      space_adj
    end

    # reset no-space mode, which is only in effect for one output line
    rs if nospace?
    process_input_traps
  end

  ###
  ### requests / macros
  ###

  # TODO named strings can be invoked as macros! and vice versa!
  #   figure out how that works. quoting, breaking, these are odd

  def request(line)
    breaking = line[0] != @c2
    # one of the few places tabs and spaces are equivalent: between cc & req
    rpos = line.index(/\S/, 1) || return # may have single @cc or @c2
    req = line[rpos, 2].rstrip
    argstr = line[rpos + 2..-1]&.lstrip || ''

    # until we bring back comments stripped in parse so .\" can work again:
    #return if req.empty?

    if request?(req) and respond_to?(req)
      # it's not a macro and we haven't renamed it
      send req, __unesc_w(argstr), breaking: breaking
    else
      # macro - unescaped trailing spaces are stripped; getargs sets register .$
      args = getargs __unesc_w(argstr)
      send req, *args
    end
  rescue NoMethodError => e
    # it's some normal screwup; use the standard error reporting
    raise unless e.message.match(/^undefined method .+ for #<#{self.class}:/)

    # Control lines with unrecognized names are ignored. §1.1
    warn "Unrecognized request #{breaking ? @cc : @c2 }#{req} #{argstr}"
  end
end
