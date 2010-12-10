module Garb
  module Resource
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    def self.extended(base)
      # define a method on a module that gets included into profile
      # Exits would make:
      # to enable profile.exits(options_hash, &block)
      # returns Exits.results(self, options_hash, &block)
      # every class defined which extends Resource will add to the module

      ActiveSupport::Deprecation.warn("The use of Garb::Resource will be removed in favor of 'extend Garb::Model'")
      ProfileReports.add_report_method(base)
    end

    %w(metrics dimensions sort).each do |parameter|
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

    def filters(*hashes, &block)
      @filter_parameters ||= FilterParameters.new

      hashes.each do |hash|
        @filter_parameters.parameters << hash
      end

      @filter_parameters.filters(&block) if block_given?
      @filter_parameters
    end

    def clear_filters
      @filter_parameters = FilterParameters.new
    end

    def set_segment_id(id)
      @segment = "gaid::#{id.to_i}"
    end

    def segment
      @segment
    end

    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    def results(profile, opts = {}, &block)
      @profile = profile.is_a?(Profile) ? profile : Profile.first(profile, opts.fetch(:session, Session))

      if @profile
        @start_date = opts.fetch(:start_date, Time.now - MONTH)
        @end_date = opts.fetch(:end_date, Time.now)
        @limit = opts.fetch(:limit, nil)
        @offset = opts.fetch(:offset, nil)

        instance_eval(&block) if block_given?

        ReportResponse.new(send_request_for_body, instance_klass).results
      else
        []
      end
    end

    def page_params
      {'max-results' => @limit, 'start-index' => @offset}.reject{|k,v| v.nil?}
    end

    def default_params
      {'ids' => @profile.table_id,
        'start-date' => format_time(@start_date),
        'end-date' => format_time(@end_date)}
    end

    def segment_params
      segment.nil? ? {} : {'segment' => segment}
    end

    def params
      [
        metrics.to_params,
        dimensions.to_params,
        sort.to_params,
        filters.to_params,
        page_params,
        segment_params
      ].inject(default_params) do |p, i|
        p.merge(i)
      end
    end

    def format_time(t)
      t.strftime('%Y-%m-%d')
    end

    def send_request_for_body
      request = DataRequest.new(@profile.session, URL, params)
      response = request.send_request
      response.body
    end
  end
end
