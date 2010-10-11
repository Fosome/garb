module Garb
  class Report
    include Resource

    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    def initialize(profile, opts={})
      ActiveSupport::Deprecation.warn("The use of Report will be removed in favor of 'extend Garb::Model'")

      @profile = profile

      @start_date = opts.fetch(:start_date, Time.now - MONTH)
      @end_date = opts.fetch(:end_date, Time.now)
      @limit = opts.fetch(:limit, nil)
      @offset = opts.fetch(:offset, nil)

      metrics opts.fetch(:metrics, [])
      dimensions opts.fetch(:dimensions, [])
      sort opts.fetch(:sort, [])
    end

    def results
      ReportResponse.new(send_request_for_body).results
    end

  end
end
