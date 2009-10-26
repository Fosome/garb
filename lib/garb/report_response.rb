module Garb  
  class ReportResponse
    # include Enumerable

    def initialize(response_body)
      @xml = response_body
    end
    
    def parse      
      entries = Entry.parse(@xml)
      
      @results = entries.collect do |entry|
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

    def results
      @results || parse
    end
    
    class Metric
      include HappyMapper

      tag 'metric'
      namespace 'http://schemas.google.com/analytics/2009'

      attribute :name, String
      attribute :value, String
    end
  
    class Dimension
      include HappyMapper

      tag 'dimension'
      namespace 'http://schemas.google.com/analytics/2009'

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