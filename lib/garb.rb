require 'net/http'
require 'net/https'

require 'cgi'
require 'ostruct'

begin 
  require 'yajl/json_gem' # JSON.parse
rescue LoadError
  require 'json'
end

begin
  require 'active_support/inflector'
  require 'active_support/deprecation'
rescue LoadError
  require 'active_support'
end

module Garb
  autoload :Destination,      'garb/destination'
  autoload :FilterParameters, 'garb/filter_parameters'
  autoload :Model,            'garb/model'
  autoload :ProfileReports,   'garb/profile_reports'
  autoload :ReportParameter,  'garb/report_parameter'
  autoload :ReportResponse,   'garb/report_response'
  autoload :ResultSet,        'garb/result_set'
  autoload :Session,          'garb/session'
  autoload :Step,             'garb/step'
  autoload :Version,          'garb/version'

  module Management
    autoload :Account,     'garb/management/account'
    autoload :Feed,        'garb/management/feed'
    autoload :Goal,        'garb/management/goal'
    autoload :Profile,     'garb/management/profile'
    autoload :Segment,     'garb/management/segment'
    autoload :WebProperty, 'garb/management/web_property'
  end

  module Request
    autoload :Authentication, "garb/request/authentication"
    autoload :Data,           'garb/request/data'
  end
end

# require 'garb/account_feed_request'
# require 'garb/resource'
# require 'garb/report'


require 'support'

module Garb
  GA = "http://schemas.google.com/analytics/2008"

  extend self

  class << self
    attr_accessor :proxy_address, :proxy_port, :proxy_user, :proxy_password
    attr_writer   :read_timeout
  end

  def read_timeout
    @read_timeout || 60
  end

  def to_google_analytics(thing)
    return thing.to_google_analytics if thing.respond_to?(:to_google_analytics)

    "ga:#{thing.to_s.camelize(:lower)}"
  end
  alias :to_ga :to_google_analytics

  def from_google_analytics(thing)
    thing.to_s.gsub(/^ga\:/, '').underscore
  end
  alias :from_ga :from_google_analytics

  def parse_properties(entry)
    Hash[entry['dxp$property'].map {|p| [Garb.from_ga(p['name']),p['value']]}]
  end

  def parse_link(entry, rel)
    entry['link'].detect {|link| link["rel"] == rel}['href']
  end

  # new(address, port = nil, p_addr = nil, p_port = nil, p_user = nil, p_pass = nil)

  # opts => open_timeout, read_timeout, ssl_timeout
  # probably just support open_timeout
end
