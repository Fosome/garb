require 'test_helper'

module Garb
  module Management
    class FeedTest < MiniTest::Unit::TestCase
      context "a Feed" do
        setup do
          @request = stub
          DataRequest.stubs(:new).returns(@request)
          @feed = Feed.new(Garb::Session.new, '/accounts')
        end

        should "have a parsed response" do
          Crack::XML.stubs(:parse)
          @feed.stubs(:response).returns(stub(:body => 'response body'))
          @feed.parsed_response

          assert_received(Crack::XML, :parse) {|e| e.with('response body')}
        end

        should "have entries from the parsed response" do
          @feed.stubs(:parsed_response).returns({'feed' => {'entry' => ['entry1', 'entry2']}})
          assert_equal ['entry1', 'entry2'], @feed.entries
        end

        should "handle case of a single entry" do
          @feed.stubs(:parsed_response).returns({'feed' => {'entry' => {'profile_id' => '12345'}}})
          assert_equal [{'profile_id' => '12345'}], @feed.entries
        end

        should "have an empty array for entries without a response" do
          @feed.stubs(:parsed_response).returns(nil)
          assert_equal [], @feed.entries
        end

        should "have a response from the request" do
          @request.stubs(:send_request)
          @feed.response
          assert_received(@request, :send_request)
        end
      end
    end
  end
end