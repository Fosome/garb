require 'test_helper'

class GarbTest < MiniTest::Unit::TestCase
  context "The Garb module" do
    should 'prefix a string with ga: for GA' do
      assert_equal '-ga:bob', Garb.to_google_analytics(stub(:to_google_analytics => '-ga:bob'))
      assert_equal 'ga:bob', Garb.to_google_analytics('bob')
    end

    should 'remove ga: prefix' do
      assert_equal 'bob', Garb.from_google_analytics('ga:bob')
    end
  end
end
