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
        assert_equal 'ga:1234', profile.table_id
      end
      
      should "build a defined report" do
        session = stub
        entry = stub do |s|
          s.stubs(:title).returns('entry')
        end
        
        Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')
        profile = Profile.new(entry, session)
        
        report = stub
                
        report_class = mock
        report_class.expects(:new).with(profile).returns(report)
        
        assert_equal report, profile.build(report_class)
      end
    end
  end
end