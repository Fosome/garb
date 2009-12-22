require File.join(File.dirname(__FILE__), '..', '..', '/test_helper')

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
      
    end

  end
end
