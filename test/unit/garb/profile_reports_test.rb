require 'test_helper'

module Garb

  Exits = Class.new

  class FakeProfile
    include ProfileReports
  end

  class ProfileReportsTest < MiniTest::Unit::TestCase
    context "The ProfileReports module" do
      should "define a new method when given a class" do
        ProfileReports.add_report_method(Exits)
        assert_equal true, FakeProfile.new.respond_to?(:exits)
      end

      should "return results from the given class with options" do
        results = [1,2,3]
        Exits.stubs(:results).returns(results)
        ProfileReports.add_report_method(Exits)

        profile = FakeProfile.new
        assert_equal results, profile.exits(:start => "now")
        assert_received(Exits, :results) {|e| e.with(profile, :start => "now")}
      end
    end
  end
end
