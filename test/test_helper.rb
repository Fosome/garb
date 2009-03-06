require 'test/unit'
require 'rubygems'
require 'mocha'
require 'shoulda'
require 'garb'

class Test::Unit::TestCase
  
  def read_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end
  
end