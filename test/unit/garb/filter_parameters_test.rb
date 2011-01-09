require 'test_helper'

module Garb
  class FilterParametersTest < MiniTest::Unit::TestCase
    def self.should_define_operators(*operators)
      operators.each do |operator|
        should "create an operator and add to parameters for the #{operator} method" do
          new_operator = stub
          symbol = :foo

          SymbolOperator.expects(:new).with(:bar, operator).returns(new_operator)
          @filter_parameters.filters do
            send(operator.to_sym, :bar, 100)
          end

          parameter = {new_operator => 100}
          assert_equal parameter, @filter_parameters.parameters.last
        end
      end
    end

    context "A FilterParameters" do
      setup do
        @filter_parameters = FilterParameters.new
      end

      should_define_operators :eql, :not_eql, :gt, :gte, :lt, :lte,
        :matches, :does_not_match, :contains, :does_not_contain, :substring, :not_substring

      should "instance eval for filters" do
        blk = lambda {"in a block"}

        @filter_parameters.expects(:instance_eval)
        @filter_parameters.filters(&blk)
      end

      context "when converting parameters hash into query string parameters" do
        should "parameterize hash operators and join elements with AND" do
          @filter_parameters.filters do
            eql(:city, 'New York City')
            eql(:state, 'New York')
          end

          params = ['ga:city%3D%3DNew+York+City', 'ga:state%3D%3DNew+York']
          assert_equal params, @filter_parameters.to_params['filters'].split('%3B').sort
        end

        should "properly encode operators" do
          @filter_parameters.filters do
            contains(:page_path, 'New York')
          end

          params = {'filters' => 'ga:pagePath%3D~New+York'}
          assert_equal params, @filter_parameters.to_params
        end

        should "escape comma, semicolon, and backslash in values" do
          @filter_parameters.filters do
            eql(:url, 'this;that,thing\other')
          end

          params = {'filters' => 'ga:url%3D%3Dthis%5C%3Bthat%5C%2Cthing%5C%5Cother'}
          assert_equal params, @filter_parameters.to_params
        end
      end
    end
  end
end
