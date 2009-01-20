require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class SessionTest < Test::Unit::TestCase
    context "An instance of Session" do

      setup do
        @session = Session.new('ga@example.com', 'password')
      end

      # should "have an accessor for the auth_token" do
      #   Request.auth_token = 'froot'
      #   assert_equal 'froot', Request.auth_token
      # end

      should "know that we are logged in when the auth_token is present" do
        @session.auth_token = 'fruity'
        assert_equal true, @session.logged_in?
      end

      should "know that we are not logged in when the auth_token is missing" do
        @session.auth_token = nil
        assert_equal false, @session.logged_in?
      end

      should "not be logged in if auth_token is an empty string" do
        @session.auth_token = ''
        assert_equal false, @session.logged_in?
      end

      should "have default parameters" do
        params = {
          'Email' => '',
          'Passwd' => '',
          'accountType' => 'HOSTED_OR_GOOGLE',
          'service' => 'analytics',
          'source' => 'vigetLabs-garb-001'
        }
        
        assert_equal params, Session.default_params
      end
      
      should "get an auth token with email and password" do
        params = Session.default_params.merge({'Email' => 'ga@example.com', 'Passwd' => 'password'})
        login_stub = stub(:post => stub(:body => 'Auth=blah'))

        Request.expects(:new).with(Session::URL, params).returns(login_stub)
        @session.get_auth_token
        assert_equal 'blah', @session.auth_token
      end
    end
  end
end