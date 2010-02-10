module Garb
  class DataRequest
    class ClientError < StandardError; end

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
      response = if Session.single_user?
        single_user_request
      elsif Session.oauth_user?
        oauth_user_request
      end

      raise ClientError, response.body.inspect unless response.kind_of?(Net::HTTPSuccess)
      response
    end

    def single_user_request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get("#{uri.path}#{query_string}", 'Authorization' => "GoogleLogin auth=#{Session.auth_token}")
    end

    def oauth_user_request
      Session.access_token.get("#{uri}#{query_string}")
    end
  end
end
