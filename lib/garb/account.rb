module Garb
  class Account
    URL = "https://www.google.com/analytics/feeds/accounts/"

    attr_reader :profiles, :session

    def initialize(session)
      @session = session
      @profiles = []
    end

    def request
      @request = Request.new(URL+session.email)
      @request.session = session
      @request
    end

    def all
      feed = request.get
      feed.each_entry do |entry|
        @profiles << Profile.new(entry)
      end
      @profiles
    end
  end
end