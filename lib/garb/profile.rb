module Garb
  class Profile
    attr_reader :tableId, :title, :session
    
    def initialize(entry, session)
      @session = session
      @tableId = Report.property_value(entry, :tableId)
      @title = entry.title
    end
    
    def build(report_class)
      report_class.new(self)
    end
  end
end