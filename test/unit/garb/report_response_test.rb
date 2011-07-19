require 'test_helper'

module Garb
  SpecialKlass = Class.new(OpenStruct)

  class ReportResponseTest < MiniTest::Unit::TestCase
    context "A ReportResponse" do
      context "with a report feed" do
        setup do
          @json = File.read(File.join(File.dirname(__FILE__), '..', '..', "/fixtures/report_feed.json"))
        end

        should "parse results from atom xml" do
          response = ReportResponse.new(@json)
          assert_equal ['33', '2', '1'], response.results.map(&:pageviews)
        end

        should "default to returning an array of OpenStruct objects" do
          response = ReportResponse.new(@json)
          assert_equal [OpenStruct, OpenStruct, OpenStruct], response.results.map(&:class)
        end

        should "return an array of instances of a specified class" do
          response = ReportResponse.new(@json, SpecialKlass)
          assert_equal [SpecialKlass, SpecialKlass, SpecialKlass], response.results.map(&:class)
        end

        should "know the total number of results" do
          response = ReportResponse.new(@json)
          assert_equal 18, response.results.total_results
        end

        should "know if the data has been sampled" do
          response = ReportResponse.new(@json)
          assert_equal true, response.results.sampled?
        end
      end

      should "return an empty array if there are no results" do
        response = ReportResponse.new("result json")
        JSON.stubs(:parse).with("result json").returns({'feed' => {'entry' => nil}})

        assert_equal [], response.results.to_a
      end
    end
  end
end
