Assets = File.realpath("#{__dir__}/lib/assets")
Srcroot = '/Volumes/Museum/Manual/in'
Docroot = '/Volumes/dev.online.typewritten.org/Manual'
$CSS_URL = 'http://dev.online.typewritten.org/Manual/tslroff.css'
Template = File.read "#{Assets}/manual_task.erb"

require_relative 'lib/rake'
require_relative 'lib/classes/manual'

desc 'Copy static file assets'
task :assets => [:fonts, :css]

task :fonts do |t|
  directory Docroot
  cp_r 'assets/fonts', Docroot
end

task :css do |t|
  cp "#{Assets}/tslroff.css", Docroot
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
