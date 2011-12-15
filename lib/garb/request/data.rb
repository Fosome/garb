module Garb
  module Request
    class Data
      class ClientError < StandardError; end

      attr_writer :format

      def initialize(session, base_url, parameters={})
        @session = session
        @base_url = base_url
        @parameters = parameters
      end

      def parameters
        @parameters ||= {}
      end

      def query_string
        parameters.merge!("alt" => format)
        parameter_list = @parameters.map {|k,v| "#{k}=#{v}" }
        parameter_list.empty? ? '' : "?#{parameter_list.join('&')}"
      end

      def format
        @format ||= "json" # TODO Support other formats?
      end

      def uri
        URI.parse(@base_url)
      end

      def send_request
        response = if @session.single_user?
          single_user_request
        elsif @session.oauth_user?
          oauth_user_request
        end

        raise ClientError, response.body.inspect unless response.kind_of?(Net::HTTPSuccess) || (response.respond_to?(:status) && response.status == 200)
        response
      end

      def single_user_request
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.get("#{uri.path}#{query_string}", {'Authorization' => "GoogleLogin auth=#{@session.auth_token}", 'GData-Version' => '2'})
      end

      def oauth_user_request
        @session.access_token.get("#{uri}#{query_string}", {'GData-Version' => '2'})
      end
    end
  end
end
