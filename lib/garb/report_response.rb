module Garb  
  class ReportResponse
    KEYS = ['dxp:metric', 'dxp:dimension']

    def initialize(response_body, instance_klass = OpenStruct)
      @xml = response_body
      @instance_klass = instance_klass
    end

    def results
      @results ||= parse
    end

    def total_results
      response_hash = Crack::XML.parse(@xml)
      response_hash ? response_hash['feed']['openSearch:totalResults'].to_i : 0
    end

    private
    def parse
      entries.map do |entry|
        @instance_klass.new(Hash[
          values_for(entry).map {|v| [Garb.from_ga(v['name']), v['value']]}
        ])
      end
    end

    def entries
      entry_hash = Crack::XML.parse(@xml)
      entry_hash ? [entry_hash['feed']['entry']].flatten.compact : []
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
