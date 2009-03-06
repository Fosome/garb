module Garb
  class Profile
    attr_reader :table_id, :title, :session
    
    def initialize(entry, session)
      @session = session
      @table_id = Report.property_value(entry, :"dxp:tableId")
      @title = Report.property_value(entry, :title)
    end
    
    def build(report_class)
      report_class.new(self)
    end
  end
end