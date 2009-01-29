module Garb
  class Account
    URL = "https://www.google.com/analytics/feeds/accounts/"
    
    def initialize(email, password)
      @email, @password = email, password
      @profiles = []
    end
    
    def session
      @session ||= Session.new(@email, @password)
    end

    def profiles
      if @profiles.empty?
        session.get_auth_token unless session.logged_in?
        feed = session.request(URL+@email)
        feed.each_entry do |entry|
          @profiles << Profile.new(entry, session)
        end
      end
      @profiles
    end
    
    def profile(id)
      profiles.detect{|p| p.tableId == id}
    end
  end
end