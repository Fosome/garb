module Garb  
  class ReportResponse
    def initialize(response_body)
      @xml = response_body
    end
    
    def parse      
      entries = Entry.parse(@xml)
      
      entries.collect do |entry|
        hash = {}
        
        entry.metrics.each do |m|
          name = m.name.sub(/^ga\:/,'').underscored
          hash.merge!({name => m.value})
        end
        
        entry.dimensions.each do |d|
          name = d.name.sub(/^ga\:/,'').underscored
          hash.merge!({name => d.value})
        end
        
        OpenStruct.new(hash)
      end
    end
    
    class Metric
      include HappyMapper

      tag 'metric'
      namespace 'dxp'

      attribute :name, String
      attribute :value, String
    end
  
    class Dimension
      include HappyMapper

      tag 'dimension'
      namespace 'dxp'

      attribute :name, String
      attribute :value, String
    end
  
    class Entry
      include HappyMapper
    
      tag 'entry'

      has_many :metrics, Metric
      has_many :dimensions, Dimension
    end
  end
end