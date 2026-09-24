# frozen_string_literal: true
# encoding: UTF-8
#
# tslroff
#
# Created by R. Stricklin <bear@typewritten.org> on 01/05/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# * Act as typesetter for troff source, with HTML output
#   to be formatted as much as possible by CSS. Presentation
#   should approach typsetter quality by preserving the macro
#   package(s) as much as possible. Macro packages may be
#   manually converted to ruby (tmac.an) or automatically
#   processed at runtime (OSF/1 osml & rsml, various individual
#   manual entries).
#
# * Act as line printer for nroff output, with HTML output;
#   gives terminal quality results for systems that do not
#   manual source, non-UNIX systems (VMS helplib, Aegis help).
#
# * Rewrites HTML manuals for conformance to site-specific
#   standards (Inferno, BeOS, AIX).
#
#
# remember, remember https://github.com/bbatsov/ruby-style-guide
#
# TODOs
#   metadata: add sourcefile mtime
# √ metadata: add acknowledgements for archive contributions
#   unbundleds - REVIEW input collections which may be mixed
# √ cope with pages named 'index' (e.g. DG-UX 5.4R3.00 index(3C))
# √   - possibly by providing top level all-sections index (permuted or otherwise?)
# √   - done for now by renaming any page named index => _index and default => _default
#   unlink 404 refs, probably after auditing whether they are really missing
#   links with leading <br> (or other tags?) appear blank in Related menu (e.g. AUX SR8.0 cc(1))
#   rewrite links in "overlay" versions (e.g. DG-UX 4.31, 5.4.2T, etc.) to base manual
#   rewrite links in optional products (e.g. Apollo ada 1.0 links to ld(1)) to.. where exactly?
#   supplemental (non-man) docs recovered from mit afs
# √ page titles for unbundled pages are messed up
# √ page titles for everything are messed up, due to the lack of
#     `vendor`, `os`, and `ver`, which used to be supplied as command line params into build.rb
# √ connect language metadata to the index pages
#   turns out, the CMU fonts don't actually give Asian language glyphs; some other font is being used
#     for the lang='ja' pages. this defeats our webfont strategy for making tabs work predictably: our
#     carefully handcrafted tabs are going to be goofy depending on the user agent's local fonts.
#

# under chomedriver control, chrome won't load css from a file??
#$CSS_URL   = File.realpath("#{assets}/tslroff.css")
$CSS_URL = 'http://dev.online.typewritten.org/Manual/tslroff.css'

SRCROOT = '/Volumes/Museum/Manual/in'
PUBROOT = '/Volumes/dev.online.typewritten.org/Manual'
#PUBROOT = '/Volumes/Museum/Manual/out/next'
ASSETS = File.realpath('lib/assets')
INDEX_TEMPLATE  = File.read "#{ASSETS}/index.erb"
MANUAL_TEMPLATE = File.read "#{ASSETS}/manual.erb"

require 'ruby-prof' if ENV['RUBY_PROFILE']

require_relative 'ext/string/to_html'
require_relative 'ext/rake/namespace'
require_relative 'lib/rake'
require_relative 'lib/classes/manual'

desc 'Build everything'
task all: [:assets]

desc 'Copy static file assets'
task assets: [:index, :fonts, :css, :js, :gfx]

directory PUBROOT

task :index => [PUBROOT] do
  cp 'assets/index.html', PUBROOT
end

task :fonts => [PUBROOT] do
  cp_r 'assets/fonts/', PUBROOT
end

task :css => [PUBROOT] do
  cp "#{ASSETS}/tslroff.css", PUBROOT
end

task :js => [PUBROOT] do
  cp "#{ASSETS}/apropos.js", PUBROOT
end

task :gfx => [PUBROOT] do
  gfxdir = "#{PUBROOT}/assets"
  directory(gfxdir).invoke

  # Future love paradise
  cp "#{ASSETS}/bell_logo.svg", PUBROOT
  cp_r %w[assets/flags assets/logos], gfxdir
end

# load these first, to allow other collections to inherit
# as needed from "standard" UNIX or BSD
require_relative 'collections/bell'
require_relative 'collections/ucb'

require_relative 'collections/acorn'
require_relative 'collections/apollo'
require_relative 'collections/apple'
require_relative 'collections/ardent'
require_relative 'collections/atari'
require_relative 'collections/be'
require_relative 'collections/bsdi'
require_relative 'collections/commodore'
require_relative 'collections/concurrent'
require_relative 'collections/dec'
require_relative 'collections/dell'
require_relative 'collections/dg'
require_relative 'collections/fujitsu'
require_relative 'collections/gould'
require_relative 'collections/hp'
require_relative 'collections/ibm'
require_relative 'collections/intergraph'
require_relative 'collections/isc'
require_relative 'collections/mips'
require_relative 'collections/mit'
require_relative 'collections/motorola'
require_relative 'collections/mwc'
require_relative 'collections/nbi'
require_relative 'collections/next'
require_relative 'collections/novell'
require_relative 'collections/qnx'
require_relative 'collections/sco'
require_relative 'collections/sequent'
require_relative 'collections/sgi'
require_relative 'collections/solbourne'
require_relative 'collections/sony'
require_relative 'collections/sun'
require_relative 'collections/tektronix'
require_relative 'collections/ti'

# manual source collections

collection_namespace '_internal' do
  collection_namespace '_test' do
    manual_namespace '_pic',
      vendor_class: UNIX::V7,
      odir: '_internal/_test/_pic',
      idir: '_test',
      sources: %w[./pic*]
    manual_namespace '_tbl',
      vendor_class: UNIX::V7,
      odir: '_internal/_test/_tbl',
      idir: '_test',
      sources: %w[./stbl*]
  end
end
