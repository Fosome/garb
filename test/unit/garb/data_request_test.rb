require File.join(File.dirname(__FILE__), '..', '..', '/test_helper')

module Garb
  class DataRequestTest < MiniTest::Unit::TestCase
    
    context "An instance of the DataRequest class" do

      should "be able to build the query string from parameters" do
        parameters = {'ids' => '12345', 'metrics' => 'country'}
        data_request = DataRequest.new("", parameters)
        
        query_string = data_request.query_string
        
        assert_match(/^\?/, query_string)
        
        query_string.sub!(/^\?/, '')
        
        assert_equal ["ids=12345", "metrics=country"], query_string.split('&').sort
      end
      
      should "return an empty query string if parameters are empty" do
        data_request = DataRequest.new("")
        assert_equal "", data_request.query_string
      end
      
      should "be able to build a uri" do
        url        = 'http://example.com'
        expected = URI.parse('http://example.com')
        
        assert_equal expected, DataRequest.new(url).uri
      end
      
      should "be able to send a request for a single user" do
        Session.stubs(:single_user?).returns(true)
        response = mock('Net::HTTPOK') do |m|
          m.expects(:kind_of?).with(Net::HTTPSuccess).returns(true)
        end

        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        data_request.stubs(:single_user_request).returns(response)
        data_request.send_request

        assert_received(data_request, :single_user_request)
      end

      should "be able to send a request for an oauth user" do
        Session.stubs(:single_user?).returns(false)
        Session.stubs(:oauth_user?).returns(true)
        response = mock('Net::HTTPOK') do |m|
          m.expects(:kind_of?).with(Net::HTTPSuccess).returns(true)
        end

        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        data_request.stubs(:oauth_user_request).returns(response)
        data_request.send_request

        assert_received(data_request, :oauth_user_request)
      end

      should "raise if the request is unauthorized" do
        Session.stubs(:single_user?).returns(false)
        Session.stubs(:oauth_user?).returns(true)
        response = mock('Net::HTTPUnauthorized', :body => 'Error')

        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        data_request.stubs(:oauth_user_request).returns(response)

        assert_raises(Garb::DataRequest::ClientError) do
          data_request.send_request
        end
      end

      should "be able to request via the ouath access token" do
        access_token = stub(:get => "responseobject")
        Session.stubs(:access_token).returns(access_token)

        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        assert_equal 'responseobject', data_request.oauth_user_request

        assert_received(Session, :access_token)
        assert_received(access_token, :get) {|e| e.with('https://example.com/data?key=value')}
      end

      should "be able to request via http with an auth token" do
        Session.expects(:auth_token).with().returns('toke')
        response = mock

        http = mock do |m|
          m.expects(:use_ssl=).with(true)
          m.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
          m.expects(:get).with('/data?key=value', 'Authorization' => 'GoogleLogin auth=toke').returns(response)
        end

        Net::HTTP.expects(:new).with('example.com', 443).returns(http)

        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        assert_equal response, data_request.single_user_request
      end
    end

  end
end
