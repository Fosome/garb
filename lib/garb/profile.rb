module Garb
  class Profile
    
    include Graft::Model
    
    attribute :title
    attribute :table_id, :from => 'dxp:tableId'
    
    # attribute :foo, :from => 'tag@attribute' - grabs the attribute value
    
    def id
      table_id.sub(/^ga:/, '')
    end
    
    def self.all
      url = "https://www.google.com/analytics/feeds/accounts/#{Session.email}"
      response = DataRequest.new(url).send_request
      
      xml = Hpricot.XML(response.body)
      (xml/'entry').map {|e| Garb::Profile.new(e) }
    end

  end
end