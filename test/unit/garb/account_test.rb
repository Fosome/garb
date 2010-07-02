require 'test_helper'

module Garb
  class AccountTest < MiniTest::Unit::TestCase
    context "The Account class" do
      should "have an array of accounts with all profiles" do
        p1 = stub(:account_id => '1111', :account_name => 'Blog 1')
        p2 = stub(:account_id => '1112', :account_name => 'Blog 2')

        Profile.stubs(:all).returns([p1,p2,p1,p2])
        Account.stubs(:new).returns('account1', 'account2')

        assert_equal ['account1','account2'], Account.all
        assert_received(Profile, :all)
        assert_received(Account, :new) {|e| e.with([p1,p1])}
        assert_received(Account, :new) {|e| e.with([p2,p2])}
      end
    end

    context "An instance of the Account class" do
      setup do
        profile = stub(:account_id => '1111', :account_name => 'Blog 1')
        @profiles = [profile,profile]
        @account = Account.new(@profiles)
      end

      context "all" do
        should "use an optional user session" do
          session = Session.new
          Garb::Profile.expects(:all).with(session).returns(@profiles)

          accounts = Account.all(session)
          assert_equal 1, accounts.size
          assert_equal @profiles, accounts.first.profiles
        end
      end

      context "when creating a new account from an array of profiles" do
        should "take the account id from the first profile" do
          assert_equal @profiles.first.account_id, @account.id
        end

        should "take the account name from the first profile" do
          assert_equal @profiles.first.account_name, @account.name
        end

        should "store the array of profiles" do
          assert_equal @profiles, @account.profiles
        end
      end
    end
  end
end
