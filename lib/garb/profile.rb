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
      (xml/'entry').map {|e| puts "in code: #{e.class}"; Garb::Profile.new(e) }
    end
    
    # attr_reader :table_id, :title, :session
    # 
    # def initialize(entry, session)
    #   @session = session
    #   @table_id = Report.property_value(entry, :"dxp:tableId")
    #   @title = Report.property_value(entry, :title)
    # end
    # 
    # def build(report_class)
    #   report_class.new(self)
    # end
  end
end