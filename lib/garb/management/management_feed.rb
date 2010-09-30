module Garb
  module ManagementFeed
    BASE_URL = "https://www.google.com/analytics/feeds/datasources/ga"

    def all(session = Session)
      build_request(session)
      parsed_response
    end

    def url
      BASE_URL + path
    end

    def parsed_response
      @parsed_response ||= Crack::XML.parse(response.body)
    end

    def response
      @response ||= request.send_request
    end

    def request(session)
      @request = DataRequest.new(session, url)
    end
  end
end
