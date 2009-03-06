require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class SessionTest < Test::Unit::TestCase
    
    context "The Session class" do
      
      should "be able retrieve an auth_token for a user" do
        auth_request = mock {|m| m.expects(:auth_token).with().returns('toke') }
        AuthenticationRequest.expects(:new).with('email', 'password').returns(auth_request)
        
        Session.login('email', 'password')
        assert_equal 'toke', Session.auth_token
      end
      
    end

  end
end
