require File.join(File.dirname(__FILE__), 'test_helper')

module Garb
  class ReportTest < Test::Unit::TestCase
    context "The Report class" do
      should "not convert a ga analytic property name in string format into an atom feed element identifier" do
        assert_equal 'ga:tag', Report.element_id('ga:tag')
        assert_equal '-ga:bob', Report.element_id('-ga:bob')
      end

      should "convert a ga analytic property name in symbol format into an atom feed element identifier" do
        assert_equal 'ga:tag', Report.element_id(:tag)
      end

      should "get the value for a given entry and property" do
        entry = stub do |s|
          s.stubs(:[]).with(GA, 'balding').returns(['balding'])
        end
        assert_equal 'balding', Report.property_value(entry, :balding)
      end

      should "get the values for a given entry and array of properties" do
        entry = stub
        Report.stubs(:property_value).with(entry, :balding).returns('balding')
        Report.stubs(:property_value).with(entry, :spaulding).returns('spaulding')
        assert_equal({:balding => 'balding', :spaulding => 'spaulding'}, Report.property_values(entry, [:balding, :spaulding]))
      end
      
      should "format time" do
        t = Time.now
        assert_equal t.strftime('%Y-%m-%d'), Report.format_time(t)
      end
    end

    context "An instance of the Report class" do
      setup do
        @session = stub
        @profile = stub(:tableId => 'table', :session => @session)
        @now = Time.now
        Time.stubs(:now).returns(@now)
        @report = Report.new(@profile)
      end
      
      should "have a collection of metrics" do
        report = Report.new(@profile, :metrics => [:pageviews])
        assert_equal [:pageviews], report.metrics
      end

      should "have a collection of dimensions" do
        report = Report.new(@profile, :dimensions => [:browser])
        assert_equal [:browser], report.dimensions
      end
      
      should "have metrics and dimensions" do
        report = Report.new(@profile, :metrics => [:pageviews], :dimensions => [:browser])
        assert_equal [:pageviews], report.metrics
        assert_equal [:browser], report.dimensions
      end

      should "have an empty array of metrics by default" do
        assert_equal [], @report.metrics
      end
      
      should "have an empty array of dimensions by default" do
        assert_equal [], @report.dimensions
      end
      
      should "have an empty array of dimensions and metrics for sort by default" do
        assert_equal [], @report.sort
      end
      
      should "have an empty array for filters by default" do
        assert_equal [], @report.filters
      end
      
      should "parameterize metrics" do
        report = Report.new(@profile, :metrics => [:pageviews, :bounces])
        assert_equal({'metrics' => 'ga:pageviews,ga:bounces'}, report.metric_params)
      end
      
      should "parameterize dimensions" do
        report = Report.new(@profile, :dimensions => [:browser, :city])
        assert_equal({'dimensions' => 'ga:browser,ga:city'}, report.dimension_params)
      end
      
      should "parameterize sort" do
        report = Report.new(@profile, :dimensions => [:browser, :city], :sort => [:browser, :city])
        assert_equal({'sort' => 'ga:browser,ga:city'}, report.sort_params)
      end
      
      should "parameterize filters" do
        @report.filters << "ga:browser%3D%3Dsafari"
        @report.filters << "ga:pageviews%3E100"
        assert_equal({'filters' => 'ga:browser%3D%3Dsafari,ga:pageviews%3E100'}, @report.filters_params)
      end
      
      should "parameterize filters in a hash" do
        @report.filters << {:pageviews => '>100'}
        @report.filters << {:browser => '==safari'}
        assert_equal({'filters' => 'ga:pageviews%3E100,ga:browser%3D%3Dsafari'}, @report.filters_params)
      end
      
      should "join filter in a hash with a semicolon" do
        @report.filters << {:pageviews => '>100', :browser => '==safari'}
        assert_equal 2, @report.filters_params['filters'].split(';').size
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
        @report.stubs(:start_date).returns(@now)
        @report.stubs(:end_date).returns(@now)
        Report.stubs(:format_time).with(@now).times(2).returns('2k9er')
        params = {'ids' => 'table', 'start-date' => '2k9er', 'end-date' => '2k9er'}
        assert_equal params, @report.default_params
      end
      
      should "combine params for metrics, dimensions, sort, and defaults" do
        @report.stubs(:default_params).returns({'ids' => 'table'})
        @report.stubs(:metric_params).returns({'metrics' => 'ga:pageviews'})
        @report.stubs(:dimension_params).returns({'dimensions' => 'ga:browser'})
        @report.stubs(:sort_params).returns({'sort' => '-ga:browser'})

        params = {'ids' => 'table', 'metrics' => 'ga:pageviews', 'dimensions' => 'ga:browser', 'sort' => '-ga:browser'}
        assert_equal params, @report.params
      end
            
      should "create a new request with URL and params" do
        request_stub = stub
        request_stub.stubs(:session=).with(@profile.session)
        Request.stubs(:new).with(Report::URL, @report.params).returns(request_stub)
        assert_equal request_stub, @report.request
      end
      
      should "collect the property values for each entry returned from the analytics feed" do
        report = Report.new(@profile, :metrics => [:pageviews, :bounces], :dimensions => [:browser])
        entry_params = {:pageviews => '120', :bounces => '2', :browser => 'firefox'}
        entry_stub = stub
        
        feed_stub = stub do |s|
          s.stubs(:each_entry).yields(entry_stub)
        end
        
        Report.stubs(:property_values).with(entry_stub, report.metrics+report.dimensions).returns(entry_params)
        report.stubs(:request).returns(stub(:get => feed_stub))
        assert_equal([entry_params], report.all)
      end
    end
  end
end