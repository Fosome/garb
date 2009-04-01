module Garb
  class Profile
    
    attr_reader :table_id, :title, :account_name
    
    class Property
      include HappyMapper
      
      tag 'property'
      namespace 'dxp'
      
      attribute :name, String
      attribute :value, String
    end

    class Entry
      include HappyMapper
      
      tag 'entry'
      
      element :id, Integer
      element :title, String
      element :tableId, String, :namespace => 'dxp'
      
      # has_one :table_id, TableId
      has_many :properties, Property
    end

    def initialize(entry)
      @title = entry.title
      @table_id = entry.tableId
      @account_name = entry.properties.detect{|p| p.name == 'ga:accountName'}.value
    end
    
    def id
      @table_id.sub(/^ga:/, '')
    end
    
    def self.all
      url = "https://www.google.com/analytics/feeds/accounts/#{Session.email}"
      response = DataRequest.new(url).send_request      
      Entry.parse(response.body).map {|e| Garb::Profile.new(e)}
    end
  end
end
