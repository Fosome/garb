module Garb
  class Account
    attr_reader :id, :name, :profiles

    def initialize(profiles)
      @id = profiles.first.account_id    
      @name = profiles.first.account_name
      @profiles = profiles
    end

    def self.all
      Profile.all.group_by{|p| p.account_id}.map{|profiles| new(profiles)}
    end
  end
end
