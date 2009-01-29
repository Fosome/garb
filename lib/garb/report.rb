module Garb
  class Report
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"
    
    attr_accessor :metrics, :dimensions, :sort,
      :start_date, :max_results,
      :end_date, :profile

    def self.element_id(property_name)
      property_name.is_a?(Symbol) ? "ga:#{property_name}" : property_name
    end
    
    def self.property_value(entry, property_name)
      entry[GA, property_name.to_s].first
    end
    
    def self.property_values(entry, property_names)
      property_names.inject({}) do |hash, property_name|
        hash.merge({property_name => property_value(entry, property_name)})
      end
    end

    def self.format_time(t)
      t.strftime('%Y-%m-%d')
    end

    def initialize(profile, opts={})
      @profile = profile
      @metrics = opts.fetch(:metrics, [])
      @dimensions = opts.fetch(:dimensions, [])
      @sort = opts.fetch(:sort, [])
      @start_date = opts.fetch(:start_date, Time.now - MONTH)
      @end_date = opts.fetch(:end_date, Time.now)
      yield self if block_given?
    end
    
    def metric_params
      {'metrics' => parameterize(metrics)}
    end

    def dimension_params
      {'dimensions' => parameterize(dimensions)}
    end
    
    def sort_params
      {'sort' => parameterize(sort)}
    end

    def page_params
      max_results.nil? ? {} : {'max-results' => max_results}
    end
    
    def default_params
      {'ids' => profile.tableId,
        'start-date' => self.class.format_time(start_date),
        'end-date' => self.class.format_time(end_date)}
    end

    def params
      [metric_params, dimension_params, sort_params, page_params].inject(default_params) do |p, i|
        p.merge(i)
      end
    end
    
    def request
      @request = Request.new(URL, params)
      @request.session = profile.session
      @request
    end
    
    def all
      entries = []
      feed = request.get
      feed.each_entry do |entry|
        entries << self.class.property_values(entry, metrics+dimensions)
      end
      entries
    end

    private
    def parameterize(coll)
      coll.collect{|prop| self.class.element_id(prop)}.join(',')
    end
  end
end