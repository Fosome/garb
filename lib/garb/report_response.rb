module Garb
  class ReportResponse
    require 'xmlsimple'

    KEYS = ['metric', 'dimension']

    def initialize(response_body, instance_klass = OpenStruct)
      @data = response_body
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
      feed? ? [parsed_data['feed']['aggregates']].flatten.compact : []
    end

    def parse_total_results
      feed? ? parsed_data['feed']['openSearch:totalResults'].to_i : 0
    end

    def parse_sampled_flag
      feed? ? (parsed_data['feed']['dxp$containsSampledData'] == 'true') : false
    end

    def parsed_data
      # @parsed_data ||= JSON.parse(@data)
      @parsed_data ||= {'feed' => XmlSimple.xml_in(@data)}
    end

    def feed?
      !parsed_data['feed'].nil?
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
