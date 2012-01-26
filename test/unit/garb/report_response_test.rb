require 'test_helper'

module Garb
  SpecialKlass = Class.new(OpenStruct)

  class ReportResponseTest < MiniTest::Unit::TestCase
    context "A ReportResponse" do
      context "with a report feed" do
        setup do
          @xml = File.read(File.join(File.dirname(__FILE__), '..', '..', "/fixtures/report_feed.xml"))
        end

        should "parse results from atom xml" do
          response = ReportResponse.new(@xml)
          assert_equal ['33', '2', '1'], response.results.map(&:pageviews)
        end

        should "default to returning an array of OpenStruct objects" do
          response = ReportResponse.new(@xml)
          assert_equal [OpenStruct, OpenStruct, OpenStruct], response.results.map(&:class)
        end

        should "return an array of instances of a specified class" do
          response = ReportResponse.new(@xml, SpecialKlass)
          assert_equal [SpecialKlass, SpecialKlass, SpecialKlass], response.results.map(&:class)
        end

        should "know the total number of results" do
          response = ReportResponse.new(@xml)
          assert_equal 18, response.results.total_results
        end

        should "know if the data has been sampled" do
          response = ReportResponse.new(@xml)
          assert_equal true, response.results.sampled?
        end

        should "know the aggregate total number of visits" do
          response = ReportResponse.new(@xml)
          assert_equal 358524, response.results.aggregate_total_visits
        end

        should "return 0 if aggregate total visits isn't known" do
          xml = @xml.gsub(/name=\"ga:visits\"/, "name=\"ga:notvisits\"")

          response = ReportResponse.new(xml)
          assert_equal 0, response.results.aggregate_total_visits
        end
      end
    end
  end
end
