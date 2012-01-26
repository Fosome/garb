module Garb
  class Session
    module Methods
      attr_accessor :auth_token, :access_token, :email, :token

      # use only for single user authentication
      def login(email, password, opts={})
        self.email = email
        auth_request = Request::Authentication.new(email, password, opts)
        self.auth_token = auth_request.auth_token(opts)
      end

      def single_user?
        auth_token && auth_token.is_a?(String)
      end

      def oauth2_user?
        !token.nil?
      end

      def oauth_user?
        !access_token.nil?
      end
    end

    include Methods
    extend Methods
  end
end
