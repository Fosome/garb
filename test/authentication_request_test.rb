require File.dirname(__FILE__) + '/test_helper'

module Garb
  class AuthenticationRequestTest < Test::Unit::TestCase
    
    context "An instance of the AuthenticationRequest class" do
      
      setup { @request = AuthenticationRequest.new('email', 'password') }
      
      should "have a collection of parameters that include the email and password" do
        expected = 
          {
            'Email'       => 'user@example.com',
            'Passwd'      => 'fuzzybunnies',
            'accountType' => 'HOSTED_OR_GOOGLE',
            'service'     => 'analytics',
            'source'      => 'vigetLabs-garb-001'
          }
        
        request = AuthenticationRequest.new('user@example.com', 'fuzzybunnies')
        assert_equal expected, request.parameters
      end
      
      should "have a URI" do
        assert_equal URI.parse('https://www.google.com/accounts/ClientLogin'), @request.uri
      end
      
      
      should "be able to send a request to the GAAPI service" do        
        @request.expects(:build_request).returns('post')
        response = mock {|m| m.expects(:is_a?).with(Net::HTTPOK).returns(true) }
        
        http = mock do |m|
          m.expects(:use_ssl=).with(true)
          m.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
          m.expects(:request).with('post').yields(response)
        end
        
        Net::HTTP.expects(:new).with('www.google.com', 443).returns(http)
        
        @request.send_request
      end
      
      should "be able to build a request for the GAAPI service" do
        params = "param"
        @request.expects(:parameters).with().returns(params)
        
        post = mock
        post.expects(:set_form_data).with(params)
        
        Net::HTTP::Post.expects(:new).with('/accounts/ClientLogin').returns(post)
        
        @request.build_request
      end
      
      should "be able to retrieve an auth_token from the body" do
        response_data =
          "SID=mysid\n" +
          "LSID=mylsid\n" +
          "Auth=auth_token\n"
          
        @request.expects(:send_request).with().returns(stub(:body => response_data))
        
        assert_equal 'auth_token', @request.auth_token
      end
      
      should "raise an exception when requesting an auth_token when the authorization fails" do
        @request.stubs(:build_request)
        response = mock do |m|
          m.expects(:is_a?).with(Net::HTTPOK).returns(false)
        end
        
        http = stub do |s|
          s.stubs(:use_ssl=)
          s.stubs(:verify_mode=)
          s.stubs(:request).yields(response)
        end
        
        Net::HTTP.stubs(:new).with('www.google.com', 443).returns(http)
        
        assert_raise(Garb::AuthenticationRequest::AuthError) do
          @request.send_request
        end
      end
      
    end
    
    
    
  end
end