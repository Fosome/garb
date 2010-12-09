require 'test_helper'

module Garb
  module Management
    class GoalTest < MiniTest::Unit::TestCase
      context "the Goal class" do
        should "turn entries for path into array of goals" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Goal.stubs(:new_from_entry)
          Goal.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts/~all/webproperties/~all/profiles/~all/goals')}
          assert_received(feed, :entries)
          assert_received(Goal, :new_from_entry) {|e| e.with("entry1", Session)}
        end

        should "find all goals for a given account" do
          Goal.stubs(:all)
          Goal.for_account(stub(:session => 'session', :path => '/accounts/123'))
          assert_received(Goal, :all) {|e| e.with('session', '/accounts/123/webproperties/~all/profiles/~all/goals')}
        end

        should "find all goals for a given web_property" do
          Goal.stubs(:all)
          Goal.for_web_property(stub(:session => 'session', :path => '/accounts/123/webproperties/456'))
          assert_received(Goal, :all) {|e| e.with('session', '/accounts/123/webproperties/456/profiles/~all/goals')}
        end

        should "find all goals for a given profile" do
          Goal.stubs(:all)
          Goal.for_profile(stub(:session => 'session', :path => '/accounts/123/webproperties/456/profiles/789'))
          assert_received(Goal, :all) {|e| e.with('session', '/accounts/123/webproperties/456/profiles/789/goals')}
        end
      end

      context "a Goal" do
        setup do
          entry = {
            "link" => [{"rel" => "self", "href" => Feed::BASE_URL+"/accounts/1189765/webproperties/UA-1189765-1/profiles/98765"}],
            "ga:goal" => {
              "ga:destination"=>{"caseSensitive"=>"false","expression"=>"/blog.html","matchType"=>"head"},
              "active"=>"true",
              "name"=>"Read Blog",
              "number"=>"1",
              "value"=>"10.0"
            }
          }

          @goal = Goal.new_from_entry(entry, Session)
        end

        should "have a name" do
          assert_equal "Read Blog", @goal.name
        end

        should "have a number" do
          assert_equal 1, @goal.number
        end

        should "have a value" do
          assert_equal 10.0, @goal.value
        end

        should "know if it is active" do
          assert_equal true, @goal.active?
        end

        should "know if it is not active" do
          @goal.active = false
          assert_equal false, @goal.active?
        end

        should "have a destination" do
          assert_equal true, @goal.destination.is_a?(Destination)
        end
      end
    end
  end
end
