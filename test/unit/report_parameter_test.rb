require File.join(File.dirname(__FILE__), '..', '/test_helper')

module Garb
  class ReportParameterTest < Test::Unit::TestCase
    
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
        assert_equal(@metrics, @metrics << :request_uri)
        assert_equal [:request_uri], @metrics.elements
      end
      
      should "merge an array of elements" do
        assert_equal(@metrics, @metrics << [:request_uri])
        assert_equal [:request_uri], @metrics.elements
      end

      context "converting to params" do
        should "be able to format the parameters into strings" do
          @metrics << :request_uri
          assert_equal({'metrics' => 'ga:requestUri'}, @metrics.to_params)
        end

        should "join multiple symbol elements" do
          @metrics << :request_uri << :city
          assert_equal({'metrics' => 'ga:requestUri,ga:city'}, @metrics.to_params)
        end
        
        should "join operator elements" do
          @metrics << :city.desc
          assert_equal({'metrics' => '-ga:city'}, @metrics.to_params)
        end
        
        should "parameterize hash operators and join elements" do
          @metrics << {:city.eql => 'New York'}
          params = {'metrics' => 'ga:city%3D%3DNew+York'}

          assert_equal params, @metrics.to_params
        end

        should "properly encode operators" do
          @metrics << {:request_uri.contains => 'New York'}
          params = {'metrics' => 'ga:requestUri%3D~New+York'}

          assert_equal params, @metrics.to_params
        end
      end
    end
    
  end
end