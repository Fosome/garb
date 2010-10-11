# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garb}
  s.version = "0.8.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tony Pitale"]
  s.date = %q{2010-10-11}
  s.email = %q{tony.pitale@viget.com}
  s.files = ["README.md", "Rakefile", "lib/garb", "lib/garb/account.rb", "lib/garb/account_feed_request.rb", "lib/garb/authentication_request.rb", "lib/garb/data_request.rb", "lib/garb/destination.rb", "lib/garb/filter_parameters.rb", "lib/garb/goal.rb", "lib/garb/management", "lib/garb/management/account.rb", "lib/garb/management/feed.rb", "lib/garb/management/goal.rb", "lib/garb/management/profile.rb", "lib/garb/management/web_property.rb", "lib/garb/model.rb", "lib/garb/profile.rb", "lib/garb/profile_reports.rb", "lib/garb/report.rb", "lib/garb/report_parameter.rb", "lib/garb/report_response.rb", "lib/garb/reports", "lib/garb/reports/bounces.rb", "lib/garb/reports/exits.rb", "lib/garb/reports/pageviews.rb", "lib/garb/reports/unique_pageviews.rb", "lib/garb/reports/visits.rb", "lib/garb/reports.rb", "lib/garb/resource.rb", "lib/garb/session.rb", "lib/garb/step.rb", "lib/garb/version.rb", "lib/garb.rb", "lib/support.rb", "test/fixtures", "test/fixtures/cacert.pem", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/garb", "test/unit/garb/account_feed_request_test.rb", "test/unit/garb/account_test.rb", "test/unit/garb/authentication_request_test.rb", "test/unit/garb/data_request_test.rb", "test/unit/garb/destination_test.rb", "test/unit/garb/filter_parameters_test.rb", "test/unit/garb/goal_test.rb", "test/unit/garb/management", "test/unit/garb/management/account_test.rb", "test/unit/garb/management/profile_test.rb", "test/unit/garb/management/web_property_test.rb", "test/unit/garb/model_test.rb", "test/unit/garb/oauth_session_test.rb", "test/unit/garb/profile_reports_test.rb", "test/unit/garb/profile_test.rb", "test/unit/garb/report_parameter_test.rb", "test/unit/garb/report_response_test.rb", "test/unit/garb/report_test.rb", "test/unit/garb/resource_test.rb", "test/unit/garb/session_test.rb", "test/unit/garb/step_test.rb", "test/unit/garb_test.rb", "test/unit/symbol_operator_test.rb"]
  s.homepage = %q{http://github.com/vigetlabs/garb}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Google Analytics API Ruby Wrapper}
  s.test_files = ["test/fixtures", "test/fixtures/cacert.pem", "test/fixtures/profile_feed.xml", "test/fixtures/report_feed.xml", "test/test_helper.rb", "test/unit", "test/unit/garb", "test/unit/garb/account_feed_request_test.rb", "test/unit/garb/account_test.rb", "test/unit/garb/authentication_request_test.rb", "test/unit/garb/data_request_test.rb", "test/unit/garb/destination_test.rb", "test/unit/garb/filter_parameters_test.rb", "test/unit/garb/goal_test.rb", "test/unit/garb/management", "test/unit/garb/management/account_test.rb", "test/unit/garb/management/profile_test.rb", "test/unit/garb/management/web_property_test.rb", "test/unit/garb/model_test.rb", "test/unit/garb/oauth_session_test.rb", "test/unit/garb/profile_reports_test.rb", "test/unit/garb/profile_test.rb", "test/unit/garb/report_parameter_test.rb", "test/unit/garb/report_response_test.rb", "test/unit/garb/report_test.rb", "test/unit/garb/resource_test.rb", "test/unit/garb/session_test.rb", "test/unit/garb/step_test.rb", "test/unit/garb_test.rb", "test/unit/symbol_operator_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, [">= 0.1.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2.0"])
    else
      s.add_dependency(%q<crack>, [">= 0.1.6"])
      s.add_dependency(%q<activesupport>, [">= 2.2.0"])
    end
  else
    s.add_dependency(%q<crack>, [">= 0.1.6"])
    s.add_dependency(%q<activesupport>, [">= 2.2.0"])
  end
end
