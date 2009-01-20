module Garb
  class Session
    
    attr_accessor :auth_token, :email
    
    URL = 'https://www.google.com/accounts/ClientLogin'
    
    def initialize(email, password)
      @email = email
      @params = self.class.default_params.merge({'Email' => email, 'Passwd' => password})
    end
    
    def self.default_params
      {
        'Email' => '',
        'Passwd' => '',
        'accountType' => 'HOSTED_OR_GOOGLE',
        'service' => 'analytics',
        'source' => 'vigetLabs-garb-001'
      }
    end
    
    def logged_in?
      !(auth_token.nil? || auth_token == '')
    end
    
    def get_auth_token
      request = Request.new(URL, @params)
      response = request.post
      self.auth_token = response.body.match(/Auth=(.*)/)[1] || nil
      logged_in?
    end
  end
end