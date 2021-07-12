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

          assert_equal ["alt=json", "ids=12345", "metrics=country"], query_string.split('&').sort
        end

        should "only contain JSON response option if parameters are empty" do
          data_request = Request::Data.new(@session, "")
          assert_equal "?alt=json", data_request.query_string
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

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          data_request.stubs(:single_user_request).returns(response)
          data_request.send_request

          assert_received(data_request, :single_user_request)
        end

        should "be able to send a request for an oauth user (Net::HTTP)" do
          @session.stubs(:single_user?).returns(false)
          @session.stubs(:oauth_user?).returns(true)
          response = mock('Net::HTTPOK') do |m|
            m.expects(:kind_of?).with(Net::HTTPSuccess).returns(true)
          end

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          data_request.stubs(:oauth_user_request).returns(response)
          data_request.send_request

          assert_received(data_request, :oauth_user_request)
        end

        should "be able to send a request for an oauth user (OAuth2)" do
          @session.stubs(:single_user?).returns(false)
          @session.stubs(:oauth_user?).returns(true)
          response = mock('OAuth2::Response') do |m|
            m.expects(:status).returns(200)
          end

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          data_request.stubs(:oauth_user_request).returns(response)
          data_request.send_request

          assert_received(data_request, :oauth_user_request)
        end

        should "raise if the request is unauthorized (Net::HTTP)" do
          @session.stubs(:single_user?).returns(false)
          @session.stubs(:oauth_user?).returns(true)
          response = mock('Net::HTTPUnauthorized', :body => 'Error')

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          data_request.stubs(:oauth_user_request).returns(response)

          assert_raises(Garb::Request::Data::ClientError) do
            data_request.send_request
          end
        end

        should "raise if the request is unauthorized (OAuth2)" do
          @session.stubs(:single_user?).returns(false)
          @session.stubs(:oauth_user?).returns(true)
          response = mock('OAuth2::Response') do |m|
            m.expects(:status).returns(401)
            m.expects(:body).returns('Error')
          end

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          data_request.stubs(:oauth_user_request).returns(response)

          assert_raises(Garb::Request::Data::ClientError) do
            data_request.send_request
          end
        end

        should "be able to request via the ouath access token" do
          access_token = stub(:get => "responseobject")
          @session.stubs(:access_token).returns(access_token)

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          assert_equal 'responseobject', data_request.oauth_user_request

          assert_received(@session, :access_token)
          assert_received(access_token, :get) {|e| e.with('https://example.com/data?key=value&alt=json', {'GData-Version' => '2'})}
        end

        should "be able to request via http with an auth token" do
          @session.expects(:auth_token).with().returns('toke')
          response = mock

          http = mock do |m|
            m.expects(:use_ssl=).with(true)
            m.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
            m.expects(:get).with('/data?key=value&alt=json', {
              'Authorization' => 'GoogleLogin auth=toke',
              'GData-Version' => '2'
            }).returns(response)
          end

          Garb.proxy_address = "127.0.0.1"
          Garb.proxy_port = "1234"
          Net::HTTP.expects(:new).with('example.com', 443, "127.0.0.1", "1234").returns(http)

          data_request = Request::Data.new(@session, 'https://example.com/data', 'key' => 'value')
          assert_equal response, data_request.single_user_request
        end
      end

    end
  end
end
