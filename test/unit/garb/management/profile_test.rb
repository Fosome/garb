require 'test_helper'

module Garb
  module Management
    class ProfileTest < MiniTest::Unit::TestCase
      context "The Profile class" do
        should "turn entries for path into array of profiles" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Profile.stubs(:new_from_entry)
          Profile.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts/~all/webproperties/~all/profiles')}
          assert_received(feed, :entries)
          assert_received(Profile, :new_from_entry) {|e| e.with("entry1", Session)}
        end

        should "find all profiles for a given account" do
          Profile.stubs(:all)
          Profile.for_account(stub(:session => 'session', :path => '/accounts/123'))
          assert_received(Profile, :all) {|e| e.with('session', '/accounts/123/webproperties/~all/profiles')}          
        end

        should "find all profiles for a given web_property" do
          Profile.stubs(:all)
          Profile.for_web_property(stub(:session => 'session', :path => '/accounts/123/webproperties/456'))
          assert_received(Profile, :all) {|e| e.with('session', '/accounts/123/webproperties/456/profiles')}
        end
      end

      context "A Profile" do
        setup do
          entry = {
            "link" => [{"rel" => "self", "href" => Feed::BASE_URL+"/accounts/1189765/webproperties/UA-1189765-1/profiles/98765"}],
            "dxp:property" => [
              {"name" => "ga:profileId", "value" => "98765"},
              {"name" => "ga:accountId", "value" => "1189765"},
              {"name" => "ga:webPropertyId", "value" => 'UA-1189765-1'},
              {"name" => "ga:profileName", "value" => "example.com"},
              {"name"=>"dxp:tableId", "value"=>"ga:4506"},
              {"name"=>"ga:currency", "value"=>"USD"},
              {"name"=>"ga:timezone", "value"=>"America/New_York"}
            ]
          }
          @profile = Profile.new_from_entry(entry, Session)
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

        should "have a table_id (for old Garb::Report)" do
          assert_equal 'ga:4506', @profile.table_id
        end

        should "have a path" do
          assert_equal "/accounts/1189765/webproperties/UA-1189765-1/profiles/98765", @profile.path
        end

        should "have goals" do
          Goal.stubs(:for_profile)
          @profile.goals
          assert_received(Goal, :for_profile) {|e| e.with(@profile)}
        end
      end
    end
  end
end
