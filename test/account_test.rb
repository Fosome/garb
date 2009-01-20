require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class AccountTest < Test::Unit::TestCase
    context "An instance of an Account" do
      setup do
        # session = stub do |s|
        #   s.stubs(:email).returns('ga@example.com')
        # end
        @email = 'ga@example.com'
        @password = 'password'
        @account = Account.new(@email, @password)
      end

      should "create a session" do
        Session.expects(:new).with(@email, @password).returns('session')
        assert_equal 'session', @account.session
      end
      
      should "cache the session information" do
        Session.expects(:new).once.with(@email, @password).returns(stub())
        2.times { @account.session }
      end
      
      should "have a list of all profiles" do
        entry_stub   = stub
        profile_stub = stub
        feed_stub    = stub {|s| s.stubs(:each_entry).with().yields(entry_stub) }
        
        session = mock
        session.expects(:request).with(Garb::Account::URL + @email).returns(feed_stub)
        
        @account.stubs(:session).returns(session)
        
        Profile.expects(:new).with(entry_stub).returns(profile_stub)
        
        assert_equal [profile_stub], @account.profiles
      end
      
      # should "create a request to be used from the URL and session email" do
      #   request_stub = stub(:session=)
      #   Request.stubs(:new).with(Account::URL+'ga@example.com').returns(request_stub)
      #   assert_equal request_stub, @account.request
      # end
      # 
      # should "get a list of all profiles for an account" do
      #   feed_stub = stub do |s|
      #     s.stubs(:each_entry).yields('entry')
      #   end
      # 
      #   Profile.stubs(:new).with('entry').returns('profile')
      #   @account.stubs(:request).returns(stub(:get => feed_stub))
      # 
      #   assert_equal ['profile'], @account.all
      # end
      # 
      # should "store an array of profiles for an account" do
      #   assert_equal [], @account.profiles
      # end
    end
  end
end