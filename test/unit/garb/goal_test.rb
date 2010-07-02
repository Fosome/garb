require 'test_helper'

module Garb
  class GoalTest < MiniTest::Unit::TestCase
    context "A Goal" do
      should "have a name, number, and value" do
        goal = Goal.new({'name' => 'Read Blog', 'number' => '1', 'value' => '10.0', 'active' => 'true'})
        assert_equal 'Read Blog', goal.name
        assert_equal 1, goal.number
        assert_equal 10.0, goal.value
      end

      should "know if it is active" do
        goal = Goal.new({'name' => 'Read Blog', 'number' => '1', 'value' => '10.0', 'active' => 'true'})
        assert goal.active?
      end

      should "know if it is not active" do
        goal = Goal.new({'name' => 'Read Blog', 'number' => '1', 'value' => '10.0', 'active' => 'false'})
        assert_equal false, goal.active?
      end
    end
  end
end
