Gem::Specification.new do |s|
  s.name     = "garb"
  s.version  = "0.1.1"
  s.date     = "2009-04-22"
  s.summary  = "Google Analytics API Ruby Wrapper"
  s.email    = "tony.pitale@viget.com"
  s.homepage = "http://github.com/vigetlabs/garb"
  s.description = "A ruby gem to aid in the use of the Google Analytics API"
  s.has_rdoc = false
  s.authors  = ["Tony Pitale"]
  s.files    = ["History.txt", 
		"README.md",
		"Rakefile",
		"garb.gemspec",
		"lib/garb.rb",
		"lib/garb/authentication_request.rb",
		"lib/garb/data_request.rb",
		"lib/garb/profile.rb",
		"lib/garb/report.rb",
		"lib/garb/report_parameter.rb",
		"lib/garb/report_response.rb",
		"lib/garb/session.rb",
		"lib/garb/extensions/symbol.rb",
		"lib/garb/extensions/string.rb",
		"lib/garb/extensions/operator.rb",
		"lib/garb/extensions/happymapper.rb"]
  s.test_files = ["test/authentication_request_test",
    'test/data_request_test',
    'test/garb_test',
    'test/operator_test',
    'test/profile_test',
    'test/report_parameter_test',
    'test/report_response_test',
    'test/report_test',
    'test/session_test',
    'test/symbol_test',
    'test/test_helper',
    'test/fixtures/profile_feed.xml',
    'test/fixtures/report_feed.xml']
  s.add_dependency("jnunemaker-happymapper", [">= 0.2.2"])
end