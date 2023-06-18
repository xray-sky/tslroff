# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R4.5 Platform Overrides
#
# HTML format input.
#
# TODO: User's Guide has footer (with copyright we should maintain) outside </body>
# √     Shell Tools/man1 gives us related links; these need rewriting (apparently)
#          - plus allowing into Related Info menu
#       also might want related info menu in the Be Book. but not on the index pages? blah.
#       copyrights outputs too wide?? wtf
#       do an Anchors menu too? (probably should)
# REVIEW: also interesting use of <p class="body"> which could be considered to interfere with our CSS
#         ...but where is it defined in their manual? no css I can see.
#

class Source
  def magic
    case File.basename(@filename)
    when 'rcs.html' then 'HTML'
    else @magic
    end
  end
end

module BeOS_R4_5
  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'rcs.html'
      k.instance_variable_get('@source').lines[0].sub!(/^\s+{/, '')
      #k.instance_variable_set('@source_lines', k.instance_variable_get('@source').lines)
      #k.instance_variable_set('@source', Nokogiri::HTML(k.instance_variable_get('@source_lines').join))
    when 'doc'
      # this is a plain text file. correctly magicked, but no title, etc.
      # but we need nroff's to_html method back
      k.define_singleton_method :to_html, Nroff.instance_method(:to_html)
      k.define_singleton_method :parse_title, proc { 'Synchronization: Semaphores vs. Spinlocks' }
    when '_SEE_4.1__THINK_4.5'
      raise ManualIsBlacklisted, 'not useful'
    when /fm.html/, 'Metrowerks_License.html' # metrowerks
      # the metrowerks source is too heinous for nokogiri, too much malicious compliance to cope with
      # maybe the features are regular enough we can just... fudge it.
      # * none of the pages have titles
      # * all have navigation content before <body>
      source_lines = k.instance_variable_get('@source_lines')
      source_lines.each do |l|
        # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
        l.gsub!(%r{(</?)kbd>}, '\1tt>')
        # looks like these are the only two external links appearing in the metrowerks manual
        l.sub!(%r{<a href="http://www.metrowerks.com">(http://www.metrowerks.com)</a>}, '\1')
        l.sub!(%r{<a href="mailto:support@metrowerks.com">(support@metrowerks.com)</a>}, '\1')
      end
      source_lines.delete_at(source_lines.index { |n| n.match?(%r{^\s*<body bgcolor=#ffffff BACKGROUND="images/arnoldbg.gif">\s*$}) })
      k.instance_variable_set '@content_start', source_lines.index { |l| l.match? %r{<a name="Top">} }
      k.instance_variable_set '@content_end', source_lines.index { |l| l.match? %r{<a name="Bottom">} }
      k.define_singleton_method :to_html, k.method(:to_html_metrowerks)
    else
      encoding = nil
      case k.instance_variable_get '@source_dir'
      when /German/
        k.instance_variable_set '@language', 'de'
      when /French/
        k.instance_variable_set '@language', 'fr'
        encoding = Encoding::ISO_8859_1
      when /Japan/
        k.instance_variable_set '@language', 'ja'
        # TODO this is way wrong
        # but at least it causes Nokogiri to bail and give us a more or less blank page
        # (that is a valid link), and isn't full of absolute garbage. I can't find
        # a working encoding, not here, not on classic Mac, and not on BeOS itself,
        # and I wonder if it was mojibaked before it went on the disc
        encoding = Encoding::EUC_JP
      end
      source_lines = k.instance_variable_get('@source_lines')
      source_lines.each do |l|
        l.force_encoding encoding if encoding
        l.gsub!(/&(nbsp|mdash|lt|gt|copy)(?!;)/, '&\1;')
      end
      #k.instance_variable_set('@source', Nokogiri::HTML(source_lines.join))
    end
  end
end
