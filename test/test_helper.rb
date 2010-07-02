$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'minitest/unit'
require 'shoulda'
require 'mocha'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'garb'

class MiniTest::Unit::TestCase

  def read_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
  
end

MiniTest::Unit.autorun