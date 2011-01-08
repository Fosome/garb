module Garb
  module Model
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    def self.extended(base)
      ProfileReports.add_report_method(base)
    end

    def metrics(*fields)
      @metrics ||= ReportParameter.new(:metrics)
      @metrics << fields
    end

    def dimensions(*fields)
      @dimensions ||= ReportParameter.new(:dimensions)
      @dimensions << fields
    end

    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    def results(profile, options = {})
      start_date = options.fetch(:start_date, Time.now - MONTH)
      end_date = options.fetch(:end_date, Time.now)
      default_params = build_default_params(profile, start_date, end_date)

      param_set = [
        default_params,
        metrics.to_params,
        dimensions.to_params,
        parse_filters(options).to_params,
        parse_segment(options),
        parse_sort(options).to_params,
        build_page_params(options)
      ]

      data = send_request_for_data(profile, build_params(param_set))
      ReportResponse.new(data, instance_klass).results
    end

    private
    def send_request_for_data(profile, params)
      request = DataRequest.new(profile.session, URL, params)
      response = request.send_request
      response.body
    end

    def build_params(param_set)
      param_set.inject({}) {|p,i| p.merge(i)}.reject{|k,v| v.nil?}
    end

    def parse_filters(options)
      filters = FilterParameters.new
      filters.parameters << options[:filters] if options.has_key?(:filters)
      filters
    end

    def parse_segment(options)
      segment_id = "gaid::#{options[:segment_id].to_i}" if options.has_key?(:segment_id)
      {'segment' => segment_id}
    end

    def parse_sort(options)
      sort = ReportParameter.new(:sort)
      sort << options[:sort] if options.has_key?(:sort)
      sort
    end

    def build_default_params(profile, start_date, end_date)
      {
        'ids' => Garb.to_ga(profile.id),
        'start-date' => format_time(start_date),
        'end-date' => format_time(end_date)
      }
    end

    def build_page_params(options)
      {'max-results' => options[:limit], 'start-index' => options[:offset]}
    end

    def format_time(t)
      t.strftime('%Y-%m-%d')
    end
  end
end