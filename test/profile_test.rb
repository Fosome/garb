require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class ProfileTest < Test::Unit::TestCase
    context "An instance of a Profile" do
      should "retain the tableId and title from an entry" do
        entry = stub do |s|
          s.stubs(:title).returns('entry')
        end
        session = stub
        
        Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')
        
        profile = Profile.new(entry, session)
        assert_equal 'entry', profile.title
        assert_equal 'ga:1234', profile.tableId
      end
      
      should "get a defined report" do
        session = stub
        entry = stub do |s|
          s.stubs(:title).returns('entry')
        end
        
        Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')        
        profile = Profile.new(entry, session)
        
        report_entry = stub
        
        report = mock
        report.expects(:all).with().returns([report_entry])
        
        report_class = mock
        report_class.expects(:new).with(profile, session).returns(report)
        
        assert_equal [report_entry], profile.get(report_class)
      end
    end
  end
end