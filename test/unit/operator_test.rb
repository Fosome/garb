require File.join(File.dirname(__FILE__), '..', '/test_helper')

class OperatorTest < Test::Unit::TestCase
  context "An instance of an Operator" do
    should "lower camelize the target" do
      assert_equal "ga:uniqueVisits=", Operator.new(:unique_visits, "=").to_ga
    end
    
    should "return target and operator together" do
      assert_equal "ga:metric=", Operator.new(:metric, "=").to_ga
    end
    
    should "prefix the operator to the target" do
      assert_equal "-ga:metric", Operator.new(:metric, "-", true).to_ga
    end
    
    should "know if it is equal to another operator" do
      op1 = Operator.new(:hello, "==")
      op2 = Operator.new(:hello, "==")
      assert_equal op1, op2
    end
    
    should "not be equal to another operator if target, operator, or prefix is different" do
      op1 = Operator.new(:hello, "==")
      op2 = Operator.new(:hello, "==", true)
      assert_not_equal op1, op2
      
      op1 = Operator.new(:hello1, "==")
      op2 = Operator.new(:hello2, "==")
      assert_not_equal op1, op2
      
      op1 = Operator.new(:hello, "!=")
      op2 = Operator.new(:hello, "==")
      assert_not_equal op1, op2
    end
  end
end
