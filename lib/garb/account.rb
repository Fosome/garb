module Garb
  class Account
    URL = "https://www.google.com/analytics/feeds/accounts/"

    # def initialize(session)
    #   @session = session
    #   @profiles = []
    # end
    
    def initialize(email, password)
      @email, @password = email, password
      @profiles = []
    end
    
    def session
      @session ||= Session.new(@email, @password)
    end

    def request
      @request = Request.new(URL+session.email)
      @request.session = session
      @request
    end

    def profiles
      if @profiles.empty?
        feed = session.request(URL+@email)
        feed.each_entry do |entry|
          @profiles << Profile.new(entry)
        end
      end
      @profiles
    end
  end
end