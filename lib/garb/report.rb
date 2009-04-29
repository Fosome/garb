module Garb
  class Report
    include Resource::ResourceMethods

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

    def initialize(profile, opts={})
      metrics opts.delete(:metrics)
      dimensions opts.delete(:dimensions)
    end

  end
end
