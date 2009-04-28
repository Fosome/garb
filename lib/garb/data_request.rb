module Garb
  class DataRequest

    def initialize(base_url, parameters={})
      @base_url = base_url
      @parameters = parameters
    end

    def query_string
      parameter_list = @parameters.map {|k,v| "#{k}=#{v}" }
      parameter_list.empty? ? '' : "?#{parameter_list.join('&')}"
    end

    def uri
      URI.parse(@base_url)
    end

    def send_request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.get("#{uri.path}#{query_string}", 'Authorization' => "GoogleLogin auth=#{Session.auth_token}")
      raise response.body.inspect unless response.is_a?(Net::HTTPOK)
      response
    end

  end
end