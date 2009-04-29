require File.join(File.dirname(__FILE__), '..', '/test_helper')

module Garb
  class ProfileTest < Test::Unit::TestCase
    
    context "The Profile class" do
      
      should "be able to return a list of all profiles" do
        Session.stubs(:email).with().returns('user@host.com')
        
        url = 'https://www.google.com/analytics/feeds/accounts/user@host.com'
        
        xml = read_fixture('profile_feed.xml')
        
        data_request = mock
        data_request.expects(:send_request).with().returns(stub(:body => xml))
        
        DataRequest.expects(:new).with(url).returns(data_request)
        
        entries = [stub]
        
        Profile::Entry.expects(:parse).with(xml).returns(entries)
                
        profiles = []
        entries.each do |entry|
          profile = stub
          profiles << profile
          Garb::Profile.expects(:new).with(entry).returns(profile)
        end
        
        assert_equal profiles, Profile.all
      end
      
    end
    
    context "An instance of the Profile class" do
      
      setup do
        @entry = (Profile::Entry.parse(read_fixture('profile_feed.xml'))).first
        @profile = Profile.new(@entry)
      end
      
      should "have a value for :title" do
        assert_equal "Historical", @profile.title
      end
      
      should "have a value for :table_id" do
        assert_equal 'ga:12345', @profile.table_id
      end
      
      should "have a value for :id" do
        assert_equal '12345', @profile.id
      end
      
    end

  end
end