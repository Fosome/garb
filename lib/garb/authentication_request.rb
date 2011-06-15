module Garb
  class AuthenticationRequest
    class AuthError < StandardError;end

    URL = 'https://www.google.com/accounts/ClientLogin'

    def initialize(email, password, opts={})
      @email = email
      @password = password
      @account_type = opts.fetch(:account_type, 'HOSTED_OR_GOOGLE')
      proxy = opts.fetch(:proxy, nil)
      @proxy_host, @proxy_port = proxy.split(":") unless(proxy.nil?)
    end

    def parameters
      {
        'Email'       => @email,
        'Passwd'      => @password,
        'accountType' => @account_type,
        'service'     => 'analytics',
        'source'      => 'vigetLabs-garb-001'
      }
    end
    
    def uri
      URI.parse(URL)
    end

    def send_request(ssl_mode)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_host, @proxy_port, {:open_timeout => 30, :read_timeout => 30, :ssl_timeout => 30})
      http.use_ssl = true
      http.verify_mode = ssl_mode

      if ssl_mode == OpenSSL::SSL::VERIFY_PEER
        http.ca_file = CA_CERT_FILE
      end
      http.request(build_request) do |response|
        raise AuthError unless response.is_a?(Net::HTTPOK)
      end
    end

    def build_request
      post = Net::HTTP::Post.new(uri.path)
      post.set_form_data(parameters)
      post
    end
    
    def auth_token(opts={})
      ssl_mode = opts[:secure] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
      send_request(ssl_mode).body.match(/^Auth=(.*)$/)[1]
    end

  end
end

