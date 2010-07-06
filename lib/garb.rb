require 'net/http'
require 'net/https'

require 'cgi'
require 'ostruct'
require 'crack'
require 'active_support'

require 'garb/version'
require 'garb/authentication_request'
require 'garb/data_request'
require 'garb/account_feed_request'
require 'garb/session'
require 'garb/profile_reports'
require 'garb/step'
require 'garb/destination'
require 'garb/goal'
require 'garb/profile'
require 'garb/account'
require 'garb/filter_parameters'
require 'garb/report_parameter'
require 'garb/report_response'
require 'garb/resource'
require 'garb/report'

require 'support'

module Garb
  GA = "http://schemas.google.com/analytics/2008"

  extend self

  def to_google_analytics(thing)
    return thing.to_google_analytics if thing.respond_to?(:to_google_analytics)

    "ga:#{thing.to_s.camelize(:lower)}"
  end
  alias :to_ga :to_google_analytics

  def from_google_analytics(thing)
    thing.to_s.gsub(/^ga\:/, '').underscore
  end
  alias :from_ga :from_google_analytics
end
