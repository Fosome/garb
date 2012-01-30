require 'test_helper'

module Garb
  module Request
    class DataTest < MiniTest::Unit::TestCase
    
      context "An instance of the Request::Data class" do
        setup do
          @session = Session.new
          @session.auth_token = 'abcdefg123456'
        end

        teardown do
          Garb.proxy_address = nil
          Garb.proxy_port = nil
        end

        should "be able to build the query string from parameters" do
          parameters = {'ids' => '12345', 'metrics' => 'country'}
          data_request = Request::Data.new(@session, "", parameters)
        
          query_string = data_request.query_string
        
          assert_match(/^\?/, query_string)
        
          query_string.sub!(/^\?/, '')
        
          assert_equal ["ids=12345", "key=#{Garb::Request::Data::SERVER_APP_KEY}", "metrics=country"], query_string.split('&').sort
        end

        should "be able to build a uri" do
          url = 'http://example.com'
          assert_equal URI.parse(url), Request::Data.new(@session, url).uri
        end

        should "be able to send a request for a single user" do
          @session.stubs(:single_user?).returns(true)
          response = mock('Net::HTTPOK') do |m|
            m.expects(:kind_of?).with(Net::HTTPSuccess).returns(true)
          end

          data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
          data_request.stubs(:single_user_request).returns(response)
          data_request.send_request

          assert_received(data_request, :single_user_request)
        end

        should "be able to request via http with an auth token" do
          @session.expects(:auth_token).with().returns('toke')
          response = mock

          http = mock do |m|
            m.expects(:use_ssl=).with(true)
            m.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
            m.expects(:get).with('/data?akey=value&key=AIzaSyB5L3vCb60CGr1tAuzPB1sX_EcEJuAa5aE', {
              'Authorization' => 'GoogleLogin auth=toke',
              'GData-Version' => '2'
            }).returns(response)
          end

          Garb.proxy_address = "127.0.0.1"
          Garb.proxy_port = "1234"
          Net::HTTP.expects(:new).with('example.com', 443, "127.0.0.1", "1234").returns(http)

          data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
          assert_equal response, data_request.single_user_request
        end

        context 'for an oauth user' do
          should "be able to send a request" do
            @session.stubs(:single_user?).returns(false)
            @session.stubs(:oauth_user?).returns(true)
            response = mock('Net::HTTPOK') do |m|
              m.expects(:kind_of?).with(Net::HTTPSuccess).returns(true)
            end

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            data_request.stubs(:oauth_user_request).returns(response)
            data_request.send_request

            assert_received(data_request, :oauth_user_request)
          end

          should "raise if the request is unauthorized" do
            @session.stubs(:single_user?).returns(false)
            @session.stubs(:oauth_user?).returns(true)
            response = mock('Net::HTTPUnauthorized', :body => 'Error message', :code => '401')

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            data_request.stubs(:oauth_user_request).returns(response)

            exception = assert_raises(Garb::Request::Data::ClientError) do
              data_request.send_request
            end
            assert_equal 401, exception.response_code
            assert_equal 'Error message', exception.message
          end

          should "raise if the request is unauthorized and there is no status code" do
            @session.stubs(:single_user?).returns(false)
            @session.stubs(:oauth_user?).returns(true)
            response = mock('Net::HTTPUnauthorized', :body => '<foo>fake XML Error message without status code</foo>', :code => nil)

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            data_request.stubs(:oauth_user_request).returns(response)

            exception = assert_raises(Garb::Request::Data::ClientError) do
              data_request.send_request
            end
            assert_equal nil, exception.response_code
            assert_equal '<foo>fake XML Error message without status code</foo>', exception.message
          end

          should "be able to request via the access token" do
            access_token = stub(:get => "responseobject")
            @session.stubs(:access_token).returns(access_token)

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            assert_equal 'responseobject', data_request.oauth_user_request

            assert_received(@session, :access_token)
            assert_received(access_token, :get) do |e|
              e.with() do |URL, header_hash|
                assert_match /^https:\/\/example.com\/data\?/, URL
                assert_match /key=AIzaSyB5L3vCb60CGr1tAuzPB1sX_EcEJuAa5aE/, URL
                assert_match /akey=value/, URL
                expected_hash = {'GData-Version' => '2'}
                assert_equal expected_hash, header_hash
              end
            end
          end
        end
        
        context 'for an oauth2 user' do 
          should "be able to send a request for an oauth user" do
            @session.stubs(:oauth2_user?).returns(true)
            response = mock('OAuth2::Response', :status => 200)

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            data_request.stubs(:oauth2_user_request).returns(response)
            data_request.send_request

            assert_received(data_request, :oauth2_user_request)
          end

          should "raise if the request is unauthorized" do
            @session.stubs(:oauth2_user?).returns(true)
            response = mock('OAuth2::Response', :body => 'Error message', :status => 401) do |m|
              m.expects(:status).returns(401)
            end

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            data_request.stubs(:oauth2_user_request).returns(response)

            exception = assert_raises(Garb::Request::Data::ClientError) do
              data_request.send_request
            end
            assert_equal 401, exception.response_code
            assert_equal 'Error message', exception.message
          end

          should "be able to request via the token" do
            token = stub(:get => "responseobject")
            @session.stubs(:token).returns(token)

            data_request = Request::Data.new(@session, 'https://example.com/data', 'akey' => 'value')
            assert_equal 'responseobject', data_request.oauth2_user_request

            assert_received(@session, :token) {|expect| expect.twice }
            assert_received(token, :get) do |e|
              e.with() do |URL, header_hash|
                assert_match /^https:\/\/example.com\/data\?/, URL
                assert_match /akey=value/, URL
                expected_hash = {'GData-Version' => '2'}
                assert_equal expected_hash, header_hash
              end
            end
          end
        end
        
      end

    end
  end
end
