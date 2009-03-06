module Garb
  class Session

    def self.login(email, password)
      response = AuthenticationRequest.new(email, password).send_request
      response.body.match(/Auth=(.*)/)[1]
    end
    
    # def self.auth_token
    #   @auth_token ||= AuthenticationRequest.auth_token
    # end
    
    
    # attr_accessor :auth_token, :email
    #     
    #     URL = 'https://www.google.com/accounts/ClientLogin'
    #     
    #     def initialize(email, password)
    #       @email = email
    #       @params = self.class.default_params.merge({'Email' => email, 'Passwd' => password})
    #     end
    #     
    #     def self.default_params
    #       {
    #         'Email' => '',
    #         'Passwd' => '',
    #         'accountType' => 'HOSTED_OR_GOOGLE',
    #         'service' => 'analytics',
    #         'source' => 'vigetLabs-garb-001'
    #       }
    #     end
    #     
    #     def logged_in?
    #       !(auth_token.nil? || auth_token == '')
    #     end
    #     
    #     def get_auth_token
    #       response = Request.new(URL, @params).post
    #       if response.is_a?(Net::HTTPSuccess)
    #         self.auth_token = response.body.match(/Auth=(.*)/)[1] || nil
    #       end
    #     end
    #     
    #     def request(url)
    #       request = Request.new(url)
    #       request.session = self
    #       request.get
    #     end
  end
end