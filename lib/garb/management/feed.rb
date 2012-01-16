module Garb
  module Management
    class Feed
      require 'xmlsimple'
      
      BASE_URL = "https://www.google.com/analytics/feeds/datasources/ga"

      attr_reader :request

      def initialize(session, path)
        @request = Request::Data.new(session, BASE_URL+path)
      end

      def parsed_response
        # @parsed_response ||= JSON.parse(response.body)
        @parsed_response ||= {'feed' => XmlSimple.xml_in(response.body)}
      end

      def entries
        # possible to have nil entries, yuck
        parsed_response ? [parsed_response['feed']['entry']].flatten.compact : []
      end

      def response
        @response ||= request.send_request
      end
    end
  end
end
