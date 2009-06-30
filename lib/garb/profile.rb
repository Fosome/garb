module Garb
  class Profile
    
    attr_reader :table_id, :title, :account_name, :account_id
    
    class Property
      include HappyMapper
      
      tag 'property'
      namespace 'dxp'
      
      attribute :name, String
      attribute :value, String

      def instance_name
        name.from_ga.underscored
      end
    end

    class Entry
      include HappyMapper
      
      tag 'entry'

      element :title, String
      element :tableId, String, :namespace => 'dxp'

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
      @table_id.from_ga
    end

    def self.all
      url = "https://www.google.com/analytics/feeds/accounts/default"
      response = DataRequest.new(url).send_request      
      Entry.parse(response.body).map {|entry| new(entry)}
    end
  end
end
