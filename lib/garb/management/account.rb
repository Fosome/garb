module Garb
  class Account
    attr_reader :id, :name, :profiles

    # def initialize(profiles)
    #   @id = profiles.first.account_id
    #   @name = profiles.first.account_name
    #   @profiles = profiles
    # end

    # def self.all(session = Session)
    #   profiles = {}
    # 
    #   Profile.all(session).each do |profile|
    #     (profiles[profile.account_id] ||= []) << profile
    #   end
    # 
    #   profiles.map {|k,v| v}.map {|profiles| new(profiles)}
    # end

    extend ManagementFeed

    def self.all(*)
      super # builds request and parses response

      @parsed_response['entry'].map {|entry| new(entry)}
    end

    def self.path
      '/accounts'
    end

    def path
      [self.class.path, self.id].join('/')
    end

    def initialize(entry)
      @id = entry[]
    end

    # def web_properties
    #   @web_properties ||= WebProperty.for_account(self) # will call path
    # end
  end
end
