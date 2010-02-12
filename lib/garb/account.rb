module Garb
  class Account
    attr_reader :id, :name, :profiles

    def initialize(profiles)
      @id = profiles.first.account_id    
      @name = profiles.first.account_name
      @profiles = profiles
    end

    def self.all(session = Session)
      # Profile.all.group_to_array{|p| p.account_id}.map{|profiles| new(profiles)}

      profile_groups = Profile.all(session).inject({}) do |hash, profile|
        key = profile.account_id
        
        if hash.has_key?(key)
          hash[key] << profile
        else
          hash[key] = [profile]
        end

        hash
      end

      profile_groups.map {|k,v| v}.map {|profiles| new(profiles)}
    end
  end
end
