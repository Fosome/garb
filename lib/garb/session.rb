module Garb
  class Session
    
    def self.login(email, password)
      @email = email
      auth_request = AuthenticationRequest.new(email, password)
      @auth_token = auth_request.auth_token
    end
    
    def self.auth_token
      @auth_token
    end
    
    def self.email
      @email
    end

  end
end
