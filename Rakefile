# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'garb'

task :default => 'test'

PROJ.name = 'garb'
PROJ.authors = ['Tony Pitale','Justin Marney']
PROJ.email = 'tony.pitale@viget.com'
PROJ.url = 'http://github.com/vigetlabs/garb'
PROJ.version = Garb::VERSION
PROJ.rubyforge.name = 'garb'
PROJ.test.files = FileList['test/**/*_test.rb']
PROJ.spec.opts << '--color'

# EOF
