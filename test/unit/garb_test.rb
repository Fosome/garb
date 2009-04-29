require File.join(File.dirname(__FILE__), '..', '/test_helper')

class GarbTest < Test::Unit::TestCase
  context "A green egg" do
    should "be served with ham" do
      assert true
    end
  end  
end