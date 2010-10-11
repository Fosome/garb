require 'test_helper'

module Garb
  module Management
    class ProfileTest < MiniTest::Unit::TestCase
      context "The Profile class" do
        should "turn entries for path into array of profile" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Profile.stubs(:new)
          Profile.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts/~all/webproperties/~all/profiles')}
          assert_received(feed, :entries)
          assert_received(Profile, :new) {|e| e.with("entry1", Session)}
        end

        should "find all web properties for a given account"
        should "find all web properties for a given web_property"
      end

      context "A Profile" do
        setup do
          entry = {
            "link" => [{"rel" => "self", "href" => Feed::BASE_URL+"/accounts/1189765/webproperties/UA-1189765-1/profiles/98765"}],
            "dxp:property" => [
              {"name" => "ga:profileId", "value" => "98765"},
              {"name" => "ga:accountId", "value" => "1189765"},
              {"name" => "ga:webPropertyId", "value" => 'UA-1189765-1'},
              {"name" => "ga:profileName", "value" => "example.com"}
            ]
          }
          @profile = Profile.new(entry, Session)
        end

        should "have a title" do
          assert_equal "example.com", @profile.title
        end

        should "have an id" do
          assert_equal '98765', @profile.id
        end

        should "have an account_id" do
          assert_equal '1189765', @profile.account_id
        end

        should "have a web_property_id" do
          assert_equal 'UA-1189765-1', @profile.web_property_id
        end

        should "have a path" do
          assert_equal "/accounts/1189765/webproperties/UA-1189765-1/profiles/98765", @profile.path
        end
      end
    end
  end
end
