require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class SessionTest < Test::Unit::TestCase
    
    context "The Session class" do
      # setup do
      #   Session.instance_variable_set(:@auth_token, nil)
      # end


      should "be able to login with email and password" do
        response = mock do |m|
          m.expects(:code).with().returns('200')
          m.expects(:body).with().returns("Auth=abcdef")
        end
        AuthenticationRequest.expects(:new).with('user@example.com', 'password').returns(mock(:send_request => response))
        
        assert_equal 'abcdef', Session.login('user@example.com', 'password')
      end
      
      should "raise an exception if the authentication response is not 200" do
        response = mock do |m|
          m.expects(:code).with().returns('200')
        end
        AuthenticationRequest.expects(:new).with('user@example.com', 'password').returns(mock(:send_request => response))
      end
      
      # should "be able to retrieve an auth_token" do
      #   AuthenticationRequest.expects(:auth_token).with().returns('toke')
      #   assert_equal 'toke', Session.auth_token
      # end
      
      # should "memoize the auth_token value" do
      #   AuthenticationRequest.expects(:auth_token).with().once.returns('toke')
      #   2.times { Session.auth_token }
      # end
      
    end
    
    context "An instance of Session" do

      # setup do
      #   @session = Session.new('ga@example.com', 'password')
      # end

      # should "have an accessor for the auth_token" do
      #   Request.auth_token = 'froot'
      #   assert_equal 'froot', Request.auth_token
      # end

      # should "know that we are logged in when the auth_token is present" do
      #   @session.auth_token = 'fruity'
      #   assert_equal true, @session.logged_in?
      # end
      # 
      # should "know that we are not logged in when the auth_token is missing" do
      #   @session.auth_token = nil
      #   assert_equal false, @session.logged_in?
      # end
      # 
      # should "not be logged in if auth_token is an empty string" do
      #   @session.auth_token = ''
      #   assert_equal false, @session.logged_in?
      # end
      # 
      # should "have default parameters" do
      #   params = {
      #     'Email' => '',
      #     'Passwd' => '',
      #     'accountType' => 'HOSTED_OR_GOOGLE',
      #     'service' => 'analytics',
      #     'source' => 'vigetLabs-garb-001'
      #   }
      #   
      #   assert_equal params, Session.default_params
      # end
      # 
      # should "get an auth token with email and password" do
      #   params = Session.default_params.merge({'Email' => 'ga@example.com', 'Passwd' => 'password'})
      #   
      #   response_stub = stub do |s|
      #     s.stubs(:is_a?).with(Net::HTTPSuccess).returns(true)
      #     s.stubs(:body).with().returns('Auth=blah')
      #   end
      #   request_stub  = stub {|s| s.stubs(:post).with().returns(response_stub) }
      #   
      #   Request.expects(:new).with(Session::URL, params).returns(request_stub)
      #   
      #   @session.get_auth_token
      #   assert_equal 'blah', @session.auth_token
      # end
      # 
      # should "not set the auth token if the request is unsucessful" do
      #   response_stub = stub {|s| s.stubs(:is_a?).with(Net::HTTPSuccess).returns(false) }
      #   request_stub  = stub {|s| s.stubs(:post).with().returns(response_stub) }
      #     
      #   Request.expects(:new).with(Session::URL, kind_of(Hash)).returns(request_stub)
      #   
      #   @session.get_auth_token
      #   assert_nil @session.auth_token
      # end
      # 
      # should "be able to make a request to a url" do
      #   url  = "http://google.com"
      #   feed = stub()
      #   
      #   request = mock()
      #   request.expects(:session=).with(@session)
      #   request.expects(:get).with().returns(feed)
      #   
      #   Request.expects(:new).with(url).returns(request)
      #   
      #   assert_equal feed, @session.request(url)
      # end
    end
  end
end