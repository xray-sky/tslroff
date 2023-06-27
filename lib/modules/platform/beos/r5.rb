# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BeOS R5 Platform Overrides
#
# HTML format input.
#
# TODO
#   User's Guide has footer (with copyright we should maintain) outside </body>
# √ Shell Tools/man1/gcc.html, rcsfile.html start with "Content-type: text/html"
# √                  rcs.html, rcsintro.html, uuencode.html start with garbage
# √ Shell Tools/man1 output is a mess (CSS clash)
# √ Shell Tools/man1 gives us related links; these need rewriting (apparently)
#      - plus allowing into Related Info menu
#   also might want related info menu in the Be Book. but not on the index pages? blah.
#   figure out @output_directory which makes the css link correctly for everything
#      - stuff in the root, outside the book directories, gets one too many ../
#      - or if we fix the root pages, the stuff in the book directories gets one too few
#   copyrights outputs too wide?? wtf
#   do an Anchors menu too? (probably should)
# √ can we use roman (don't italic) <a> without href= ? metroworks body text is all <a name=>
#
# REVIEW
#   also interesting use of <p class="body"> which could be considered to interfere with our CSS
#      ...but where is it defined in their manual? no css I can see.
#

class Source
  def magic
    case File.basename(@filename)
    when 'gcc.html', 'rcs.html', 'rcsfile.html', 'rcsintro.html', 'uuencode.html' then 'HTML'
    else @magic
    end
  end
end

module BeOS_R5
  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'gcc.html', 'rcsfile.html', 'rcsintro.html'
      k.instance_variable_get('@source').lines[0] = ''
    when 'rcs.html'
      k.instance_variable_get('@source').lines[0].sub!(/^\s+{/, '')
    when 'uuencode.html'
      k.instance_variable_get('@source').lines.slice!(0, 40)
    when /fm.html/, 'Metrowerks_License.html' # metrowerks
      # the metrowerks source is too heinous for nokogiri, too much malicious compliance to cope with
      # maybe the features are regular enough we can just... fudge it.
      # * none of the pages have titles
      # * all have navigation content before <body>
      source_lines = k.instance_variable_get('@source').lines
      source_lines.each do |l|
        # they use <kbd> interchangeably with <tt>. we use <kbd> for our own purposes, so don't let them
        l.gsub!(%r{(</?)kbd>}, '\1tt>')
        # looks like these are the only two external links appearing in the metrowerks manual
        l.sub!(%r{<a href="http://www.metrowerks.com">(http://www.metrowerks.com)</a>}, '\1')
        l.sub!(%r{<a href="mailto:support@metrowerks.com">(support@metrowerks.com)</a>}, '\1')
      end
      source_lines.delete_at(source_lines.index { |n| n.match?(%r{^\s*<body bgcolor=#ffffff BACKGROUND="images/arnoldbg.gif">\s*$}) })
      k.instance_variable_set('@content_start', source_lines.index { |l| l.match? %r{<a name="Top">} })
      k.instance_variable_set('@content_end', source_lines.index { |l| l.match? %r{<a name="Bottom">} })
      k.define_singleton_method :to_html, k.method(:to_html_metrowerks)
    end
  end
end
