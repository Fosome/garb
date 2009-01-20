require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class AccountTest < Test::Unit::TestCase
    context "An instance of an Account" do
      setup do
        session = stub do |s|
          s.stubs(:email).returns('ga@example.com')
        end
        
        @account = Account.new(session)
      end

      should "create a request to be used from the URL and session email" do
        request_stub = stub(:session=)
        Request.stubs(:new).with(Account::URL+'ga@example.com').returns(request_stub)
        assert_equal request_stub, @account.request
      end

      should "get a list of all profiles for an account" do
        feed_stub = stub do |s|
          s.stubs(:each_entry).yields('entry')
        end

        Profile.stubs(:new).with('entry').returns('profile')
        @account.stubs(:request).returns(stub(:get => feed_stub))

        assert_equal ['profile'], @account.all
      end

      should "store an array of profiles for an account" do
        assert_equal [], @account.profiles
      end
    end
  end
end