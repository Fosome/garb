require 'rake/gempackagetask'
require 'rake/testtask'

$:.unshift File.expand_path('../lib', __FILE__)
require 'garb'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name              = 'garb'
  s.version           = Garb::Version.to_s
  s.has_rdoc          = false
  s.rubyforge_project = 'viget'
  s.summary           = "Google Analytics API Ruby Wrapper"
  s.authors           = ['Tony Pitale']
  s.email             = 'tony.pitale@viget.com'
  s.homepage          = 'http://github.com/vigetlabs/garb'
  s.files             = %w(README.md Rakefile) + Dir.glob("lib/**/*")
  s.test_files        = Dir.glob("test/**/*")

  s.add_dependency("crack", [">= 0.1.6"])
  s.add_dependency("activesupport", [">= 2.2.0"])
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

begin
  require 'rcov/rcovtask'

  desc "Generate RCov coverage report"
  Rcov::RcovTask.new(:rcov) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts << "-x \"test/*,gems/*,/Library/Ruby/*,config/*\" -x lib/garb.rb -x lib/garb/version.rb --rails" 
  end
rescue LoadError
  nil
end

task :default => 'test'

# EOF
