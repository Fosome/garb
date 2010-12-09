require 'test_helper'

module Garb
  module Management
    class AccountTest < MiniTest::Unit::TestCase
      context "The Account class" do
        should "turn entries for path into array of accounts" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Account.stubs(:new_from_entry)
          Account.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts')}
          assert_received(feed, :entries)
          assert_received(Account, :new_from_entry) {|e| e.with("entry1", Session)}
        end
      end

      context "an Account" do
        setup do
          entry = {
            "title" => "Google Analytics Account Garb",
            "link" => [{"rel" => "self", "href" => Feed::BASE_URL+"/accounts/123456"}],
            "dxp:property" => [
              {"name" => "ga:accountId", "value" => "123456"},
              {"name" => "ga:accountName", "value" => "Garb"}
            ]
          }
          @account = Account.new_from_entry(entry, Session)
        end

        should "extract id and title from GA entry" do
          assert_equal "Garb", @account.title
          assert_equal "123456", @account.id
        end

        should "extract a name from GA entry properties" do
          assert_equal "Garb", @account.name
        end

        should "combine the Account.path and the id into an new path" do
          assert_equal "/accounts/123456", @account.path
        end

        should "have a reference to the session it was created with" do
          assert_equal Session, @account.session
        end

        should "have web properties" do
          WebProperty.stubs(:for_account)
          @account.web_properties
          assert_received(WebProperty, :for_account) {|e| e.with(@account)}
        end

        should "have profiles" do
          Profile.stubs(:for_account)
          @account.profiles
          assert_received(Profile, :for_account) {|e| e.with(@account)}
        end

        should "have goals" do
          Goal.stubs(:for_account)
          @account.goals
          assert_received(Goal, :for_account) {|e| e.with(@account)}
        end
      end
    end
  end
end
