begin
  require 'simplecov'
  SimpleCov.adapters.define 'garb' do
    add_filter '/test/'
    add_filter '/config/'
    add_filter 'version'

    add_group 'Libraries', 'lib'
  end

  SimpleCov.start 'garb'
rescue LoadError
  puts "Install simplecov if you use 1.9 and want coverage metrics"
end

$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'shoulda'
require 'minitest/unit'
require 'mocha'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'garb'

class MiniTest::Unit::TestCase
  include Shoulda::InstanceMethods
  extend Shoulda::ClassMethods
  include Shoulda::Assertions
  extend Shoulda::Macros
  include Shoulda::Helpers

  def read_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end

  def assert_data_params(expected)
    assert_received(Garb::DataRequest, :new) {|e| e.with(Garb::Session, Garb::Model::URL, expected)}
  end
end

MiniTest::Unit.autorun
