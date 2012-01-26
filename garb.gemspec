# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{garb}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Tony Pitale}]
  s.date = %q{2012-01-26}
  s.email = %q{tony.pitale@viget.com}
  s.files = [%q{README.md}, %q{CHANGELOG.md}, %q{Rakefile}, %q{lib/garb}, %q{lib/garb/core_ext}, %q{lib/garb/core_ext/array.rb}, %q{lib/garb/core_ext/string.rb}, %q{lib/garb/core_ext/symbol.rb}, %q{lib/garb/destination.rb}, %q{lib/garb/filter_parameters.rb}, %q{lib/garb/management}, %q{lib/garb/management/account.rb}, %q{lib/garb/management/feed.rb}, %q{lib/garb/management/goal.rb}, %q{lib/garb/management/profile.rb}, %q{lib/garb/management/segment.rb}, %q{lib/garb/management/web_property.rb}, %q{lib/garb/model.rb}, %q{lib/garb/profile_reports.rb}, %q{lib/garb/report_parameter.rb}, %q{lib/garb/report_response.rb}, %q{lib/garb/reports}, %q{lib/garb/reports/bounces.rb}, %q{lib/garb/reports/exits.rb}, %q{lib/garb/reports/pageviews.rb}, %q{lib/garb/reports/unique_pageviews.rb}, %q{lib/garb/reports/visits.rb}, %q{lib/garb/reports.rb}, %q{lib/garb/request}, %q{lib/garb/request/authentication.rb}, %q{lib/garb/request/data.rb}, %q{lib/garb/result_set.rb}, %q{lib/garb/session.rb}, %q{lib/garb/step.rb}, %q{lib/garb/support.rb}, %q{lib/garb/version.rb}, %q{lib/garb.rb}, %q{test/fixtures}, %q{test/fixtures/cacert.pem}, %q{test/fixtures/profile_feed.xml}, %q{test/fixtures/report_feed.xml}, %q{test/test_helper.rb}, %q{test/unit}, %q{test/unit/garb}, %q{test/unit/garb/filter_parameters_test.rb}, %q{test/unit/garb/management}, %q{test/unit/garb/management/account_test.rb}, %q{test/unit/garb/management/feed_test.rb}, %q{test/unit/garb/management/goal_test.rb}, %q{test/unit/garb/management/profile_test.rb}, %q{test/unit/garb/management/segment_test.rb}, %q{test/unit/garb/management/web_property_test.rb}, %q{test/unit/garb/model_test.rb}, %q{test/unit/garb/oauth_session_test.rb}, %q{test/unit/garb/profile_reports_test.rb}, %q{test/unit/garb/report_parameter_test.rb}, %q{test/unit/garb/report_response_test.rb}, %q{test/unit/garb/request}, %q{test/unit/garb/request/authentication_test.rb}, %q{test/unit/garb/request/data_test.rb}, %q{test/unit/garb/session_test.rb}, %q{test/unit/garb_test.rb}, %q{test/unit/symbol_operator_test.rb}]
  s.homepage = %q{http://github.com/vigetlabs/garb}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Google Analytics API Ruby Wrapper}
  s.test_files = [%q{test/fixtures}, %q{test/fixtures/cacert.pem}, %q{test/fixtures/profile_feed.xml}, %q{test/fixtures/report_feed.xml}, %q{test/test_helper.rb}, %q{test/unit}, %q{test/unit/garb}, %q{test/unit/garb/filter_parameters_test.rb}, %q{test/unit/garb/management}, %q{test/unit/garb/management/account_test.rb}, %q{test/unit/garb/management/feed_test.rb}, %q{test/unit/garb/management/goal_test.rb}, %q{test/unit/garb/management/profile_test.rb}, %q{test/unit/garb/management/segment_test.rb}, %q{test/unit/garb/management/web_property_test.rb}, %q{test/unit/garb/model_test.rb}, %q{test/unit/garb/oauth_session_test.rb}, %q{test/unit/garb/profile_reports_test.rb}, %q{test/unit/garb/report_parameter_test.rb}, %q{test/unit/garb/report_response_test.rb}, %q{test/unit/garb/request}, %q{test/unit/garb/request/authentication_test.rb}, %q{test/unit/garb/request/data_test.rb}, %q{test/unit/garb/session_test.rb}, %q{test/unit/garb_test.rb}, %q{test/unit/symbol_operator_test.rb}]

  if s.respond_to? :specification_version then
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
