require File.join(File.dirname(__FILE__), '..', '/test_helper')

class TestReport
  include Garb::Resource
end

# Most of the resource testing is done as a part of ReportTest
class ResourceTest < Test::Unit::TestCase

  context "A class with Garb::Resource mixed in" do
    should "get results from GA" do
      profile = stub
      TestReport.expects(:send_request_for_body).returns('xml')
      Garb::ReportResponse.expects(:new).with('xml').returns(mock(:results => 'analytics'))

      assert_equal 'analytics', TestReport.results(profile)
    end
  end
end