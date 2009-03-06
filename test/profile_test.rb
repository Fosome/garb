require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class ProfileTest < Test::Unit::TestCase
    
    context "The Profile class" do
      
      # should "be able to return a list of all profiles" do
      #   Session.stubs(:email).with().returns('user@host.com')
      #   
      #   url = 'https://www.google.com/analytics/feeds/accounts/user@host.com'
      #   
      #   xml = read_fixture('feed.xml')
      #   
      #   data_request = mock
      #   data_request.expects(:send_request).with().returns(stub(:body => xml))
      #   
      #   DataRequest.expects(:new).with(url).returns(data_request)
      #   
      #   entries = Hpricot.XML(xml)/'entry'
      #   
      #   stubs = []
      #   entries.each do |entry|
      #     stub = stub()
      #     stubs << stub
      #     puts "in test: #{entry.class}"
      #     Garb::Profile.expects(:new).with(entry).returns(stub)
      #   end
      #   
      #   assert_equal stubs, Profile.all
      # end
      
    end
    
    context "An instance of the Profile class" do
      
      setup do
        @entry = (Hpricot.XML(read_fixture('feed.xml'))/:entry).first
        @profile = Profile.new(@entry)
      end
      
      should "have a value for :title" do
        assert_equal "Darcy's Blog", @profile.title
      end
      
      should "have a value for :table_id" do
        assert_equal 'ga:4321', @profile.table_id
      end
      
      should "have a value for :id" do
        assert_equal '4321', @profile.id
      end
      
    end
    
    
    # context "An instance of a Profile" do
    #   should "retain the tableId and title from an entry" do
    #     entry = stub do |s|
    #       s.stubs(:title).returns('entry')
    #     end
    #     session = stub
    #     
    #     Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')
    #     
    #     profile = Profile.new(entry, session)
    #     assert_equal 'entry', profile.title
    #     assert_equal 'ga:1234', profile.table_id
    #   end
    #   
    #   should "build a defined report" do
    #     session = stub
    #     entry = stub do |s|
    #       s.stubs(:title).returns('entry')
    #     end
    #     
    #     Report.stubs(:property_value).with(entry, :tableId).returns('ga:1234')
    #     profile = Profile.new(entry, session)
    #     
    #     report = stub
    #             
    #     report_class = mock
    #     report_class.expects(:new).with(profile).returns(report)
    #     
    #     assert_equal report, profile.build(report_class)
    #   end
    # end
  end
end