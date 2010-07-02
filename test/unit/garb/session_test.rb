require 'test_helper'

module Garb
  class SessionTest < MiniTest::Unit::TestCase
    
    context "The Session class" do
      
      should "be able retrieve an auth_token for a user" do
        auth_request = mock {|m| m.expects(:auth_token).with({}).returns('toke') }
        AuthenticationRequest.expects(:new).with('email', 'password', {}).returns(auth_request)

        Session.login('email', 'password')
        assert_equal 'toke', Session.auth_token
      end

      should "be able retrieve an auth_token for a user with secure ssl" do
        opts = {:secure => true, :account_type => 'GOOGLE'}
        auth_request = mock {|m| m.expects(:auth_token).with(opts).returns('toke') }
        AuthenticationRequest.expects(:new).with('email', 'password', opts).returns(auth_request)

        Session.login('email', 'password', opts)
        assert_equal 'toke', Session.auth_token
      end
      
      should "retain the email address for this session" do
        AuthenticationRequest.stubs(:new).returns(stub(:auth_token => 'toke'))
        
        Session.login('email', 'password')
        assert_equal 'email', Session.email
      end

      should "know if the Session is for a single user" do
        Session.auth_token = "abcdefg1234567"
        assert_equal true, Session.single_user?
      end

      should "know if the Session is for oauth" do
        Session.access_token = 'some_oauth_access_token'
        assert_equal true, Session.oauth_user?
      end
    end

    context "A Session" do
      setup do
        @session = Session.new
      end
      
      should "be able retrieve an auth_token for a user" do
        auth_request = mock {|m| m.expects(:auth_token).with({}).returns('toke') }
        AuthenticationRequest.expects(:new).with('email', 'password', {}).returns(auth_request)

        @session.login('email', 'password')
        assert_equal 'toke', @session.auth_token
      end

      should "be able retrieve an auth_token for a user with secure ssl" do
        opts = {:secure => true, :account_type => 'GOOGLE'}
        auth_request = mock {|m| m.expects(:auth_token).with(opts).returns('toke') }
        AuthenticationRequest.expects(:new).with('email', 'password', opts).returns(auth_request)

        @session.login('email', 'password', opts)
        assert_equal 'toke', @session.auth_token
      end
      
      should "retain the email address for this session" do
        AuthenticationRequest.stubs(:new).returns(stub(:auth_token => 'toke'))
        
        @session.login('email', 'password')
        assert_equal 'email', @session.email
      end

      should "know if the Session is for a single user" do
        @session.auth_token = "abcdefg1234567"
        assert_equal true, @session.single_user?
      end

      should "know if the Session is for oauth" do
        @session.access_token = 'some_oauth_access_token'
        assert_equal true, @session.oauth_user?
      end
    end

  end
end
