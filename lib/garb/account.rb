module Garb
  class Account
    URL = "https://www.google.com/analytics/feeds/accounts/"
    
    def initialize(email, password)
      @email, @password = email, password
      @profiles = {}
    end
    
    def session
      @session ||= Session.new(@email, @password)
    end

    def profiles
      if @profiles.empty?
        session.get_auth_token unless session.logged_in?
        feed = session.request(URL+@email)
        # table_id = ((feed/:entry).first/:"dxp:tableId")
        # puts table_id.inner_text.inspect

        (feed/:entry).each do |entry|
          profile = Profile.new(entry, session)
          @profiles.merge!(profile.table_id => profile)
        end
      end
      @profiles
    end
  end
end