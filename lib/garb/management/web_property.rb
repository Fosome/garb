module Garb
  module Management
    class WebProperty
      attr_reader :session, :path
      attr_reader :id, :account_id

      def self.all(session = Session, path='/accounts/~all/webproperties')
        feed = Feed.new(session, path)
        feed.entries.map {|entry| new(entry, session)}
      end

      def self.for_account(account)
        all(account.session, account.path+'/webproperties')
      end

      def initialize(entry, session)
        @session = session
        @path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')

        properties = Garb.parse_properties(entry)
        @id = properties["web_property_id"]
        @account_id = properties["account_id"]
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end
    end
  end
end
