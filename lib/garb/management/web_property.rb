module Garb
  module Management
    class WebProperty
      attr_accessor :session, :path
      attr_accessor :id, :account_id

      def self.all(session = Session, path='/accounts/~all/webproperties')
        feed = Feed.new(session, path)
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.for_account(account)
        all(account.session, account.path+'/webproperties')
      end

      def self.new_from_entry(entry, session)
        web_property = new
        web_property.session = session
        web_property.path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        web_property.properties = Garb.parse_properties(entry)
        web_property
      end

      def properties=(properties)
        self.id = properties["web_property_id"]
        self.account_id = properties["account_id"]
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end

      def goals
        @goals ||= Goal.for_web_property(self)
      end
    end
  end
end
