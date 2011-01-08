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
      feed? ? parsed_xml['feed']['openSearch:totalResults'].to_i : 0
    end

    alias :size :total_results
    alias :count :total_results

    def sampled?
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
      feed? ? [parsed_xml['feed']['entry']].flatten.compact : []
    end

    def parsed_xml
      @parsed_xml ||= Crack::XML.parse(@xml)
    end

    def feed?
      !parsed_xml['feed'].nil?
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
