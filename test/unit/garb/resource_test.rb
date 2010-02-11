require File.join(File.dirname(__FILE__), '..', '..', '/test_helper')

class TestReport
  extend Garb::Resource
end

# Most of the resource testing is done as a part of ReportTest
class ResourceTest < MiniTest::Unit::TestCase

  context "A class with Garb::Resource mixed in" do
    should "get results from GA" do
      profile = stub(:is_a? => true)
      TestReport.expects(:send_request_for_body).returns('xml')
      Garb::ReportResponse.expects(:new).with('xml').returns(mock(:results => 'analytics'))

      assert_equal 'analytics', TestReport.results(profile)
    end

    should "get results from GA using a specific user session" do
      profile = '123'
      session = Garb::Session.new
      TestReport.expects(:send_request_for_body).returns('xml')
      Garb::ReportResponse.expects(:new).with('xml').returns(mock(:results => 'analytics'))
      Garb::Profile.expects(:first).with(profile, session)

      assert_equal 'analytics', TestReport.results(profile, :session => session)
    end
  end
end
