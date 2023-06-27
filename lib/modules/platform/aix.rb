# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# IBM AIX Platform Overrides
#

module AIX

  def page_title
    "#{@manual_entry}(#{@manual_section})"
  end

  def detect_links_quoted(line)
    @refs_continue = :quoted
    links = line.scan(/"(.+?)[,.]?"/).map do |text, _x|
      [ text, "#{text.split(/[,:]\s?/).first}.html" ]
    end.to_h

    if line.count('"').odd # an odd number of double quotes; some ref is split to next line
      @refs_continue = :quoted_break
      line.scan(/"([^"]+),?\s*$/).map do |text, _x|
        @continued_ref = "#{text.split(/[,:]\s?/).first}.html"
        [ text, @continued_ref ]
      end.to_h.merge(links)
    else
      links
    end
  end

  def detect_links_quoted_continue(line)
    # gonna get two refs in related menu instead of one
    # there's code there to join them if one ends in ','

    (initial, rest) = line.split('"', 2)
    text = initial.lstrip

    # we might not have a @continued_ref if the previous line ended with a lone "
    # did we get one?
    if @continued_ref
      ref = @continued_ref
    else
      ref = "#{text.split(/[,:]\s?/).first}.html"
      @continued_ref = ref
    end

    remainder = if rest
                  text.sub!(/([,.]?)\s*$/, '')
                  @continued_ref = nil
                  @refs_continue = :quoted
                  detect_links_quoted(rest)
                else # the quoted ref might not end on this line (AIX RT 2.2.1 sockets(3))
                  @continued_ref = ref
                  @refs_continue = :quoted_break
                  {}
                end

    { text => ref }.merge(remainder)
  end

  def detect_links_unquoted(line)
    @refs_continue = :unquoted
    line.scan(/[Tt]he (?<cmdlist>[^.]+?)(?:\s+command|\s+file|\s+miscellaneous facilit|\s+program|\s+procedure|\s+system call|$)/).map do |text, _x|
      refs = text.split(/(?:,? and|,)\s+/)
      refs.map do |ref|
        [ ref, "#{ref}.html" ]
      end
    end.flatten(1).to_h
  end

  def detect_links_unquoted_continue(line)
    detect_links_unquoted "the #{line.sub(/^and /, '')}"
  end

end


