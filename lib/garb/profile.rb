module Garb
  class Profile
    
    attr_reader :table_id, :title, :account_name, :account_id, :web_property_id
    
    class Property
      include HappyMapper
      
      tag 'property'
      namespace 'http://schemas.google.com/analytics/2009'
      
      attribute :name, String
      attribute :value, String

      def instance_name
        name.from_google_analytics.underscore
      end
    end

    class Entry
      include HappyMapper
      
      tag 'entry'

      element :title, String
      element :tableId, String, :namespace => 'http://schemas.google.com/analytics/2009'

      has_many :properties, Property
    end

    def initialize(entry)
      @title = entry.title
      @table_id = entry.tableId

      entry.properties.each do |p|
        instance_variable_set :"@#{p.instance_name}", p.value
      end
    end

    def id
      @table_id.from_google_analytics
    end

    def self.all
      url = "https://www.google.com/analytics/feeds/accounts/default"
      response = DataRequest.new(url).send_request      
      profiles = Entry.parse(response.body).map {|entry| new(entry)}
      ProfileArray.new(profiles)
    end

    def self.first(id)
      all.detect {|profile| profile.id == id || profile.web_property_id == id }
    end
  end
end
