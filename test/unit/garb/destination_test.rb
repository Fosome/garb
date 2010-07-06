require 'test_helper'

module Garb
  class DestinationTest < MiniTest::Unit::TestCase
    context 'A Destination' do
      should "have a match_type and an expression" do
        destination = Destination.new({'matchType' => 'exact', 'expression' => '/contact.html', 'caseSensitive' => 'false'})
        assert_equal 'exact', destination.match_type
        assert_equal '/contact.html', destination.expression
      end

      should "know if it's case sensitive" do
        destination = Destination.new({'matchType' => 'exact', 'expression' => '/contact.html', 'caseSensitive' => 'true'})
        assert_equal true, destination.case_sensitive?
      end

      should "know if it's not case sensitive" do
        destination = Destination.new({'matchType' => 'exact', 'expression' => '/contact.html', 'caseSensitive' => 'false'})
        assert_equal false, destination.case_sensitive?
      end

      should "have steps" do
        destination = Destination.new({'ga:step' => {'name' => 'Contact', 'number' => '1', 'path' => '/'}})
        assert_equal ['Contact'], destination.steps.map(&:name)
      end
    end
  end
end
