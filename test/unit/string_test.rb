require File.join(File.dirname(__FILE__), '..', '/test_helper')

class StringTest < Test::Unit::TestCase
  context "An instance of a String" do
    should 'prefix a string with ga: for GA' do
      assert_equal 'ga:bob', 'bob'.to_ga
    end

    should 'remove ga: prefix' do
      assert_equal 'bob', 'ga:bob'.from_ga
    end
  end
end