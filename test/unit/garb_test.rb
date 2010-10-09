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

    should "have a helper to parse properties out of entries" do
      entry = {"dxp:property"=>[{"name"=>"ga:accountId", "value"=>"1189765"}, {"name"=>"ga:webPropertyId", "value"=>"UA-1189765-1"}]}

      assert_equal({"account_id" => '1189765', "web_property_id" => "UA-1189765-1"}, Garb.parse_properties(entry))
    end

    should "parse out the self link" do
      entry = {"link" => [{"rel" => "self", "href" => "http://google.com/accounts/12345"}]}

      assert_equal "http://google.com/accounts/12345", Garb.parse_link(entry, "self")
    end
  end
end
