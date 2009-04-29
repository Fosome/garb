require File.join(File.dirname(__FILE__), '..', '/test_helper')

module Garb
  class ReportResponseTest < Test::Unit::TestCase
    context "An instance of the ReportResponse class" do
      setup do
        @xml = File.read(File.join(File.dirname(__FILE__), '..', "/fixtures/report_feed.xml"))
        @response = ReportResponse.new(@xml)
      end
      
      should "parse xml response with happymapper" do
        h1 = {"city"=>"(not set)", "pageviews"=>"33", "country"=>"(not set)"}
        h2 = {"city"=>"Kabul", "pageviews"=>"2", "country"=>"Afghanistan"}
        h3 = {"city"=>"Tirana", "pageviews"=>"1", "country"=>"Albania"}
        
        OpenStruct.expects(:new).with(h1).returns('entry1')
        OpenStruct.expects(:new).with(h2).returns('entry2')
        OpenStruct.expects(:new).with(h3).returns('entry3')
        
        assert_equal(['entry1', 'entry2', 'entry3'], @response.parse)
      end

      should "have results or parse them" do
        @response.expects(:parse)
        @response.results
      end
    end
  end
end
