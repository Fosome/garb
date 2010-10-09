module Garb
  module Management
    class Account
      attr_reader :session, :path
      attr_reader :id, :title, :name

      def self.all(session = Session)
        feed = Feed.new(session, '/accounts') # builds request and parses response

        feed.entries.map {|entry| new(entry, session)}
      end

      def initialize(entry, session)
        @session = session
        @path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        @title = entry['title'].gsub('Google Analytics Account ', '')

        properties = Garb.parse_properties(entry)
        @id = properties["account_id"]
        @name = properties["account_name"]
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self) # will call path
      end

      def profiles
        @profiles ||= Profile.for_account(self)
      end
    end
  end
end
