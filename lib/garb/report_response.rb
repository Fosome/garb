module Garb  
  class ReportResponse
    KEYS = ['dxp:metric', 'dxp:dimension']

    def initialize(response_body, instance_klass = OpenStruct)
      @xml = response_body
      @instance_klass = instance_klass
    end

    def results
      if @results.nil?
        @results = ResultSet.new(parse)
        @results.total_results = parse_total_results
        @results.sampled = parse_sampled_flag
      end

      @results
    end

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

    def parse_total_results
      feed? ? parsed_xml['feed']['openSearch:totalResults'].to_i : 0
    end

    def parse_sampled_flag
      feed? ? (parsed_xml['feed']['dxp:containsSampledData'] == 'true') : false
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
