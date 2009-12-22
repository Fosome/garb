$:.unshift File.expand_path(File.dirname(__FILE__))

require 'net/http'
require 'net/https'
require 'rubygems'
require 'cgi'
require 'ostruct'
require 'happymapper'

require 'garb/version'
require 'garb/authentication_request'
require 'garb/data_request'
require 'garb/session'
require 'garb/profile'
require 'garb/account'
require 'garb/report_parameter'
require 'garb/report_response'
require 'garb/resource'
require 'garb/report'

require 'extensions/string'
require 'extensions/operator'
require 'extensions/symbol'
require 'extensions/array'

module Garb
  GA = "http://schemas.google.com/analytics/2008"
end
