require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class ReportTest < Test::Unit::TestCase    
    context "An instance of the Report class" do
      setup do
        @now = Time.now
        Time.stubs(:now).returns(@now)
        @profile = stub(:table_id => 'ga:1234')
        @report = Report.new(@profile)
      end
      
      %w(metrics dimensions sort filters).each do |param|
        should "have parameters for #{param}" do
          assert @report.send(:"#{param}").is_a?(ReportParameter)
        end
      end

      should "have a start_date" do
        report = Report.new(@profile, :start_date => @now)
        assert_equal @now, report.start_date
      end
    
      should "have a default start_date of one month ago" do
        month_ago = @now - Report::MONTH
        assert_equal month_ago, @report.start_date
      end
    
      should "have an end_date" do
        report = Report.new(@profile, :end_date => @now)
        assert_equal @now, report.end_date
      end
    
      should "have a default end_date of now" do
        assert_equal @now, @report.end_date
      end
      
      should "have max results if set" do
        @report.max_results = 5
        assert_equal({'max-results' => 5}, @report.page_params)
      end
      
      should "have an empty hash if max results not set" do
        assert_equal({}, @report.page_params)
      end
      
      should "have a profile" do
        assert_equal @profile, @report.profile
      end
            
      should "return default params with no options" do
        Report.expects(:format_time).with(@report.start_date).returns('start')
        Report.expects(:format_time).with(@report.end_date).returns('end')
        
        params = {'ids' => 'ga:1234', 'start-date' => 'start', 'end-date' => 'end'}
        assert_equal params, @report.default_params
      end
      
      should "combine parameters for request" do
        @report.sort.expects(:to_params).returns({'sort' => 'value'})
        @report.filters.expects(:to_params).returns({'filters' => 'value'})
        @report.metrics.expects(:to_params).returns({'metrics' => 'value'})
        @report.dimensions.expects(:to_params).returns({'dimensions' => 'value'})
        
        @report.expects(:page_params).returns({})
        @report.expects(:default_params).returns({'ids' => 'ga:1234'})
        
        params = {'ids' => 'ga:1234', 'metrics' => 'value', 'dimensions' => 'value', 'sort' => 'value', 'filters' => 'value'}
        
        assert_equal params, @report.params
      end

      should "send a request and get the response body" do
        response = stub(:body => 'feed')
        data_request = mock
        data_request.expects(:send_request).with().returns(response)
        
        @report.stubs(:params).returns({'key' => 'value'})
        DataRequest.expects(:new).with(Report::URL, {'key' => 'value'}).returns(data_request)
        
        assert_equal 'feed', @report.send_request_for_body
      end
      
      should "fetch and parse all entries" do
        @report.expects(:send_request_for_body).with().returns('xml')
        ReportResponse.expects(:new).with('xml').returns(mock(:parse => ['entry']))
        assert_equal ['entry'], @report.all
      end
    end
    
    context "The Report class" do

    #   should "get the value for a given entry and property" do
    #     # entry = mock do |m|
    #     #   m.expects(:/).with().returns(['balding'])
    #     # end
    #     # assert_equal 'balding', Report.property_value(entry, Report.element_id(:balding))
    #   end
    # 
    #   should "get the values for a given entry and array of properties" do
    #     entry = stub
    #     Report.stubs(:property_value).with(entry, "balding").returns('balding')
    #     Report.stubs(:property_value).with(entry, "spaulding").returns('spaulding')
    #     
    #     data = Report.property_values(entry, [:balding, :spaulding])
    #     assert_equal 'balding', data.balding
    #     assert_equal 'spaulding', data.spaulding
    #   end
    #   
    #   should "return an ostruct for an entry" do
    #     entry = stub
    #     Report.stubs(:property_value).with(entry, "balding").returns('balding')
    #     assert_equal true, Report.property_values(entry, [:balding]).is_a?(OpenStruct)
    #   end

      should "format time" do
        t = Time.now
        assert_equal t.strftime('%Y-%m-%d'), Report.format_time(t)
      end
    end

  end
end