module Garb
  module Management
    class Account
      attr_accessor :session, :path
      attr_accessor :id, :title, :name

      def self.all(session = Session)
        feed = Feed.new(session, '/accounts')
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.new_from_entry(entry, session)
        account = new
        account.session = session
        account.path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        account.title = entry['title'].gsub('Google Analytics Account ', '') # can we get this in properties=?
        account.properties = Garb.parse_properties(entry)
        account
      end

      def properties=(properties)
        self.id = properties["account_id"]
        self.name = properties["account_name"]
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
      end

      def profiles
        @profiles ||= Profile.for_account(self)
      end

      def goals
        @goals ||= Goal.for_account(self)
      end
    end
  end
end
