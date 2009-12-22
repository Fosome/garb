module Garb
  module Session
    extend self

    attr_accessor :auth_token, :email
    
    def login(email, password, opts={})
      self.email = email
      auth_request = AuthenticationRequest.new(email, password, opts)
      self.auth_token = auth_request.auth_token(opts)
    end
  end
end
