require 'test_helper'

class ResultKlass
  def initialize(attrs)
  end
end

module Garb
  class ModelTest < MiniTest::Unit::TestCase
    context "A class extended with Garb::Model" do
      setup do
        @test_model = Class.new
        @test_model.extend(Garb::Model)
      end

      # public API
      should "be able to define metrics" do
        report_parameter = stub(:<<)
        ReportParameter.stubs(:new).returns(report_parameter)

        @test_model.metrics :visits, :pageviews

        assert_received(ReportParameter, :new) {|e| e.with(:metrics)}
        assert_received(report_parameter, :<<) {|e| e.with([:visits, :pageviews])}
      end

      should "be able to define dimensions" do
        report_parameter = stub(:<<)
        ReportParameter.stubs(:new).returns(report_parameter)

        @test_model.dimensions :page_path, :event_category

        assert_received(ReportParameter, :new) {|e| e.with(:dimensions)}
        assert_received(report_parameter, :<<) {|e| e.with([:page_path, :event_category])}
      end

      should "be able to se the instance klass" do
        @test_model.set_instance_klass ResultKlass
        assert_equal ResultKlass, @test_model.instance_klass
      end

      context "with a profile" do
        setup do
          entry = {
            "title" => "Google Analytics Profile example.com",
            "link" => [{"rel" => "self", "href" => Garb::Management::Feed::BASE_URL+"/accounts/1189765/webproperties/UA-1189765-1/profiles/98765"}],
            "dxp:property" => [
              {"name" => "ga:profileId", "value" => "98765"},
              {"name" => "ga:accountId", "value" => "1189765"},
              {"name" => "ga:webPropertyId", "value" => 'UA-1189765-1'}
            ]
          }

          @profile = Garb::Management::Profile.new_from_entry(entry, Session)
        end

        context "when getting results" do
          setup do
            @response = stub(:body => "raw report data")
            DataRequest.stubs(:new).returns(stub(:send_request => @response))
            ReportResponse.stubs(:new).returns(stub(:results => ['result']))

            @test_model.stubs(:metrics).returns(stub(:to_params => {'metrics' => 'ga:visits'}))
            @test_model.stubs(:dimensions).returns(stub(:to_params => {'dimensions' => 'ga:pagePath'}))

            now = Time.now
            Time.stubs(:now).returns(now)

            # p @profile.id

            @params = {'ids' => Garb.to_ga(@profile.id),
              'start-date' => (now - Model::MONTH).strftime('%Y-%m-%d'),
              'end-date' => now.strftime('%Y-%m-%d'),
              'metrics' => 'ga:visits',
              'dimensions' => 'ga:pagePath'}
          end

          should "get all results" do
            assert_equal ['result'], @test_model.results(@profile)
            assert_received(ReportResponse, :new) {|e| e.with("raw report data", OpenStruct)}
            assert_data_params(@params)
          end

          should "be able to filter" do
            filter_parameters = stub(:<<)
            FilterParameters.stubs(:new).returns(stub(:parameters => filter_parameters, :to_params => {'filters' => "params"}))
            assert_equal ['result'], @test_model.results(@profile, :filters => {:page_path => '/'})

            assert_data_params(@params.merge({'filters' => 'params'}))
            assert_received(filter_parameters, :<<) {|e| e.with({:page_path => '/'})}
          end

          should "be able to set the filter segment by id" do
            assert_equal ['result'], @test_model.results(@profile, :segment_id => 1)
            assert_data_params(@params.merge({'segment' => 'gaid::1'}))
          end

          should "be able to sort" do
            sort_parameter = stub(:<<)
            sort_parameter.stubs(:to_params => {'sort' => 'sort value'})
            ReportParameter.stubs(:new).returns(sort_parameter)

            assert_equal ['result'], @test_model.results(@profile, :sort => [:visits])
            assert_received(sort_parameter, :<<) {|e| e.with([:visits])}
            assert_data_params(@params.merge({'sort' => 'sort value'}))
          end

          should "be able to limit" do
            assert_equal ['result'], @test_model.results(@profile, :limit => 20)
            assert_data_params(@params.merge({'max-results' => 20}))
          end

          should "be able to offset" do
            assert_equal ['result'], @test_model.results(@profile, :offset => 10)
            assert_data_params(@params.merge({'start-index' => 10}))
          end

          should "be able to shift the date range" do
            start_date = (Time.now - 1296000)
            end_date = Time.now

            assert_equal ['result'], @test_model.results(@profile, :start_date => start_date, :end_date => end_date)
            assert_data_params(@params.merge({'start-date' => start_date.strftime('%Y-%m-%d'), 'end-date' => end_date.strftime('%Y-%m-%d')}))
          end

          should "return a set of results in the defined class" do
            @test_model.stubs(:instance_klass).returns(ResultKlass)

            assert_equal ['result'], @test_model.results(@profile)
            assert_received(ReportResponse, :new) {|e| e.with("raw report data", ResultKlass)}
          end
        end

        # should "return results as an array of the class it belongs to, if that class is an ActiveRecord descendant"
        # should "return results as an array of the class it belongs to, if that class is a DataMapper descendant"
        # should "return results as an array of the class it belongs to, if that class is a MongoMapper descendant"
        # should "return results as an array of the class it belongs to, if that class is a Mongoid descendant"
      end
    end
  end
end
