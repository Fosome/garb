# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garb}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tony Pitale"]
  s.date = %q{2010-02-10}
  s.email = %q{tony.pitale@viget.com}
  s.files = ["README.md", "Rakefile", "lib/garb", "lib/garb/account.rb", "lib/garb/authentication_request.rb", "lib/garb/data_request.rb", "lib/garb/filter_parameters.rb", "lib/garb/profile.rb", "lib/garb/profile_reports.rb", "lib/garb/report.rb", "lib/garb/report_parameter.rb", "lib/garb/report_response.rb", "lib/garb/reports", "lib/garb/reports/bounces.rb", "lib/garb/reports/exits.rb", "lib/garb/reports/pageviews.rb", "lib/garb/reports/unique_pageviews.rb", "lib/garb/reports/visits.rb", "lib/garb/reports.rb", "lib/garb/resource.rb", "lib/garb/session.rb", "lib/garb/version.rb", "lib/garb.rb", "lib/support.rb", "test/fixtures", "test/fixtures/cacert.pem", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/garb", "test/unit/garb/account_test.rb", "test/unit/garb/authentication_request_test.rb", "test/unit/garb/data_request_test.rb", "test/unit/garb/filter_parameters_test.rb", "test/unit/garb/oauth_session_test.rb", "test/unit/garb/profile_reports_test.rb", "test/unit/garb/profile_test.rb", "test/unit/garb/report_parameter_test.rb", "test/unit/garb/report_response_test.rb", "test/unit/garb/report_test.rb", "test/unit/garb/resource_test.rb", "test/unit/garb/session_test.rb", "test/unit/garb_test.rb", "test/unit/symbol_operator_test.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/vigetlabs/garb}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Google Analytics API Ruby Wrapper}
  s.test_files = ["test/fixtures", "test/fixtures/cacert.pem", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/garb", "test/unit/garb/account_test.rb", "test/unit/garb/authentication_request_test.rb", "test/unit/garb/data_request_test.rb", "test/unit/garb/filter_parameters_test.rb", "test/unit/garb/oauth_session_test.rb", "test/unit/garb/profile_reports_test.rb", "test/unit/garb/profile_test.rb", "test/unit/garb/report_parameter_test.rb", "test/unit/garb/report_response_test.rb", "test/unit/garb/report_test.rb", "test/unit/garb/resource_test.rb", "test/unit/garb/session_test.rb", "test/unit/garb_test.rb", "test/unit/symbol_operator_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<happymapper>, ["~> 0.3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.0"])
    else
      s.add_dependency(%q<happymapper>, ["~> 0.3.0"])
      s.add_dependency(%q<activesupport>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<happymapper>, ["~> 0.3.0"])
    s.add_dependency(%q<activesupport>, [">= 2.3.0"])
  end
end
