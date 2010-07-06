require 'test_helper'

module Garb
  class StepTest < MiniTest::Unit::TestCase
    context "A Step" do
      should "have a name, number, and path" do
        step = Step.new({'name' => 'Contact Form Page', 'number' => '1', 'path' => '/contact.html'})

        assert_equal 'Contact Form Page', step.name
        assert_equal 1, step.number
        assert_equal '/contact.html', step.path
      end
    end
  end
end
