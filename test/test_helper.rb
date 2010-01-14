$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'minitest/unit'
require 'shoulda'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/garb'

class MiniTest::Unit::TestCase

  def read_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
  
end

MiniTest::Unit.autorun