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
#   unbundleds - REVIEW input collections which may be mixed
# √ cope with pages named 'index' (e.g. DG-UX 5.4R3.00 index(3C))
#     - possibly by providing top level all-sections index (permuted or otherwise?)
# √   - done for now by renaming any page named index => _index and default => _default
#   unlink 404 refs, probably after auditing whether they are really missing
#   links with leading <br> (or other tags?) appear blank in Related menu (e.g. AUX SR8.0 cc(1))
#   rewrite links in "overlay" versions (e.g. DG-UX 4.31, 5.4.2T, etc.) to base manual
#   rewrite links in optional products (e.g. Apollo ada 1.0 links to ld(1)) to.. where exactly?
#   supplemental (non-man) docs recovered from mit afs
#   page titles for unbundled pages are messed up
# √ page titles for everything are messed up, due to the lack of
#     `vendor`, `os`, and `ver`, which used to be supplied as command line params into build.rb
#

# under chomedriver control, chrome won't load css from a file??
#$CSS_URL   = File.realpath("#{assets}/tslroff.css")
$CSS_URL = 'http://dev.online.typewritten.org/Manual/tslroff.css'

SRCROOT = '/Volumes/Museum/Manual/in'
#PUBROOT = '/Volumes/dev.online.typewritten.org/Manual'
#PUBROOT = '/Volumes/dev.online.typewritten.org/Manual.new'
PUBROOT = '/Volumes/Museum/Stuff/Manual.new'
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
task assets: [PUBROOT, :fonts, :css, :js, :gfx]

directory PUBROOT

task :fonts do
  cp_r 'assets/fonts/', PUBROOT
end

task :css do
  cp "#{ASSETS}/tslroff.css", PUBROOT
end

task :js do
  cp "#{ASSETS}/apropos.js", PUBROOT
end

task :gfx do
  gfxdir = "#{PUBROOT}/assets"
  directory(gfxdir).invoke

  # Future love paradise
  cp "#{ASSETS}/bell_logo.svg", PUBROOT
  cp_r %w[assets/flags assets/logos], gfxdir
end

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

require_relative 'lib/tasks/acorn'
require_relative 'lib/tasks/apollo'
require_relative 'lib/tasks/apple'
require_relative 'lib/tasks/ardent'
require_relative 'lib/tasks/atari'
require_relative 'lib/tasks/be'
require_relative 'lib/tasks/bell'
require_relative 'lib/tasks/bsdi'
require_relative 'lib/tasks/commodore'
require_relative 'lib/tasks/concurrent'
require_relative 'lib/tasks/dec'
require_relative 'lib/tasks/dell'
require_relative 'lib/tasks/dg'
require_relative 'lib/tasks/gould'
require_relative 'lib/tasks/hp'
require_relative 'lib/tasks/ibm'
require_relative 'lib/tasks/intergraph'
require_relative 'lib/tasks/kodak'
require_relative 'lib/tasks/mips'
require_relative 'lib/tasks/mit'
require_relative 'lib/tasks/motorola'
require_relative 'lib/tasks/mwc'
require_relative 'lib/tasks/nbi'
require_relative 'lib/tasks/next'
require_relative 'lib/tasks/novell'
require_relative 'lib/tasks/sco'
require_relative 'lib/tasks/sequent'
require_relative 'lib/tasks/sgi'
require_relative 'lib/tasks/solbourne'
require_relative 'lib/tasks/sony'
require_relative 'lib/tasks/sun'
require_relative 'lib/tasks/tektronix'
require_relative 'lib/tasks/ucb'
