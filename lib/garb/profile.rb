module Garb
  class Profile

    include ProfileReports

    attr_reader :session, :table_id, :title, :account_name, :account_id, :web_property_id, :goals

    def initialize(entry, session)
      @session = session
      @title = entry['title']
      @table_id = entry['dxp:tableId']
      @goals = (entry[Garb.to_ga('goal')] || []).map {|g| Goal.new(g)}

      Garb.parse_properties(entry).each do |k,v|
        instance_variable_set :"@#{k}", v
      end
    end

    def id
      Garb.from_ga(@table_id)
    end

    def self.all(session = Session)
      ActiveSupport::Deprecation.warn("Garb::Profile.all is deprecated in favor of Garb::Management::Profile.all")
      AccountFeedRequest.new(session).entries.map {|entry| new(entry, session)}
    end

    def self.first(id, session = Session)
      ActiveSupport::Deprecation.warn("Garb::Profile.first is deprecated in favor of Garb::Management::WebProperty")
      all(session).detect {|profile| profile.id == id || profile.web_property_id == id }
    end
  end
end
