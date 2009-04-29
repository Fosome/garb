require File.join(File.dirname(__FILE__), '..', '/test_helper')

class SymbolTest < Test::Unit::TestCase
  
  context "An instance of the Symbol class" do
    
    should "properly format itself for ga" do
      assert_equal "ga:requestUri", :request_uri.to_ga
    end
    
    should "define a :desc operator" do
      operator = stub()
      symbol = :foo
      
      Operator.expects(:new).with(:foo, '-', true).returns(operator)
      assert_equal operator, :foo.desc
    end

    def self.should_define_operator(operators)
      operators.each do |method, operator|
        should "define an :#{method} operator" do
          new_operator = stub()
          symbol = :foo

          Operator.expects(:new).with(:foo, operator).returns(new_operator)
          assert_equal new_operator, :foo.send(method)
        end
      end
    end

    should_define_operator  :eql => '==',
                            :not_eql => '!=',
                            :gt => '>',
                            :gte => '>=',
                            :lt => '<',
                            :lte => '<=',
                            :matches => '==',
                            :does_not_match => '!=',
                            :contains => '=~',
                            :does_not_contain => '!~',
                            :substring => '=@',
                            :not_substring => '!@'
  end
end