module Garb
  class Profile
    attr_reader :tableId, :title
    
    def initialize(entry, session)
      @session = session
      @tableId = Report.property_value(entry, :tableId)
      @title = entry.title
    end
    
    def get(report_class)
      report_class.new(self, @session).all
    end
  end
end