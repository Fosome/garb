require File.join(File.dirname(__FILE__), '..', '..', '/test_helper')

module Garb
  class FilterParametersTest < MiniTest::Unit::TestCase
    def self.should_define_operator(operator, param)
      should "create an operator and add to parameters for the #{operator} method" do
        new_operator = stub
        symbol = :foo

        Garb::Operator.expects(:new).with(:foo, param).returns(new_operator)
        @filter_parameters.send(operator.to_sym, :foo, 100)

        parameter = {new_operator => 100}
        assert_equal parameter, @filter_parameters.parameters.last
      end
    end

    context "A FilterParameters" do
      setup do
        @filter_parameters = FilterParameters.new
      end

      should_define_operator(:eql, '==')
      should_define_operator(:not_eql, '!=')
      should_define_operator(:gt, '>')
      should_define_operator(:gte, '>=')
      should_define_operator(:lt, '<')
      should_define_operator(:lte, '<=')
      should_define_operator(:matches, '==')
      should_define_operator(:does_not_match, '!=')
      should_define_operator(:contains, '=~')
      should_define_operator(:does_not_contain, '!~')
      should_define_operator(:substring, '=@')
      should_define_operator(:not_substring, '!@')

      should "instance eval for filters" do
        blk = lambda {"in a block"}

        @filter_parameters.expects(:instance_eval)
        @filter_parameters.filters(&blk)
      end

      context "when converting parameters hash into query string parameters" do
        should "parameterize hash operators and join elements" do
          @filter_parameters.filters do
            eql(:city, 'New York')
            eql(:state, 'New York')
          end

          params = {'filters' => 'ga:city%3D%3DNew+York;ga:state%3D%3DNew+York'}
          assert_equal params, @filter_parameters.to_params
        end

        should "properly encode operators" do
          @filter_parameters.filters do
            contains(:page_path, 'New York')
          end

          params = {'filters' => 'ga:pagePath%3D~New+York'}
          assert_equal params, @filter_parameters.to_params
        end
      end
    end
  end
end
