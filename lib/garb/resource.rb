module Garb
  module Resource
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    def self.included(report)
      report.extend(ResourceMethods)
    end

    module ResourceMethods

      def metrics(*fields)
        @metrics ||= ReportParameter.new(:metrics)
        @metrics << fields
      end

      def dimensions(*fields)
        @dimensions ||= ReportParameter.new(:dimensions)
        @dimensions << fields
      end

      def filter(*hash)
        @filters << hash
      end

      def filters
        @filters ||= ReportParameter.new(:filters)
      end

      def sort(*fields)
        @sorts << fields
      end

      def sorts
        @sorts ||= ReportParameter.new(:sort)
      end

      def results(profile, opts = {}, &block)
        @profile = profile

        # clear filters and sort
        @filters = ReportParameter.new(:filters)
        @sorts = ReportParameter.new(:sort)

        @start_date = opts.fetch(:start_date, Time.now - MONTH)
        @end_date = opts.fetch(:end_date, Time.now)
        @limit = opts.fetch(:limit, nil)
        @offset = opts.fetch(:offset, nil)

        instance_eval(&block) if block_given?

        ReportResponse.new(send_request_for_body).results
      end

      def page_params
        {'max-results' => @limit, 'start-index' => @offset}.reject{|k,v| v.nil?}
      end

      def default_params
        {'ids' => @profile.table_id,
          'start-date' => format_time(@start_date),
          'end-date' => format_time(@end_date)}
      end

      def params
        [
          metrics.to_params,
          dimensions.to_params,
          sorts.to_params,
          filters.to_params,
          page_params
        ].inject(default_params) do |p, i|
          p.merge(i)
        end
      end

      def format_time(t)
        t.strftime('%Y-%m-%d')
      end

      def send_request_for_body
        request = DataRequest.new(URL, params)
        response = request.send_request
        response.body
      end

    end
  end
end
