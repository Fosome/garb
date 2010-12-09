require 'test_helper'

module Garb
  class AccountFeedRequestTest < MiniTest::Unit::TestCase
    context "An AccountFeedRequest" do
      setup do
        @request = stub
        DataRequest.stubs(:new).returns(@request)
        @feed = AccountFeedRequest.new
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

      should "have segements from the parsed response" do
        @feed.stubs(:parsed_response).returns({'feed' => {'dxp:segment' => ['segment1', 'segment2']}})
        assert_equal ['segment1', 'segment2'], @feed.segments
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