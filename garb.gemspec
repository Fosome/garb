# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garb}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tony Pitale", "Justin Marney", "Patrick Reagan"]
  s.date = %q{2009-05-11}
  s.email = %q{tony.pitale@viget.com}
  s.files = ["README.md", "Rakefile", "lib/extensions", "lib/extensions/happymapper.rb", "lib/extensions/operator.rb", "lib/extensions/string.rb", "lib/extensions/symbol.rb", "lib/garb", "lib/garb/authentication_request.rb", "lib/garb/data_request.rb", "lib/garb/oauth_session.rb", "lib/garb/profile.rb", "lib/garb/report.rb", "lib/garb/report_parameter.rb", "lib/garb/report_response.rb", "lib/garb/resource.rb", "lib/garb/session.rb", "lib/garb/version.rb", "lib/garb.rb", "test/fixtures", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/authentication_request_test.rb", "test/unit/data_request_test.rb", "test/unit/garb_test.rb", "test/unit/oauth_session_test.rb", "test/unit/operator_test.rb", "test/unit/profile_test.rb", "test/unit/report_parameter_test.rb", "test/unit/report_response_test.rb", "test/unit/report_test.rb", "test/unit/resource_test.rb", "test/unit/session_test.rb", "test/unit/string_test.rb", "test/unit/symbol_test.rb"]
  s.homepage = %q{http://github.com/vigetlabs/garb}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Google Analytics API Ruby Wrapper}
  s.test_files = ["test/fixtures", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/authentication_request_test.rb", "test/unit/data_request_test.rb", "test/unit/garb_test.rb", "test/unit/oauth_session_test.rb", "test/unit/operator_test.rb", "test/unit/profile_test.rb", "test/unit/report_parameter_test.rb", "test/unit/report_response_test.rb", "test/unit/report_test.rb", "test/unit/resource_test.rb", "test/unit/session_test.rb", "test/unit/string_test.rb", "test/unit/symbol_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jnunemaker-happymapper>, [">= 0.2.2"])
    else
      s.add_dependency(%q<jnunemaker-happymapper>, [">= 0.2.2"])
    end
  else
    s.add_dependency(%q<jnunemaker-happymapper>, [">= 0.2.2"])
  end
end
