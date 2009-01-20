module Garb
  class Request
    
    attr_accessor :session
    
    def initialize(url, parameters={})
      @url        = URI.parse(url)
      @parameters = parameters
    end

    def http
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
       
    def post
      request = Net::HTTP::Post.new(@url.path)
      request.set_form_data(@parameters)
      self.http.request(request)
    end
    
    def get
      request = Net::HTTP::Get.new(@url.path+url_parameters)
      request['Authorization'] = "GoogleLogin auth=#{@session.auth_token}"
      response = self.http.request(request)
      begin
        Atom::Feed.load_feed response.body if response
      rescue ArgumentError
        puts response.body.inspect
      end
    end
    
    def url_parameters
      @parameters.empty? ? "" : "?" + @parameters.map{|k,v| "#{k}=#{v}"}.join("&")
    end
    
  end
end