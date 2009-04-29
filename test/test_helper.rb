$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/garb'

class Test::Unit::TestCase
  
  def read_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
  
end