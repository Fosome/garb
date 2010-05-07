module Garb
  class Profile

    include ProfileReports

    attr_reader :session, :table_id, :title, :account_name, :account_id, :web_property_id, :segments

    def initialize(entry, session)
      @session = session
      @title = entry['title']
      @table_id = entry['dxp:tableId']

      entry['dxp:property'].each do |p|
        instance_variable_set :"@#{Garb.from_ga(p['name'])}", p['value']
      end
    end

    def id
      Garb.from_ga(@table_id)
    end

    def self.all(session = Session)
      url = "https://www.google.com/analytics/feeds/accounts/default"
      response = DataRequest.new(session, url).send_request

      puts response.body
      parse_entries(parse(response.body)).map {|entry| new(entry, session)}
    end

    def self.first(id, session = Session)
      all(session).detect {|profile| profile.id == id || profile.web_property_id == id }
    end

    def self.parse_entries(entry_hash)
      entry_hash ? [entry_hash['feed']['entry']].flatten : []
    end

    def self.parse(response_body)
      Crack::XML.parse(response_body)
    end
  end
end
