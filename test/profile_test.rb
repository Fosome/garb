require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class ProfileTest < Test::Unit::TestCase
    context "An instance of a Profile" do
      should "retain the tableId and title from an entry" do
        entry = stub do |s|
          s.stubs(:title).returns('entry')
        end
        
        Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')
        
        profile = Profile.new(entry)
        assert_equal 'entry', profile.title
        assert_equal 'ga:1234', profile.tableId
      end
    end
  end
end