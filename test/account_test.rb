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
        profile_stub = stub(:table_id => '1')
        feed_stub    = stub {|s| s.stubs(:each_entry).with().yields(entry_stub) }
        
        session = mock
        session.expects(:logged_in?).with().returns(true)
        session.expects(:request).with(Garb::Account::URL + @email).returns(feed_stub)
        
        @account.stubs(:session).returns(session)
        
        Profile.expects(:new).with(entry_stub, session).returns(profile_stub)
        
        assert_equal({'1' => profile_stub}, @account.profiles)
      end
    end
  end
end