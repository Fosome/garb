require 'test_helper'

module Garb
  class ReportParameterTest < MiniTest::Unit::TestCase
    
    context "An instance of the ReportParameter class" do
      setup do
        @metrics = ReportParameter.new(:metrics)
      end
      
      should "have a name" do
        assert_equal "metrics", @metrics.name
      end
      
      should "have a list of elements" do
        assert_equal [], @metrics.elements
      end
      
      should "be able to add new elements" do
        assert_equal(@metrics, @metrics << :page_path)
        assert_equal [:page_path], @metrics.elements
      end
      
      should "merge an array of elements" do
        assert_equal(@metrics, @metrics << [:page_path])
        assert_equal [:page_path], @metrics.elements
      end

      context "converting to params" do
        should "be able to format the parameters into strings" do
          @metrics << :page_path
          assert_equal({'metrics' => 'ga:pagePath'}, @metrics.to_params)
        end

        should "join multiple symbol elements" do
          @metrics << :page_path << :city
          assert_equal({'metrics' => 'ga:pagePath,ga:city'}, @metrics.to_params)
        end
      end
    end
    
  end
end