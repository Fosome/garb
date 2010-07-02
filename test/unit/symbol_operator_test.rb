require 'test_helper'

class SymbolOperatorTest < MiniTest::Unit::TestCase
  context "An instance of a SymbolOperator" do
    should "lower camelize the target" do
      assert_equal "ga:uniqueVisits==", SymbolOperator.new(:unique_visits, :eql).to_google_analytics
    end

    should "return target and operator together" do
      assert_equal "ga:metric==", SymbolOperator.new(:metric, :eql).to_google_analytics
    end

    should "prefix the operator to the target" do
      assert_equal "-ga:metric", SymbolOperator.new(:metric, :desc).to_google_analytics
    end

    # should "know if it is equal to another operator" do
    #   op1 = SymbolOperator.new(:hello, "==")
    #   op2 = SymbolOperator.new(:hello, "==")
    #   assert_equal op1, op2
    # end
    # 
    # should "not be equal to another operator if target, operator, or prefix is different" do
    #   op1 = SymbolOperator.new(:hello, "==")
    #   op2 = SymbolOperator.new(:hello, "==", true)
    #   refute_equal op1, op2
    # 
    #   op1 = SymbolOperator.new(:hello1, "==")
    #   op2 = SymbolOperator.new(:hello2, "==")
    #   refute_equal op1, op2
    # 
    #   op1 = SymbolOperator.new(:hello, "!=")
    #   op2 = SymbolOperator.new(:hello, "==")
    #   refute_equal op1, op2
    # end
  end
end
