require 'ostruct'

module Garb
  class Report
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    METRICS = {
      :visitor => [
        :avgPageviews,
        :avgSessionTime,
        :bounces,
        :bounceRate,
        :entrances,
        :exits,
        :exitRate,
        :newVisitors,
        :pageDuration,
        :pageviews,
        :visitDuration,
        :visitors,
        :visits
      ],
      :campaign => [
        :cost,
        :clicks,
        :clickThroughRate,
        :costPerConversion,
        :costPerGoalConversion,
        :costPerMilleImpressions,
        :costPerTransaction,
        :impressions
      ],
      :content => [
        :uniquePageviews
      ],
      :ecommerce => [
        :productPurchases,
        :productRevenue,
        :products,
        :revenue,
        :revenuePerClick,
        :revenuePerTransaction,
        :revenuePerVisit,
        :shipping,
        :tax,
        :transactions
      ],
      :internal_search => [
        :searchDepth,
        :searchDuration,
        :searchExits,
        :searchTransitions,
        :uniqueInternalSearches,
        :visitsWithSearches
      ],
      :goals => [
        :goalCompletions1,
        :goalCompletions2,
        :goalCompletions3,
        :goalCompletions4,
        :goalCompletionsAll,
        :goalConversionRate,
        :goalStarts1,
        :goalStarts2,
        :goalStarts3,
        :goalStarts4,
        :goalStartsAll,
        :goalValue1,
        :goalValue2,
        :goalValue3,
        :goalValue4,
        :goalValueAll,
        :goalValuePerVisit
      ]
    }
    
    DIMENSIONS = {
      :visitor => [
        :browser,
        :browserVersion,
        :city,
        :connectionSpeed,
        :continent,
        :country,
        :daysSinceLastVisit,
        :domain,
        :flashVersion,
        :hostname,
        :hour,
        :javaEnabled,
        :languqage,
        :medium,
        :organization,
        :pageDepth,
        :platform,
        :platformVersion,
        :referralPath,
        :region,
        :screenColors,
        :screenResolution,
        :subContinentRegion,
        :userDefinedValue,
        :visitNumber,
        :visitorType
      ],
      :campaign => [
        :adGroup,
        :adSlot,
        :adSlotPosition,
        :campaign,
        :content,
        :keyword,
        :source,
        :sourceMedium
      ],
      :content => [
        :pageTitle,
        :requestUri,
        :requestUri1,
        :requestUriLast
      ],
      :ecommerce => [
        :affiliation,
        :daysToTransaction,
        :productCode,
        :productName,
        :productVariation,
        :transactionId,
        :visitsToTransaction
      ],
      :internal_search => [
        :hasInternalSearch,
        :internalSearchKeyword,
        :internalSearchNext,
        :internalSearchType
      ]
    }
    
    attr_accessor :metrics, :dimensions, :sort, :filters,
      :start_date, :max_results, :end_date, :profile

    def self.element_id(property_name)
      property_name.is_a?(Operator) ? property_name.to_s : property_name.to_ga.lower_camelized
    end
    
    def self.property_value(entry, property_name)
      (entry/property_name).first.inner_text
    end
    
    def self.property_values(entry, property_names)
      hash = property_names.inject({}) do |hash, property_name|
        hash.merge({property_name => property_value(entry, property_name.to_s.lower_camelized)})
      end
      OpenStruct.new hash
    end

    def self.format_time(t)
      t.strftime('%Y-%m-%d')
    end

    def initialize(profile, opts={})
      @profile = profile
      @metrics = opts.fetch(:metrics, [])
      @dimensions = opts.fetch(:dimensions, [])
      @sort = opts.fetch(:sort, [])
      @filters = opts.fetch(:filters, [])
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
    
    def filters_params
      {'filters' => parameterize(filters)}
    end

    def page_params
      max_results.nil? ? {} : {'max-results' => max_results}
    end
    
    def default_params
      {'ids' => profile.table_id,
        'start-date' => self.class.format_time(start_date),
        'end-date' => self.class.format_time(end_date)}
    end

    def params
      [metric_params, dimension_params, sort_params, page_params].inject(default_params) do |p, i|
        p.merge(i)
      end
    end
    
    def request
      @request = DataRequest.new(URL, params)
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
      coll.collect do |elem|
        case elem
        when String, Symbol, Operator
          self.class.element_id(elem)
        when Hash # filters
          elem.collect do |k,v|
            next unless k.is_a?(Operator)
            "#{k.target}#{CGI::escape(k.operator.to_s)}#{CGI::escape(v.to_s)}"
          end.join(';')
        end
      end.join(',')
    end
  end
end