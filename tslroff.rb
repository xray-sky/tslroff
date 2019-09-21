#! /usr/bin/env ruby
#
# tslroff.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# convert troff source to HTML, to be formatted as much as possible by CSS.
# presentation should approach typesetter quality
# preserve as much as possible stuff going on in tmac.an, though this may
# be a manual step.
#
# convert nroff output to HTML; terminal quality results
# for platforms that do not ship sources.
#
# eventually, support rewriting HTML for site-specific standards
# (AIX, BeOS, etc.), Domain/OS or VMS help files, etc.
#
# remember, remember https://github.com/bbatsov/ruby-style-guide
#
require 'date'
require 'nokogiri'

$LOAD_PATH << File.dirname(__FILE__)
$CSS = File.expand_path(File.dirname(__FILE__)) + '/tslroff.css'

require 'classes/manual.rb'


# TODO: parse arguments properly
raise ArgumentError, 'need an input file!' if ARGV[0].nil?


cwd = Dir.getwd
(ipath,ifile) = ARGV[0].scan(%r|^(.+)/(.+)$|)[0]
#Dir.chdir(ipath)

begin
  src = Manual.new(ARGV[0])
rescue FileIsLinkError
  target = $!.to_s
  File.symlink("#{target}.html", "#{ifile}.html")
  exit(0)
end

manual  = src.to_html
related = Nokogiri::HTML(manual).search('a')

related_menu = %(
		<div class="menu_title">
			<h1>Related Articles</h1>
		</div>
		<div class="menu">

#{related.collect do |link|
%(          	<p><a href="#{link['href']}">
          	    <item><tt>#{link.content}</tt></item></a></p>)
end.join("\n")}

		</div>
)

puts <<DOC
<head>
  <link rel="stylesheet" type="text/css" href="tslroff.css"></link>
</head>
<body>
<div id="left">
	<div id="menu">
		<div class="menu_title">
			<h1>Museum</h1>
		</div>
		<div class="menu">

          	<p><a href="/"><item>Home</item></a></p>
         	<p><a href="/Systems/"><item>Lab Overview</item></a></p>
         	<p><a href="/Articles/"><item>Retrotechnology Articles</item></a></p>
			<p class="here"><small>&rArr; Online Manual</small></p>
         	<p><a href="/Media/"><item>Media Vault</item></a></p>
          	<p><a href="/Software/"><item>Software Library</item></a></p>
          	<p><a href="/Projects/"><item>Restoration Projects</item></a></p>
          	<p><a href="/wanted.html"><item>Artifacts Sought</item></a></p>

		</div>
#{related_menu if related.any?}
	</div>
</div>

<div id="right">
<div id="content">
#{manual}

	<div class="bottom_deco">
		<table><tr><td class="left"></td><td></td><td class="right"></td></tr></table>
	</div>
</div>

	<div id="footer">

		<p>Typewritten Software &bull;
		<a href="mailto:bear@typewritten.org">bear@typewritten.org</a> &bull;
		Edmonds, WA 98026</p>

	</div>
</div>
</body>
</html>
DOC
