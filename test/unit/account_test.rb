require File.join(File.dirname(__FILE__), '..', '/test_helper')

module Garb
  class AccountTest < Test::Unit::TestCase
    context "The Account class" do
      should "have an array of accounts with all profiles" do
        p1 = stub(:account_id => '1111', :account_name => 'Blog 1')
        p2 = stub(:account_id => '1112', :account_name => 'Blog 2')
        Profile.stubs(:all).returns([p1,p2,p1,p2])
        Account.expects(:new).with([p1,p1]).returns('account1')
        Account.expects(:new).with([p2,p2]).returns('account2')
        assert_equal ['account1','account2'], Account.all
      end
    end

    context "An instance of the Account class" do
      context "when creating a new account from an array of profiles" do
        setup do
          profile = stub(:account_id => '1111', :account_name => 'Blog 1')
          @profiles = [profile,profile]
          @account = Account.new(@profiles)
        end

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
