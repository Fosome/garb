Gem::Specification.new do |s|
  s.name     = "garb"
  s.version  = "0.1.2"
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
		"lib/extensions/symbol.rb",
		"lib/extensions/string.rb",
		"lib/extensions/operator.rb",
		"lib/extensions/happymapper.rb"]
  s.test_files = ['test/authentication_request_test.rb',
    'test/data_request_test.rb',
    'test/garb_test.rb',
    'test/operator_test.rb',
    'test/profile_test.rb',
    'test/report_parameter_test.rb',
    'test/report_response_test.rb',
    'test/report_test.rb',
    'test/session_test.rb',
    'test/symbol_test.rb',
    'test/test_helper.rb',
    'test/fixtures/profile_feed.xml',
    'test/fixtures/report_feed.xml']
  s.add_dependency("jnunemaker-happymapper", [">= 0.2.2"])
  s.add_dependency("libxml-ruby", [">= 0.9.8"])
end