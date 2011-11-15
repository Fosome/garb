require 'test_helper'

module Garb
  class FilterParametersTest < MiniTest::Unit::TestCase
    # def self.should_define_operators(*operators)
    #   operators.each do |operator|
    #     should "create an operator and add to parameters for the #{operator} method" do
    #       new_operator = stub
    #       symbol = :foo
    # 
    #       SymbolOperator.expects(:new).with(:bar, operator).returns(new_operator)
    #       @filter_parameters.filters do
    #         send(operator.to_sym, :bar, 100)
    #       end
    # 
    #       parameter = {new_operator => 100}
    #       assert_equal parameter, @filter_parameters.parameters.last
    #     end
    #   end
    # end

    context "A FilterParameters" do
      context "when converting parameters hash into query string parameters" do
        should "parameterize hash operators and join elements with AND" do
          filters = FilterParameters.new({:city.eql => 'New York City', :state.eql => 'New York'})

          params = ['ga:city%3D%3DNew+York+City', 'ga:state%3D%3DNew+York']
          assert_equal params, filters.to_params['filters'].split('%3B').sort
        end

        should "properly encode operators" do
          filters = FilterParameters.new({:page_path.contains => 'New York'})

          params = {'filters' => 'ga:pagePath%3D~New+York'}
          assert_equal params, filters.to_params
        end

        should "escape comma, semicolon, and backslash in values" do
          filters = FilterParameters.new({:url.eql => 'this;that,thing\other'})

          params = {'filters' => 'ga:url%3D%3Dthis%5C%3Bthat%5C%2Cthing%5C%5Cother'}
          assert_equal params, filters.to_params
        end

        should "handle nested arrays mixed with hashes" do
          filters = FilterParameters.new([{:page_path.contains => 'NYC'}, [{:city.eql => 'New York City'}, {:state.eql => 'New York'}]])

          params = ['ga:pagePath%3D~NYC,ga:city%3D%3DNew+York+City,ga:state%3D%3DNew+York']
          assert_equal params, filters.to_params['filters'].split('%3B').sort
        end

        should "handle 3 filters ORed together" do
          filters = FilterParameters.new([{:keyword.substring => 'seo'}, {:keyword.contains => "^(?:.*\\W+)?(open)\\W+(site)(?:\\W+.*)?$"}, {:keyword.eql => 'yahoo'}])

          params = ["ga:keyword%3D%3Dyahoo","ga:keyword%3D@seo","ga:keyword%3D~%5E%28%3F%3A.%2A%5C%5CW%2B%29%3F%28open%29%5C%5CW%2B%28site%29%28%3F%3A%5C%5CW%2B.%2A%29%3F%24"]
          assert_equal params, filters.to_params['filters'].split(',').sort
        end

        should "handle 3 filters ORed together ANDed with a 4th" do
          or_group = [{:keyword.substring => 'seo'}, {:keyword.contains => "^(?:.*\\W+)?(open)\\W+(site)(?:\\W+.*)?$"}, {:keyword.eql => 'yahoo'}]
          filters = FilterParameters.new({:or_group => or_group, :keyword.not_eql => 'seomoz blog'})

          and_split = filters.to_params['filters'].split('%3B').sort
          assert_equal 2, and_split.size
          assert_equal "ga:keyword!%3Dseomoz+blog", and_split[0]
          params = ["ga:keyword%3D%3Dyahoo","ga:keyword%3D@seo","ga:keyword%3D~%5E%28%3F%3A.%2A%5C%5CW%2B%29%3F%28open%29%5C%5CW%2B%28site%29%28%3F%3A%5C%5CW%2B.%2A%29%3F%24"]
          assert_equal params, and_split[1].split(',').sort
        end
      end
    end
  end
end
