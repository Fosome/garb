require 'test_helper'

module Garb
  SpecialKlass = Class.new(OpenStruct)

  class ReportResponseTest < MiniTest::Unit::TestCase
    context "A ReportResponse" do
      context "with a report feed" do
        setup do
          @file = File.read(File.join(File.dirname(__FILE__), '..', '..', "/fixtures/report_feed.xml"))
        end

        should "parse results from atom xml" do
          response = ReportResponse.new(@file)
          assert_equal ['33', '2', '1'], response.results.map(&:pageviews)
        end

        should "default to returning an array of OpenStruct objects" do
          response = ReportResponse.new(@file)
          assert_equal [OpenStruct, OpenStruct, OpenStruct], response.results.map(&:class)
        end

        should "return an array of instances of a specified class" do
          response = ReportResponse.new(@file, SpecialKlass)
          assert_equal [SpecialKlass, SpecialKlass, SpecialKlass], response.results.map(&:class)
        end

	should "return the total number of results" do
          response = ReportResponse.new(@file)
          assert_equal 6, response.total_results
        end
      end

      should "return an empty array if there are no results" do
        response = ReportResponse.new("result xml")
        Crack::XML.stubs(:parse).with("result xml").returns({'feed' => {'entry' => nil}})

        assert_equal [], response.results
      end
    end
  end
end
