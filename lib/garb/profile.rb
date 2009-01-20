module Garb
  class Profile
    attr_reader :tableId, :title
    
    def initialize(entry)
      @tableId = Report.property_value(entry, :tableId)
      @title = entry.title
    end
  end
end