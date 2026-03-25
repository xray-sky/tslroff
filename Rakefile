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
#   cope with pages named 'index' (e.g. DG-UX 5.4R3.00 index(3C))
#     - possibly by providing top level all-sections index (permuted or otherwise?)
# √   - done for now by renaming any page named index => _index and default => _default
#   unlink 404 refs, probably after auditing whether they are really missing
#   rewrite links in "overlay" versions (e.g. DG-UX 4.31, 5.4.2T, etc.) to base manual
#   rewrite links in optional products (e.g. Apollo ada 1.0 links to ld(1)) to.. where exactly?
#   supplemental (non-man) docs recovered from mit afs
#   page titles for unbundled pages are messed up
#   page titles for everything are messed up, due to the lack of
#      `vendor`, `os`, and `ver`, which used to be supplied into the build
#

# under chomedriver control, chrome won't load css from a file??
#$CSS_URL   = File.realpath("#{assets}/tslroff.css")
$CSS_URL = 'http://dev.online.typewritten.org/Manual/tslroff.css'

Srcroot = '/Volumes/Museum/Manual/in'
Pubroot = '/Volumes/dev.online.typewritten.org/Manual'
Assets = File.realpath("lib/assets")
Template = File.read "#{Assets}/manual.erb"

# TODO this arrangement is only profiling the rakefile - is not what we wanted
if ENV['RUBY_PROFILE']
  require 'ruby-prof'
  RubyProf.start
end

require_relative 'ext/rake/namespace'
require_relative 'lib/rake'
require_relative 'lib/classes/manual'


desc 'Copy static file assets'
task :assets => [:fonts, :css, :gfx]

task :fonts do |t|
  directory Pubroot
  cp_r 'assets/fonts', Pubroot
end

task :css do |t|
  cp "#{Assets}/tslroff.css", Pubroot
end

task :gfx do |t|
  cp "#{Assets}/bell_logo.svg", Pubroot

  # Future love paradise
  #gfxdir = "#{Pubroot}/assets"
  #directory gfxdir
  #cp_r "#{Assets}/flags", gfxdir
  #cp_r "#{Assets}/logos", gfxdir
end

# manual collections

require_relative 'lib/tasks/acorn'
require_relative 'lib/tasks/alias'
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

collectionNamespace '_internal' do
  collectionNamespace '_test' do
    manualNamespace '_pic',
      odir: '_internal/_test/_pic',
      idir: '_test',
      sources: %w[ ./pic* ]
    manualNamespace '_tbl',
      odir: '_internal/_test/_tbl',
      idir: '_test',
      sources: %w[ ./stbl* ]
  end
end

if ENV['RUBY_PROFILE']
  profile_results = RubyProf.stop
  RubyProf::FlatPrinter.new(profile_results).print(STDOUT)
  #RubyProf::GraphPrinter.new(profile_results).print(STDOUT, {})
end
