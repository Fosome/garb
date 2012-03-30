module Garb
  module Request
    class Data
      class ClientError < StandardError
        attr_reader :response_code

        def initialize(message = nil, response_code = nil)
          @response_code = response_code.to_i unless response_code.nil?
          super(message)
        end
      end

      SERVER_APP_KEY = 'AIzaSyB5L3vCb60CGr1tAuzPB1sX_EcEJuAa5aE'

      def initialize(session, base_url, parameters={})
        @session = session
        @base_url = base_url
        @parameters = parameters
      end

      def parameters
        @parameters ||= {}
      end

      def query_string
        parameters.merge!("key" => SERVER_APP_KEY) if @session.single_user?
        parameter_list = @parameters.map {|k,v| "#{k}=#{v}" }
        parameter_list.empty? ? '' : "?#{parameter_list.join('&')}"
      end

      def uri
        URI.parse(@base_url)
      end

      def send_request
        if @session.oauth2_user?
          response = oauth2_user_request
          raise ClientError.new(response.body, response.status) unless response.status == 200
          response
        elsif @session.single_user?
          response = single_user_request

          raise ClientError.new(response.body, response.code) unless response.kind_of?(Net::HTTPSuccess)
          response
        end
      end

      def single_user_request
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.get("#{uri.path}#{query_string}", {'Authorization' => "GoogleLogin auth=#{@session.auth_token}", 'GData-Version' => '2'})
      end

      def oauth2_user_request
        @session.token.get("#{uri}#{query_string}", {'GData-Version' => '2'})
      end
    end
  end
end
