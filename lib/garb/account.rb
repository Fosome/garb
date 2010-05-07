module Garb
  class Account
    attr_reader :id, :name, :profiles

    def initialize(profiles)
      @id = profiles.first.account_id    
      @name = profiles.first.account_name
      @profiles = profiles
    end

    def self.all(session = Session)
      profiles = {}

      Profile.all(session).each do |profile|
        (profiles[profile.account_id] ||= []) << profile
      end

      profiles.map {|k,v| v}.map {|profiles| new(profiles)}
    end
  end
end
