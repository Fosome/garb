module Garb
  class AuthenticationRequest
    class AuthError < StandardError;end
    
    URL = 'https://www.google.com/accounts/ClientLogin'
    
    def initialize(email, password)
      @email = email
      @password = password
    end
    
    def parameters
      {
        'Email'       => @email,
        'Passwd'      => @password,
        'accountType' => 'HOSTED_OR_GOOGLE',
        'service'     => 'analytics',
        'source'      => 'vigetLabs-garb-001'
      }
    end
    
    def uri
      URI.parse(URL)
    end
    
    def send_request      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.cert_store = cert_store
      http.request(build_request) do |response|
        raise AuthError unless response.is_a?(Net::HTTPOK)
      end
    end

    def cert_store
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      store
    end

    def build_request
      post = Net::HTTP::Post.new(uri.path)
      post.set_form_data(parameters)
      post
    end
    
    def auth_token
      send_request.body.match(/^Auth=(.*)$/)[1]
    end
    
  end
end
