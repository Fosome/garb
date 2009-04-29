require File.join(File.dirname(__FILE__), '..', '/test_helper')

module Garb
  class DataRequestTest < Test::Unit::TestCase
    
    context "An instance of the DataRequest class" do

      should "be able to build the query string from parameters" do
        parameters = {'ids' => '12345', 'metrics' => 'country'}
        data_request = DataRequest.new("", parameters)
        
        query_string = data_request.query_string
        
        assert_match(/^\?/, query_string)
        
        query_string.sub!(/^\?/, '')
        
        assert_equal ["ids=12345", "metrics=country"], query_string.split('&').sort
      end
      
      should "return an empty query string if parameters are empty" do
        data_request = DataRequest.new("")
        assert_equal "", data_request.query_string
      end
      
      should "be able to build a uri" do
        url        = 'http://example.com'
        expected = URI.parse('http://example.com')
        
        assert_equal expected, DataRequest.new(url).uri
      end
      
      should "be able to make a request to the GAAPI" do
        Session.expects(:auth_token).with().returns('toke')
        response = mock
        response.expects(:is_a?).with(Net::HTTPOK).returns(true)
        
        http = mock do |m|
          m.expects(:use_ssl=).with(true)
          m.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
          m.expects(:get).with('/data?key=value', 'Authorization' => 'GoogleLogin auth=toke').returns(response)
        end
        
        Net::HTTP.expects(:new).with('example.com', 443).returns(http)
        
        data_request = DataRequest.new('https://example.com/data', 'key' => 'value')
        assert_equal response, data_request.send_request
      end
    end

  end
end