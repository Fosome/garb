module Garb  
  class ReportResponse
    KEYS = ['dxp$metric', 'dxp$dimension']

    def initialize(response_body, instance_klass = OpenStruct)
      @data = response_body
      @instance_klass = instance_klass
    end

    def results
      if @results.nil?
        @results = ResultSet.new(parse)
        @results.total_results = parse_total_results
        @results.sampled = parse_sampled_flag
        @results.aggregate_total_visits = parse_aggregate_total_visits
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
      feed? ? [parsed_data['feed']['entry']].flatten.compact : []
    end

    def parse_total_results
      feed? && !parsed_data['feed']['openSearch$totalResults'].nil? ? parsed_data['feed']['openSearch$totalResults']['$t'].to_i : 0
    end

    def parse_sampled_flag
      feed? ? (parsed_data['feed']['dxp$containsSampledData'] == 'true') : false
    end

    def parse_aggregate_total_visits
      if feed? && aggregate_visits = parsed_data['feed']['dxp$aggregates']['dxp$metric'].detect { |metric| metric['name'] == Garb::to_ga('visits') }
        aggregate_visits['value'].to_i
      else
        0
      end
    end

    def parsed_data
      @parsed_data ||= JSON.parse(@data)
    end

    def feed?
      !parsed_data['feed'].nil?
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
