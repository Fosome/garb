require File.join(File.dirname(__FILE__), '..', '..', '/test_helper')

module Garb
  class ReportResponseTest < MiniTest::Unit::TestCase
    context "A ReportResponse" do
      should "parse results from atom xml" do
        filename = File.join(File.dirname(__FILE__), '..', '..', "/fixtures/report_feed.xml")
        response = ReportResponse.new(File.read(filename))
        
        assert_equal ['33', '2', '1'], response.results.map(&:pageviews)
      end

      should "return an empty array if there are no results" do
        response = ReportResponse.new("result xml")
        Crack::XML.stubs(:parse).with("result xml").returns({'feed' => {'entry' => nil}})

        assert_equal [], response.results
      end
    end
  end
end
