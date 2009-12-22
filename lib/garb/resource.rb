module Garb
  module Resource
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    %w(metrics dimensions filters sort).each do |parameter|
      class_eval <<-CODE
        def #{parameter}(*fields)
          @#{parameter} ||= ReportParameter.new(:#{parameter})
          @#{parameter} << fields
        end

        def clear_#{parameter}
          @#{parameter} = ReportParameter.new(:#{parameter})
        end
      CODE
    end

    # def metrics(*fields)
    #   @metrics ||= ReportParameter.new(:metrics)
    #   @metrics << fields
    # end
    # 
    # def dimensions(*fields)
    #   @dimensions ||= ReportParameter.new(:dimensions)
    #   @dimensions << fields
    # end
    # 
    # def filters(*hashes)
    #   @filters ||= ReportParameter.new(:filters)
    #   @filters << hashes
    # end
    # 
    # def sort(*fields)
    #   @sort ||= ReportParameter.new(:sort)
    #   @sort << fields
    # end
    # 
    # def clear_filters
    #   @filters = ReportParameter.new(:filters)
    # end
    # 
    # def clear_sort
    #   @sort = ReportParameter.new(:sort)
    # end

    def results(profile, opts = {}, &block)
      @profile = profile.is_a?(Profile) ? profile : Profile.first(profile)

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
        sort.to_params,
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
