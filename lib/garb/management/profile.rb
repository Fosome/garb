module Garb
  module Management
    class Profile

      include ProfileReports

      attr_accessor :session, :path
      attr_accessor :id, :table_id, :title, :account_id, :web_property_id

      def self.all(session = Session, path = '/accounts/~all/webproperties/~all/profiles')
        feed = Feed.new(session, path)
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.for_account(account)
        all(account.session, account.path+'/webproperties/~all/profiles')
      end

      def self.for_web_property(web_property)
        all(web_property.session, web_property.path+'/profiles')
      end

      def self.new_from_entry(entry, session)
        profile = new
        profile.session = session
        profile.path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        profile.properties = Garb.parse_properties(entry)
        profile
      end

      def properties=(properties)
        self.id = properties['profile_id']
        self.table_id = properties['dxp:table_id']
        self.title = properties['profile_name']
        self.account_id = properties['account_id']
        self.web_property_id = properties['web_property_id']
      end

      def goals
        Goal.for_profile(self)
      end
    end
  end
end
