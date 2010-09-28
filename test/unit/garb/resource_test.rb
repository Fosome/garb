require 'test_helper'

class TestReport
  extend Garb::Resource
end

# Most of the resource testing is done as a part of ReportTest
class ResourceTest < MiniTest::Unit::TestCase

  context "A class with Garb::Resource mixed in" do
    should "get results from GA" do
      profile = stub(:is_a? => true)
      TestReport.expects(:send_request_for_body).returns('xml')
      Garb::ReportResponse.expects(:new).with('xml', OpenStruct).returns(mock(:results => 'analytics'))

      assert_equal 'analytics', TestReport.results(profile)
    end

    should "get results from GA using a specific user session" do
      profile = '123'
      session = Garb::Session.new
      TestReport.expects(:send_request_for_body).returns('xml')
      Garb::ReportResponse.expects(:new).with('xml', OpenStruct).returns(mock(:results => 'analytics'))
      Garb::Profile.expects(:first).with(profile, session).returns(mock('Garb::Profile'))

      assert_equal 'analytics', TestReport.results(profile, :session => session)
    end

    should "permit setting a segment id" do
      TestReport.set_segment_id 1
      assert_equal "gaid::1", TestReport.segment
    end

    should "permit setting a klass used for instantiation of results" do
      TestKlass = Class.new(OpenStruct)
      TestReport.set_instance_klass TestKlass
      assert_equal TestKlass, TestReport.instance_klass
    end

    should "return an empty result set if profile is invalid" do
      profile = '123'
      TestReport.expects(:send_request_for_body).never
      Garb::ReportResponse.expects(:new).never

      Garb::Profile.expects(:first).returns(nil)
      assert_equal [], TestReport.results(profile)
    end
  end
end
